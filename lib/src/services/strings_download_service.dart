// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/utils/url/urls.dart';

/// Downloads an app's audio pack (hosted on the web deploy) once per install and
/// extracts it to local storage so the native/C++ engine can open real files.
///
/// Supports:
///  1. Standard single-request ZIP download (default, legacy behavior for smaller packs).
///  2. Chunked folder-by-folder downloads (opt-in via [chunks], preventing timeouts on large packs).
///  3. Custom [packValidator] to verify required audio structure on disk.
///  4. [missingChunksResolver] to self-heal and fetch only missing parts.
class StringsDownloadService {
  static final StringsDownloadService _instance =
      StringsDownloadService._internal();

  Directory? dir;
  final String folderAndFileName = "audio_strings";

  /// Guards against two overlapping download attempts (e.g. splash + home both
  /// calling in on a fast first launch).
  bool _inFlight = false;

  factory StringsDownloadService() {
    return _instance;
  }

  StringsDownloadService._internal() {
    init();
  }

  Future<void> init() async {
    if (!kIsWeb) {
      dir = await (Platform.isIOS
          ? getApplicationSupportDirectory()
          : getApplicationDocumentsDirectory());
      Directory directory = Directory("${dir?.path}/assets/");
      await directory.create(recursive: true);
    }
  }

  /// Absolute path to the extracted asset root (`<dir>/assets`).
  String? get assetsPath => dir == null ? null : "${dir!.path}/assets";

  /// Per-app sentinel marking a completed, verified extraction. Kept on disk so
  /// it survives `LocalDB.clearLocalDB()`. Deliberately NOT a dotfile — hidden
  /// files behaved unreliably across launches on iOS.
  File _readyMarker(String appName) =>
      File("${dir!.path}/assets/audio_${appName}_ready.flag");

  /// Marks that a first download has been attempted (whether or not it
  /// succeeded). Used to show the progress dialog only on the very first try;
  /// later retries run silently in the background and self-heal once the
  /// server-side pack appears.
  File _attemptMarker(String appName) =>
      File("${dir!.path}/assets/audio_${appName}_attempted.flag");

  /// Records which asset-pack version this install last extracted. The app
  /// tells us the version it expects via [isStringsDownloaded]'s `packVersion`;
  /// a re-download runs only when the version on disk is older than that.
  File _versionMarker(String appName) =>
      File("${dir!.path}/assets/audio_${appName}_version.txt");

  /// The pack version currently on disk. Returns 0 when nothing is downloaded.
  Future<int> _storedVersion(String appName) async {
    if (dir == null) await init();
    if (dir == null) return 0;
    try {
      final vf = _versionMarker(appName);
      if (await vf.exists()) {
        final v = int.tryParse((await vf.readAsString()).trim());
        if (v != null) return v;
      }
      if (await _readyMarker(appName).exists() || await _hasExtractedAudio()) {
        return 1;
      }
    } catch (_) {}
    return 0;
  }

  /// True when this install already holds the pack AT OR ABOVE the version the
  /// app expects. Accepts the sentinel OR real extracted audio on disk (or
  /// [packValidator] if provided), so a flaky marker write can never force a
  /// re-download when the pack is there — but a version older than [packVersion]
  /// or an incomplete pack always triggers a refresh.
  Future<bool> _alreadyProvisioned(String appName, int packVersion,
      {Future<bool> Function(String assetsPath)? packValidator}) async {
    if (dir == null) await init();
    if (dir == null) return false;
    try {
      bool hasPack = false;
      if (packValidator != null) {
        final path = assetsPath;
        if (path != null) {
          hasPack = await packValidator(path);
        }
      } else {
        hasPack =
            await _readyMarker(appName).exists() || await _hasExtractedAudio();
      }
      if (!hasPack) return false;
      return await _storedVersion(appName) >= packVersion;
    } catch (_) {
      return false;
    }
  }

  /// True when at least one real audio file has already been extracted into the
  /// pack directory by a previous successful download.
  Future<bool> _hasExtractedAudio() async {
    if (dir == null) await init();
    if (dir == null) return false;
    try {
      final root = Directory("${dir!.path}/assets");
      if (!await root.exists()) return false;
      await for (final e in root.list(recursive: true, followLinks: false)) {
        if (e is File) {
          final p = e.path.toLowerCase();
          if (p.endsWith('.mp3') || p.endsWith('.wav')) return true;
        }
      }
    } catch (_) {}
    return false;
  }

  /// Downloads [url] to a file named [filename] under the app's pack directory
  /// using the OS-level background downloader (iOS URLSession / Android
  /// WorkManager). The transfer keeps running when the app is backgrounded or
  /// the screen is locked, and the package retries transient failures itself.
  /// Returns the completed File, or null on failure. [onProgress] reports 0..1.
  ///
  /// Resume-after-force-kill is handled a level up: each chunk is extracted and
  /// verified as it lands, so the next launch only re-fetches the pieces that
  /// are still missing (see [isStringsDownloaded] + the packValidator).
  Future<File?> _bgDownload(
    String url,
    String filename, {
    void Function(double fraction)? onProgress,
  }) async {
    // Keep the zip next to the extracted pack: iOS app-support, Android
    // app-documents — matching [dir] so cleanup/paths line up.
    final base = Platform.isIOS
        ? BaseDirectory.applicationSupport
        : BaseDirectory.applicationDocuments;
    final task = DownloadTask(
      url: url,
      filename: filename,
      baseDirectory: base,
      updates: Updates.statusAndProgress,
      allowPause: true,
      retries: 3,
    );
    final result = await FileDownloader().download(
      task,
      onProgress: (p) {
        if (onProgress != null && p >= 0) onProgress(p.clamp(0.0, 1.0));
      },
    );
    if (result.status == TaskStatus.complete) {
      final f = File(await task.filePath());
      if (await f.exists() && await f.length() > 0) return f;
    }
    return null;
  }

  String _formatChunkLabel(String chunk) {
    if (chunk == 'drum_beats') return 'drum beats';
    if (chunk.contains('/')) {
      final parts = chunk.split(',');
      final first = parts.first.split('/').last;
      return first;
    }
    return chunk;
  }

  /// Downloads multiple smaller chunks sequentially to avoid server timeouts
  /// on large asset libraries. Reports combined progress and verifies the pack.
  Future<bool> _downloadChunks(
    BuildContext? context,
    String appName,
    List<String> chunksToDownload,
    bool showUi,
    int packVersion,
    Future<bool> Function(String assetsPath)? packValidator,
  ) async {
    final progress = ValueNotifier<double?>(null);
    final statusText = ValueNotifier<String?>('Starting download…');
    final dialog = _AudioDownloadDialog.show(
      showUi ? context : null,
      progress,
      statusMessage: statusText,
    );

    bool allSucceeded = true;
    final totalChunks = chunksToDownload.length;

    for (int i = 0; i < totalChunks; i++) {
      final chunk = chunksToDownload[i];
      final label = _formatChunkLabel(chunk);
      statusText.value = 'Downloading $label (${i + 1}/$totalChunks)…';
      progress.value = totalChunks > 0 ? i / totalChunks : null;

      final url =
          '${Urls.downloadAssetsUrl}$appName&folders=${Uri.encodeQueryComponent(chunk)}';
      final zipName = 'chunk_${DateTime.now().microsecondsSinceEpoch}.zip';

      bool chunkOk = false;
      // The background downloader retries transient network errors on its own
      // (retries: 3); this outer loop only guards an extract/IO failure.
      const maxAttempts = 2;
      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        try {
          debugPrint(
              '[AudioDL] Chunk ${i + 1}/$totalChunks (attempt $attempt/$maxAttempts): $chunk');
          final file = await _bgDownload(
            url,
            zipName,
            onProgress: (f) => progress.value = (i + f) / totalChunks,
          );
          if (file != null) {
            extractFiles(appName, file);
            chunkOk = true;
            try {
              await file.delete();
            } catch (_) {}
            break;
          }
        } catch (ex) {
          debugPrint(
              '[AudioDL] Chunk ${i + 1}/$totalChunks attempt $attempt failed: $ex');
        }
        if (attempt < maxAttempts) {
          await Future<void>.delayed(Duration(seconds: attempt));
        }
      }

      if (!chunkOk) {
        allSucceeded = false;
        debugPrint('[AudioDL] Chunk failed permanently: $chunk');
        break;
      }

      progress.value = (i + 1) / totalChunks;
    }

    if (allSucceeded) {
      statusText.value = 'Verifying audio files…';
      bool verified = true;
      if (packValidator != null && assetsPath != null) {
        verified = await packValidator(assetsPath!);
      }

      if (verified) {
        final marker = _readyMarker(appName);
        await marker.create(recursive: true);
        try {
          await _versionMarker(appName)
              .writeAsString('$packVersion', flush: true);
        } catch (_) {}
        await LocalDB.saveIsFilesDownloaded(true);
        await dialog.close();
        if (showUi && context != null && context.mounted) {
          showToast(
              context: context, message: "Audio files ready", isError: false);
        }
        return true;
      } else {
        debugPrint('[AudioDL] Post-download verification failed');
        try {
          final marker = _readyMarker(appName);
          if (await marker.exists()) await marker.delete();
        } catch (_) {}
        await dialog.close();
        if (showUi && context != null && context.mounted) {
          showToast(
            context: context,
            message: "Audio verification failed. Some files may be missing.",
            isError: true,
          );
        }
        return false;
      }
    } else {
      await dialog.close();
      await LocalDB.saveIsFilesDownloaded(false);
      try {
        final marker = _readyMarker(appName);
        if (await marker.exists()) await marker.delete();
      } catch (_) {}
      if (showUi && context != null && context.mounted) {
        showToast(
          context: context,
          message:
              "Could not download all audio files. Please check your connection.",
          isError: true,
        );
      }
      return false;
    }
  }

  /// [showUi] drives whether the modal dialog and toasts appear. It is true on
  /// the first attempt of an install and false for silent background retries.
  Future<bool> _downloadStrings(BuildContext? context, String appName,
      bool showUi, int packVersion) async {
    final progress = ValueNotifier<double?>(null);
    final dialog =
        _AudioDownloadDialog.show(showUi ? context : null, progress);

    final url = '${Urls.downloadAssetsUrl}$appName';
    try {
      final file = await _bgDownload(
        url,
        '$folderAndFileName.zip',
        onProgress: (f) => progress.value = f,
      );
      if (file == null) {
        throw Exception('background download did not complete');
      }

      extractFiles(appName, file);

      final marker = _readyMarker(appName);
      await marker.create(recursive: true);
      try {
        await _versionMarker(appName)
            .writeAsString('$packVersion', flush: true);
      } catch (_) {}
      debugPrint('[AudioDL] wrote marker=${marker.path} v=$packVersion '
          'exists=${await marker.exists()}');
      await LocalDB.saveIsFilesDownloaded(true);

      try {
        if (await file.exists()) await file.delete();
      } catch (_) {}

      await dialog.close();
      if (showUi && context != null && context.mounted) {
        showToast(
            context: context, message: "Audio files ready", isError: false);
      }
      return true;
    } on Exception catch (ex) {
      await dialog.close();
      await LocalDB.saveIsFilesDownloaded(false);
      debugPrint('[AudioDL] FAILED url=$url ex=$ex');
      Log.ex('downloadString exception==$ex', name: url);
      return false;
    }
  }

  /// Ensures the audio pack is present and up to date. Downloads + extracts on
  /// first install, and again only when [packVersion] is higher than the
  /// version already on disk.
  ///
  /// Optional parameters:
  /// - [chunks]: When provided, splits the download into discrete folder requests
  ///   (avoids PHP timeouts on large multi-megabyte packs).
  /// - [packValidator]: When provided, performs a structural check on disk to
  ///   confirm all expected assets exist. If validation fails, triggers a repair.
  /// - [missingChunksResolver]: Resolves which subset of [chunks] is missing on disk.
  /// - [force]: Bypasses the provisioned gate (useful for user-triggered "Repair").
  /// - [context]: Explicit BuildContext for showing the download modal.
  Future<bool> isStringsDownloaded(
    String appName, {
    int packVersion = 1,
    List<String>? chunks,
    Future<bool> Function(String assetsPath)? packValidator,
    Future<List<String>> Function(String assetsPath)? missingChunksResolver,
    bool force = false,
    BuildContext? context,
  }) async {
    if (kIsWeb) return false;

    // Storage directory check — ensures dir is initialized
    if (dir == null) {
      await init();
    }

    final packName = Utils.getMtAppName;
    final storedVersion = await _storedVersion(packName);

    // Verify current on-disk integrity if validator is provided
    bool isComplete = true;
    if (packValidator != null) {
      final path = assetsPath;
      if (path != null) {
        isComplete = await packValidator(path);
      } else {
        isComplete = false;
      }
      if (!isComplete) {
        try {
          final marker = _readyMarker(packName);
          if (await marker.exists()) await marker.delete();
        } catch (_) {}
      }
    }

    final provisioned = !force &&
        isComplete &&
        (await _alreadyProvisioned(packName, packVersion,
            packValidator: packValidator));

    debugPrint('[AudioDL] dir=${dir?.path}');
    debugPrint('[AudioDL] pack=$packName marker=${_readyMarker(packName).path}');
    debugPrint('[AudioDL] stored=v$storedVersion want=v$packVersion '
        'provisioned=$provisioned isComplete=$isComplete force=$force');
    if (provisioned) {
      return false;
    }

    if (_inFlight) return false;
    _inFlight = true;
    try {
      final bool versionUpgrade =
          storedVersion > 0 && storedVersion < packVersion;
      bool firstAttempt = true;
      try {
        firstAttempt = !await _attemptMarker(packName).exists();
      } catch (_) {}

      final bool showUi = force ||
          firstAttempt ||
          versionUpgrade ||
          (packValidator != null && !isComplete);

      final ctx = context ?? Nav.key.currentState?.context;

      bool ok;
      if (chunks != null && chunks.isNotEmpty) {
        List<String> chunksToDownload;
        if (missingChunksResolver != null && assetsPath != null) {
          final missing = await missingChunksResolver(assetsPath!);
          if (missing.isNotEmpty) {
            chunksToDownload = missing;
          } else if (force || versionUpgrade) {
            chunksToDownload = List<String>.from(chunks);
          } else {
            final marker = _readyMarker(packName);
            await marker.create(recursive: true);
            return true;
          }
        } else {
          chunksToDownload = List<String>.from(chunks);
        }

        ok = await _downloadChunks(
          ctx,
          packName,
          chunksToDownload,
          showUi,
          packVersion,
          packValidator,
        );
      } else {
        // Legacy single-request path (for other apps)
        ok = await _downloadStrings(ctx, packName, showUi, packVersion);
      }

      try {
        await _attemptMarker(packName).create(recursive: true);
      } catch (_) {}

      return ok;
    } finally {
      _inFlight = false;
    }
  }

  /// Checks whether the on-disk audio pack satisfies [packValidator].
  Future<bool> verifyPackIntegrity(
      Future<bool> Function(String assetsPath) packValidator) async {
    if (kIsWeb) return true;
    if (dir == null) await init();
    final path = assetsPath;
    if (path == null) return false;
    return await packValidator(path);
  }

  void extractFiles(String appName, [File? zipFile]) {
    final target = zipFile ?? File("${dir!.path}/$folderAndFileName.zip");
    if (!target.existsSync()) return;
    final bytes = target.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      // Strip the top-level pack folder ("mt-<app>/") the server wraps the zip
      // in, and tolerate a redundant leading "assets/" if the web deploy
      // includes one, so files always land at "<dir>/assets/<relative path>".
      var updatedFileName = filename.replaceFirst("$appName/", '');
      if (appName.startsWith("mt-")) {
        updatedFileName =
            updatedFileName.replaceFirst("${appName.substring(3)}/", '');
      }
      if (updatedFileName.startsWith('assets/')) {
        updatedFileName = updatedFileName.replaceFirst('assets/', '');
      }
      final outPath =
          "${dir!.path}/assets/${updatedFileName.replaceAll("%20", ' ')}";
      if (file.isFile) {
        final data = file.content as List<int>;
        File(outPath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(outPath).createSync(recursive: true);
      }
    }
  }
}

/// A compact, suite-styled modal shown while the audio pack downloads.
class _AudioDownloadDialog {
  final BuildContext? _context;
  bool _open = false;

  _AudioDownloadDialog._(this._context);

  static _AudioDownloadDialog show(
    BuildContext? context,
    ValueNotifier<double?> progress, {
    ValueNotifier<String?>? statusMessage,
  }) {
    final d = _AudioDownloadDialog._(context);
    if (context == null) return d;
    d._open = true;
    showJHGBlurDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: _AudioDownloadCard(
          progress: progress,
          statusMessage: statusMessage,
        ),
      ),
    );
    return d;
  }

  Future<void> close() async {
    final ctx = _context;
    if (!_open || ctx == null || !ctx.mounted) return;
    _open = false;
    final nav = Navigator.of(ctx, rootNavigator: true);
    if (nav.canPop()) nav.pop();
  }
}

class _AudioDownloadCard extends StatelessWidget {
  final ValueNotifier<double?> progress;
  final ValueNotifier<String?>? statusMessage;
  const _AudioDownloadCard({
    required this.progress,
    this.statusMessage,
  });

  @override
  Widget build(BuildContext context) {
    return JHGFrostedPanel.padded(
      maxWidth: 400,
      accent: JHGColors.primary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: JHGColors.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.library_music_outlined,
                    color: JHGColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Getting your sounds ready',
                  style: TextStyle(
                    color: JHGColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (statusMessage != null)
            ValueListenableBuilder<String?>(
              valueListenable: statusMessage!,
              builder: (context, msg, _) => Text(
                msg ?? 'Downloading the audio library. This happens only once.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            )
          else
            Text(
              'Downloading the audio library. This happens only once.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          const SizedBox(height: 22),
          ValueListenableBuilder<double?>(
            valueListenable: progress,
            builder: (context, value, _) {
              final pct = value == null ? null : (value * 100).clamp(0, 100);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.10),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(JHGColors.primary),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pct == null ? 'Starting…' : '${pct.toInt()}%',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
