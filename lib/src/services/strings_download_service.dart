import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/utils/url/urls.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class StringsDownloadService {
  static final StringsDownloadService _instance =
      StringsDownloadService._internal();

  Directory? dir;
  final String folderAndFileName = "audio_strings";

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
      directory.create();
    }
  }

  Future<bool> _downloadStrings(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
        max: 100,
        msg: 'Downloading Audio Files',
        barrierColor: Colors.black87,
        backgroundColor: JHGColors.dialogBackground,
        surfaceTintColor: JHGColors.dialogBackground,
        progressBgColor: JHGColors.white,
        progressValueColor: JHGColors.primary,
        msgColor: JHGColors.white,
        valueColor: JHGColors.white);
    File file = File("${dir!.path}/$folderAndFileName.zip");
    final dio = Dio();
    final appName = Utils.getMtAppName;
    final url = '${Urls.downloadAssetsUrl}$appName';
    try {
      await dio.download(url, file.path, onReceiveProgress: (rec, total) {
        // total is -1 when the server sends no Content-Length, so drive the bar
        // only when we actually know the size. Never treat progress here as the
        // "download finished" signal (see below).
        if (total > 0) {
          pd.update(value: (((rec / total) * 100).toInt()));
        }
      });

      // The await above only returns once the whole file has been written to
      // disk, so THIS is the reliable "done" point. The old code saved the
      // downloaded flag inside the progress callback guarded by
      // `progress == 100`, which never fired when the server omitted
      // Content-Length (total == -1) — so the flag stayed false and the app
      // re-downloaded the audio on every launch.
      await LocalDB.saveIsFilesDownloaded(true);
      extractFiles(appName);
      pd.close();
      showToast(
          context: context,
          message: "Audio files downloaded",
          isError: false);
      return true;
    } on Exception catch (ex) {
      pd.close();
      await LocalDB.saveIsFilesDownloaded(false);
      Log.ex('downloadString exception==$ex', name: url);
      return false;
    }
  }

  Future<bool> isStringsDownloaded(String appName) async {
    // The constructor kicks off init() but does not await it, so dir may still
    // be null on the first launch when the home screen calls in. Make sure the
    // directory is ready before we touch it.
    if (dir == null) {
      await init();
    }
    File file = File("${dir!.path}/$folderAndFileName.zip");

    if (!(await file.exists() && await LocalDB.getIsFilesDownloaded)) {
      // ignore: use_build_context_synchronously
      bool isDownload = await _downloadStrings(Nav.key.currentState!.context);
      return isDownload;
    } else {
      return false;
    }
  }

  void extractFiles(String appName) async {
    final bytes = File("${dir!.path}/$folderAndFileName.zip").readAsBytesSync();
    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      final updatedFileName = filename.replaceFirst("$appName/", '');
      if (file.isFile) {
        final data = file.content as List<int>;
        File("${dir!.path}/assets/${updatedFileName.replaceAll("%20", ' ')}")
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(
                "${dir!.path}/assets/${updatedFileName.replaceAll("%20", ' ')}")
            .create(recursive: true);
      }
    }
  }
}
