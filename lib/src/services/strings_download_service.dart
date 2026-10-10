import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/utils/url/urls.dart';

/// Downloads an app's audio pack (hosted on the web deploy) once per install and
/// extracts it to local storage so the native/C++ engine can open real files.
///
/// Design notes — the two bugs this class used to have:
///
///  1. "Re-downloads on every launch." The old gate relied on a `downloaded`
///     bool in SharedPreferences. But `LocalDB.clearLocalDB()` runs on several
///     splash paths (expired/invalid subscription, logout) and wipes every
///     pref, so the flag kept resetting and the download dialog reappeared on
///     each cold start. The gate now lives on disk: a per-app sentinel file
///     written only after a successful extract. Pref clears can't touch it.
///
///  2. "Ugly, dated dialog." The old code used `sn_progress_dialog`. The
///     progress UI is now a suite-styled frosted card built from JHG tokens.
///
/// It is also graceful: if the network/CDN is unavailable but the audio was
/// already extracted on a previous run, it stays silent and does nothing.
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
  /// a re-download runs only when the version on disk is older than that. This
  /// is how adding a new sound (bump the version) forces a refresh, while a
  /// code-only app update (same version) never re-downloads.
  File _versionMarker(String appName) =>
      File("${dir!.path}/assets/audio_${appName}_version.txt");

  /// The pack version currently on disk. Returns 0 when nothing is downloaded.
  /// Installs that provisioned before versioning existed have no version file
  /// but do have the pack, so they are grandfathered in at version 1 — they
  /// only re-download once an app actually asks for version 2 or higher.
  Future<int> _storedVersion(String appName) async {
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
  /// app expects. Accepts the sentinel OR real extracted audio on disk, so a
  /// flaky marker write can never force a re-download when the pack is there —
  /// but a version older than [packVersion] always triggers a refresh.
  Future<bool> _alreadyProvisioned(String appName, int packVersion) async {
    if (dir == null) return false;
    try {
      final hasPack =
          await _readyMarker(appName).exists() || await _hasExtractedAudio();
      if (!hasPack) return false;
      return await _storedVersion(appName) >= packVersion;
    } catch (_) {
      return false;
    }
  }

  /// True when at least one real audio file has already been extracted into the
  /// pack directory by a previous successful download.
  Future<bool> _hasExtractedAudio() async {
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

  /// [showUi] drives whether the modal dialog and toasts appear. It is true on
  /// the first attempt of an install and false for silent background retries.
  Future<bool> _downloadStrings(BuildContext? context, String appName,
      bool showUi, int packVersion) async {
    final progress = ValueNotifier<double?>(null);
    final dialog =
        _AudioDownloadDialog.show(showUi ? context : null, progress);

    File file = File("${dir!.path}/$folderAndFileName.zip");
    final dio = Dio();
    final url = '${Urls.downloadAssetsUrl}$appName';
    try {
      await dio.download(url, file.path, onReceiveProgress: (rec, total) {
        // total is -1 when the server sends no Content-Length. Drive the bar
        // only when the size is known; otherwise leave it indeterminate.
        progress.value = total > 0 ? rec / total : null;
      });

      // The await above only returns once the whole file is on disk, so this is
      // the reliable "done" point.
      extractFiles(appName);

      // Mark success on disk (survives pref clears) AND in prefs (back-compat
      // with any code still reading the old flag).
      final marker = _readyMarker(appName);
      await marker.create(recursive: true);
      // Stamp the version we just extracted so later launches know whether the
      // pack is current. Written only on success, so a failed/partial download
      // leaves the old version in place and retries next launch.
      try {
        await _versionMarker(appName)
            .writeAsString('$packVersion', flush: true);
      } catch (_) {}
      debugPrint('[AudioDL] wrote marker=${marker.path} v=$packVersion '
          'exists=${await marker.exists()}');
      await LocalDB.saveIsFilesDownloaded(true);

      // The zip is dead weight once extracted — drop it to reclaim space.
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
      // Intentionally silent. A failed download is never surfaced to the user:
      // the app keeps whatever audio it already has and quietly retries on a
      // later launch. No error banner.
      return false;
    }
  }

  /// Ensures the audio pack is present and up to date. Downloads + extracts on
  /// first install, and again only when [packVersion] is higher than the
  /// version already on disk — i.e. when you have shipped a new/changed asset
  /// pack. On every other launch (including a code-only app update) it returns
  /// immediately with no dialog and no network call. Returns true only when a
  /// download actually ran to completion this call.
  ///
  /// [packVersion] defaults to 1 so existing apps that do not pass it keep the
  /// old "download once per install" behaviour untouched. Bump it (in the app)
  /// in lockstep with uploading a new pack to the server to force a refresh.
  Future<bool> isStringsDownloaded(String appName, {int packVersion = 1}) async {
    if (kIsWeb) return false;

    // The constructor starts init() without awaiting it, so dir may still be
    // null on a fast first launch. Make sure storage is ready first.
    if (dir == null) {
      await init();
    }

    // The app-name the pack is keyed by on the server (e.g. "mt-dictionaries").
    final packName = Utils.getMtAppName;

    // Already have this version? Nothing to do — the common every-launch path.
    final provisioned = await _alreadyProvisioned(packName, packVersion);
    final storedVersion = await _storedVersion(packName);
    debugPrint('[AudioDL] dir=${dir?.path}');
    debugPrint('[AudioDL] pack=$packName marker=${_readyMarker(packName).path}');
    debugPrint('[AudioDL] stored=v$storedVersion want=v$packVersion '
        'provisioned=$provisioned');
    if (provisioned) {
      return false;
    }

    if (_inFlight) return false;
    _inFlight = true;
    try {
      // Show the dialog on the first attempt of an install, and whenever a
      // version upgrade triggers the refresh (so the user sees "getting sounds
      // ready" rather than a silent mid-session swap). Pure background retries
      // — same version, server pack not up yet — stay silent.
      final bool versionUpgrade =
          storedVersion > 0 && storedVersion < packVersion;
      bool firstAttempt = true;
      try {
        firstAttempt = !await _attemptMarker(packName).exists();
      } catch (_) {}
      final bool showUi = firstAttempt || versionUpgrade;

      // Context is grabbed fresh from the root navigator here; the download
      // helper guards every later use with a mounted check.
      final ctx = Nav.key.currentState?.context;
      // ignore: use_build_context_synchronously
      final ok = await _downloadStrings(ctx, packName, showUi, packVersion);

      // Record that an attempt happened, so the next launch retries silently.
      try {
        await _attemptMarker(packName).create(recursive: true);
      } catch (_) {}

      return ok;
    } finally {
      _inFlight = false;
    }
  }

  void extractFiles(String appName) {
    final bytes = File("${dir!.path}/$folderAndFileName.zip").readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      // Strip the top-level pack folder ("mt-<app>/") the server wraps the zip
      // in, and tolerate a redundant leading "assets/" if the web deploy
      // includes one, so files always land at "<dir>/assets/<relative path>".
      var updatedFileName = filename.replaceFirst("$appName/", '');
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
/// Replaces the old `sn_progress_dialog`.
class _AudioDownloadDialog {
  final BuildContext? _context;
  bool _open = false;

  _AudioDownloadDialog._(this._context);

  static _AudioDownloadDialog show(
      BuildContext? context, ValueNotifier<double?> progress) {
    final d = _AudioDownloadDialog._(context);
    if (context == null) return d;
    d._open = true;
    showJHGBlurDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: _AudioDownloadCard(progress: progress),
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
  const _AudioDownloadCard({required this.progress});

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
