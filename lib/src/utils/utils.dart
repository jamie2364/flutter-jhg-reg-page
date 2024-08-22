import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/auth/screens/account_check_screen.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/utils/nav.dart';
import 'package:reg_page/src/utils/urls.dart';

class Utils {
  static EdgeInsets customPadding(context) {
    return EdgeInsets.symmetric(
      horizontal: JHGResponsive.isMobile(context)
          ? kBodyHrPadding
          : JHGResponsive.isTablet(context)
              ? MediaQuery.sizeOf(context).width * .25
              : MediaQuery.sizeOf(context).width * .30,
    );
  }

  static BuildContext? get getContext {
    return SplashScreen.staticNavKey?.currentState?.context;
  }

  static void handleNextScreenOnSuccess(String appName) {
    if (Constant.musictoolsApps.contains(appName)) {
      if (Urls.base.isEqual(Urls.musicUrl)) {
        Nav.offAll(globalNextPage());
      } else if (!Urls.base.isEqual(Urls.musicUrl)) {
        Urls.base = BaseUrl.musictools;
        SplashScreen.session.url = Urls.base;
        Nav.to(const AccountCheckScreen());
      }
    } else if (Constant.evoloApps.contains(appName)) {
      if (Urls.base.isEqual(Urls.evoloUrl)) {
        Nav.offAll(globalNextPage());
      } else {
        Urls.base = BaseUrl.evolo;
        SplashScreen.session.url = Urls.base;
        Nav.to(const AccountCheckScreen());
      }
    } else if (Constant.jhgApps.contains(appName)) {
      if (Urls.base.isEqual(Urls.jhgUrl)) {
        Nav.to(globalNextPage());
      } else {
        Urls.base = BaseUrl.jhg;
        SplashScreen.session.url = Urls.base;
        Nav.to(const AccountCheckScreen());
      }
    } else {
      //! currently hardcoced for looper
      if (appName == 'JHG Looper') {
        Nav.to(globalNextPage());
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
          (entry.key == 'course_hub') &&
          (entry.value == "active")) {
        return true;
      } else if (entry.value == "active") {
        return true;
      }
    }
    return false;
  }
}
