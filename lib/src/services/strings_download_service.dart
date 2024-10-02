import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
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
    dir = await (Platform.isIOS
        ? getApplicationSupportDirectory()
        : getApplicationDocumentsDirectory());
    Directory directory = Directory("${dir?.path}/assets/");
    directory.create();
  }

  Future<bool> _downloadStrings(BuildContext context, String appName) async {
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
    try {
      await dio.download("${Urls.downloadAssetsUrl}$appName", file.path,
          onReceiveProgress: (rec, total) {
       int progress = (((rec / total) * 100).toInt());
        // print("progress===${progress}");
        pd.update(value: progress);
        if (progress == 100) {
          showToast(
              context: context,
              message: "Audio files downloaded",
              isError: false);
          extractFiles(appName);
        }
      });
      return false;
    } on Exception catch (ex) {
      pd.close();
      exceptionLog("downloadString exception==$ex");
      return false;
    }
  }

  Future<bool> isStringsDownloaded(String appName) async {
    File file = File("${dir!.path}/$folderAndFileName.zip");

    if (!(await file.exists())) {
      // ignore: use_build_context_synchronously
     bool isDownload = await _downloadStrings(Nav.key.currentState!.context, appName);
     return isDownload;
    }
    else{
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
