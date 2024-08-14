import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:get/get.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/auth/controllers/user_controller.dart';
import 'package:reg_page/src/auth/screens/account_check_screen.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/utils/app_urls.dart';

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

  static void handleNextScreenOnSuccess(String appName, var nextPage) {
    if (Constant.musictoolsApps.contains(appName)) {
      if (AppUrls.base.isEqual(AppUrls.musicUrl)) {
        Navigator.pushAndRemoveUntil(
            Utils.getContext!,
            MaterialPageRoute(builder: (context) => globalNextPage()),
            (route) => false);
      } else if (!AppUrls.base.isEqual(AppUrls.musicUrl)) {
        AppUrls.base = BaseUrl.musictools;
        SplashScreen.session.url = AppUrls.base;
        Get.put(UserController());
        Navigator.push(
            Utils.getContext!,
            MaterialPageRoute(
              builder: (context) => const AccountCheckScreen(),
            ));
      }
    } else if (Constant.evoloApps.contains(appName)) {
      if (AppUrls.base.isEqual(AppUrls.evoloUrl)) {
        Navigator.pushAndRemoveUntil(
            Utils.getContext!,
            MaterialPageRoute(builder: (context) => globalNextPage()),
            (route) => false);
      } else {
        AppUrls.base = BaseUrl.evolo;
        SplashScreen.session.url = AppUrls.base;
        Get.put(UserController());
        Navigator.push(
            Utils.getContext!,
            MaterialPageRoute(
              builder: (context) => const AccountCheckScreen(),
            ));
      }
    } else if (Constant.jhgApps.contains(appName)) {
      if (AppUrls.base.isEqual(AppUrls.jhgUrl)) {
        Navigator.pushAndRemoveUntil(
            Utils.getContext!,
            MaterialPageRoute(builder: (context) => globalNextPage()),
            (route) => false);
      } else {
        AppUrls.base = BaseUrl.jhg;
        SplashScreen.session.url = AppUrls.base;
        Get.put(UserController());
        Navigator.push(
            Utils.getContext!,
            MaterialPageRoute(
              builder: (context) => const AccountCheckScreen(),
            ));
      }
    } else {
      showErrorToast('app name $appName not found');
    }
  }
}
