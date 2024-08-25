import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/models/user.dart';
import 'package:reg_page/src/models/user_session.dart';
import 'package:reg_page/src/repositories/repo.dart';
import 'package:reg_page/src/utils/nav.dart';
import 'package:reg_page/src/utils/res/urls.dart';
import 'package:reg_page/src/utils/utils.dart';

class SplashController {
  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
  final String appName;
  final String appVersion;
  final List<String> featuresList;
  final Widget Function() nextPage;
  final GlobalKey<NavigatorState> navKey;
  final VoidCallback onUpdateUI; // Callback to trigger setState in the UI
  late String productIds;
  SplashController({
    required this.yearlySubscriptionId,
    required this.monthlySubscriptionId,
    required this.appName,
    required this.appVersion,
    required this.featuresList,
    required this.nextPage,
    required this.navKey,
    required this.onUpdateUI,
  });

  Future<void> initializeSplash() async {
    // SplashScreen.staticNavKey = navKey;
    Nav.key = navKey;
    globalNextPage = nextPage;
    Future.delayed(const Duration(milliseconds: 500), () {
      onUpdateUI(); // Trigger the UI update
    });
    await routes();
  }

  Future<void> routes() async {
    String? endDate = await LocalDB.getEndDate;
    DateTime currentDate = DateTime.now();
    if (endDate != null) {
      DateTime expiryDate = DateTime.parse(endDate);
      if (currentDate.isAfter(expiryDate)) {
        await LocalDB.clearLocalDB();
      }
    }
    bool isFreePlan = await LocalDB.getIsFreePlan();
    if (isFreePlan) {
      Nav.off(nextPage());
      return;
    }
    String? token = await LocalDB.getBearerToken;
    final url = await LocalDB.getBaseurl;
    final appUser = await LocalDB.getAppUser;

    if (kDebugMode) {
      print('token $token');
      print('token appUser $appUser');
    }

    Urls.base = BaseUrl.fromString(url ?? '');
    SplashScreen.session = UserSession(url: Urls.base, user: null);

    if (token == null) {
      navigateToWelcome();
    } else {
      final productIds = await LocalDB.getproductIds;
      final baseUrl = await LocalDB.getBaseurl;
      if (productIds == null) return;

      final res = await Repo().checkSubscription(productIds, baseUrl: baseUrl);
      if (res == null) {
        if (await LocalDB.isLoginTimeExpired) {
          await elseFunction();
        } else {
          await successFunction(appUser);
        }
      } else {
        final isActive = Utils.isSubscriptionActive(res,
            isCourseHubApp: appName == "JHG Course Hub");
        if (isActive) {
          await successFunction(appUser);
        } else {
          await elseFunction();
        }
      }
    }
  }

  Future<void> successFunction(User? user) async {
    await LocalDB.storeSubscriptionPurchase(true);
    SplashScreen.session.user = user;
    if (user != null) {
      Nav.off(nextPage());
      return;
    }
    Utils.handleNextScreenOnSuccess(appName);
  }

  Future<void> elseFunction() async {
    await LocalDB.clearLocalDB();
    navigateToWelcome();
  }

  void navigateToWelcome() {
    Nav.off(Welcome(
      yearlySubscriptionId: yearlySubscriptionId,
      monthlySubscriptionId: monthlySubscriptionId,
      appName: appName,
      appVersion: appVersion,
      featuresList: featuresList,
      nextPage: () => nextPage(),
    ));
  }
}
