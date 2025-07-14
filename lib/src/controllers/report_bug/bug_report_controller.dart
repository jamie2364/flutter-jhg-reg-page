import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/repositories/repo.dart';
import 'package:reg_page/src/utils/res/constants.dart';

class BugReportController {
  ValueNotifier<bool> isChecked = ValueNotifier<bool>(false);

  String deviceName = 'Unknown';
  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final device = await deviceInfoPlugin.androidInfo;
      deviceName = "${device.manufacturer} ${device.model}";
    } else if (Platform.isIOS) {
      final device = await deviceInfoPlugin.iosInfo;
      deviceName = device.name;
    }
  }

  Future<bool> submitBugReport(
    String issueDesc,
  ) async {
    try {
      if (issueDesc.isEmpty) {
        showErrorToast(Constants.fieldError);
        return false;
      }
      loaderDialog();
      final user = SplashScreen.session.user;
      final response = await Repo().postBug({
        'name': user?.userName ?? '',
        'email': user?.email ?? '',
        'issue': issueDesc,
        'device': deviceName,
        'application': getIt<SplashController>().appName,
      });
      Log.d('Response: $response');

      if (response != null) {
        Nav.back();
        showToast(message: Constants.yourMessageHas);
        isChecked.value = false;
        return true;
      }
    } catch (e) {
      Nav.back();
      Log.d('Error: $e', name: 'submitBugReport()');
    }
    return false;
  }
}
