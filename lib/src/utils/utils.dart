import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/utils/url/urls.dart';
import 'package:reg_page/src/views/screens/auth/account_check_screen.dart';

class Utils {
  Utils._();

  static EdgeInsets customPadding(context) {
    return EdgeInsets.symmetric(
      horizontal: JHGResponsive.isMobile(context)
          ? kBodyHrPadding
          : JHGResponsive.isTablet(context)
              ? MediaQuery.sizeOf(context).width * .25
              : MediaQuery.sizeOf(context).width * .30,
    );
  }

  static isValidEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static BuildContext? get getContext => Nav.key.currentState?.context;

  static File getAsset(String path, {String? appName = ""}) =>
      (kIsWeb && appName == "Drills")
          ? File("web/$path")
          : File("${StringsDownloadService().dir?.path}/$path");

  static Future<bool> checkInternet() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        return await InternetConnectionChecker().hasConnection;
      }
    } catch (e) {
      return true;
    }
    return false;
  }

  static void handleNextScreenOnSuccess(String appName) {
    final page = getIt<SplashController>().nextPage;
    if (Constants.musictoolsApps.contains(appName)) {
      if (Urls.base.isEqual(Urls.musicUrl)) {
        Nav.offAll(page());
      } else if (!Urls.base.isEqual(Urls.musicUrl)) {
        Urls.base = BaseUrl.musictools;
        SplashScreen.session.url = Urls.base;
        Nav.off(const AccountCheckScreen());
      }
    } else if (Constants.evoloApps.contains(appName)) {
      if (Urls.base.isEqual(Urls.evoloUrl)) {
        Nav.offAll(page());
      } else {
        Urls.base = BaseUrl.evolo;
        SplashScreen.session.url = Urls.base;
        Nav.off(const AccountCheckScreen());
      }
    } else if (Constants.jhgApps.contains(appName)) {
      if (Urls.base.isEqual(Urls.jhgUrl)) {
        Nav.offAll(page());
      } else {
        Urls.base = BaseUrl.jhg;
        SplashScreen.session.url = Urls.base;
        Nav.off(const AccountCheckScreen());
      }
    } else {
      //! currently hardcoced for looper
      if (appName == Constants.jhgLooper) {
        Nav.offAll(page());
        return;
      }
      showErrorToast('app name $appName not found');
    }
  }

  static bool isSubscriptionActive(Map<String, dynamic>? json,
      {bool isCourseHubApp = false}) {
    if (json == null) return false;
    for (var entry in json.entries) {
      if ((isCourseHubApp) &&
          (entry.key == Constants.courseHub) &&
          (entry.value == Constants.active)) {
        return true;
      } else if (entry.value == Constants.active) {
        return true;
      }
    }
    return false;
  }

  static void logOut([BuildContext? context]) async {
    DialogHelper.showLogoutDialog(context ?? Nav.key.currentState!.context,
        () async {
      await LocalDB.clearLocalDB();
      final spController = getIt<SplashController>();
      Nav.offAll(
        SplashScreen(
            yearlySubscriptionId: spController.yearlySubscriptionId,
            monthlySubscriptionId: spController.monthlySubscriptionId,
            appName: spController.appName,
            featuresList: spController.featuresList,
            nextPage: spController.nextPage,
            navKey: spController.navKey),
      );
    });
  }

  static String get getMtAppName {
    String appName = getIt<SplashController>().appName;
    appName = appName.toLowerCase().replaceAll(' ', '-');
    return 'mt-$appName';
  }
}
