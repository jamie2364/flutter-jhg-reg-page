import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:get_it/get_it.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/controllers/subscription/subscription_url_controller.dart';
import 'package:reg_page/src/controllers/user/user_controller.dart';
import 'package:reg_page/src/controllers/welcome/welcome_controller.dart';
import 'package:reg_page/src/models/user_session.dart';
import 'package:reg_page/src/utils/res/constants.dart';

final GetIt getIt = GetIt.instance;

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.yearlySubscriptionId,
    required this.monthlySubscriptionId,
    required this.appName,
    required this.featuresList,
    required this.nextPage,
    required this.navKey,
    this.showFreePlan = true,
  });

  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
  final String appName;
  final List<String> featuresList;
  final GlobalKey<NavigatorState> navKey;
  final Widget Function() nextPage;
  final bool showFreePlan;
  static UserSession session = UserSession(url: BaseUrl.jhg, user: null);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double logoSize = 1.0;

  @override
  void initState() {
    super.initState();
    animate();
    SplashController controller = SplashController(
      yearlySubscriptionId: widget.yearlySubscriptionId,
      monthlySubscriptionId: widget.monthlySubscriptionId,
      appName: widget.appName,
      featuresList: widget.featuresList,
      nextPage: widget.nextPage,
      navKey: widget.navKey,
      onUpdateUI: onUpdateUI,
      showFreePlan: widget.showFreePlan,
    );
    if (!getIt.isRegistered<SplashController>()) {
      getIt.registerSingleton<SplashController>(controller);
      getIt.registerSingleton<UserController>(UserController());
      getIt.registerSingleton<WelcomeController>(WelcomeController());
      getIt.registerSingleton<SubscriptionUrlController>(
          SubscriptionUrlController());
    }
    controller.initializeSplash();
  }

  animate() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        logoSize = 1.15;
      });
    });
  }

  void onUpdateUI() {
    setState(() {
      logoSize = 1.15;
    });
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    final double maxHeight = constraints.height * 0.3;
    final double maxWidth = constraints.width * 0.8;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: JHGColors.primaryBlack,
        child: Center(
          child: AnimatedScale(
            scale: logoSize,
            duration: const Duration(milliseconds: 2000),
            curve: Curves.linearToEaseOut,
            child: Image.asset(
              "assets/images/Copy of MUSICTOOLS.png",
              package: Constants.regPackage,
              height: maxHeight,
              width: maxWidth,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
