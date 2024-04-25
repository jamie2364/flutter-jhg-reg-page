import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/colors.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:archive/archive_io.dart';

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
    Directory directory= Directory("${dir?.path}/assets/");
    directory.create();
  }

  Future<void> _downloadStrings(BuildContext context,String appName) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
        max: 100,
        msg: 'Downloading Strings audio',
        backgroundColor: AppColor.dialogBackground,
        surfaceTintColor: AppColor.dialogBackground,
        progressBgColor: AppColor.secondaryWhite,
        progressValueColor: AppColor.primaryRed,
        msgColor: AppColor.primaryWhite,
        valueColor: AppColor.primaryWhite);
    File file = File("${dir!.path}/${folderAndFileName}.zip");
    final dio = Dio();
    try {
      await dio.download("https://www.jamieharrisonguitar.com/wp-json/jhg-apps/v1/download-audio/?app_name=$appName", file.path, onReceiveProgress: (rec, total) {
        int progress = (((rec / total) * 100).toInt());
        // print("progress===${progress}");
        pd.update(value: progress);
        if (progress == 100) {
          showToast(
              context: context,
              message: "Strings audio downloaded",
              isError: false);
          extractFiles();
        }

      });
    } on Exception catch (ex) {
      pd.close();
      print("downloadString exception==${ex}");
    }
  }

  Future<void> isStringsDownloaded(BuildContext context,String appName) async {
    File file = File("${dir!.path}/${folderAndFileName}.zip");

    if (!(await file.exists())) {
      _downloadStrings(context,appName);
    }
    // else {
    //   final files =
    //       await Directory("${dir!.path}/assets/")
    //           .listSync()
    //           .toList();
    //   if (files.isNotEmpty) {
    //     Iterable<File> stringsPaths = files.whereType<File>();
    //
    //     for(var file in stringsPaths){
    //       print("object===${file.path}");
    //     }
    //   }
    // }
  }

  void extractFiles() async {
    final bytes = File(
            "${dir!.path}/${folderAndFileName}.zip")
        .readAsBytesSync();
    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

// Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File("${dir!.path}/assets/" + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory("${dir!.path}/assets/" + filename)
            .create(recursive: true);
      }
    }
  }
}
