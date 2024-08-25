import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/auth/controllers/user_controller.dart';
import 'package:reg_page/src/colors.dart';
import 'package:reg_page/src/models/user_session.dart';
import 'package:reg_page/src/splash/controllers/splash_controller.dart';
import 'package:reg_page/src/utils/nav.dart';

var globalNextPage;
final GetIt getIt = GetIt.instance;

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.yearlySubscriptionId,
    required this.monthlySubscriptionId,
    required this.appName,
    required this.appVersion,
    required this.featuresList,
    required this.nextPage,
    required this.navKey,
  });

  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
  final String appName;
  final String appVersion;
  final List<String> featuresList;
  final GlobalKey<NavigatorState> navKey;
  final Widget Function() nextPage;

  static UserSession session = UserSession(url: BaseUrl.jhg, user: null);
  // static GlobalKey<NavigatorState>? staticNavKey;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController? viewModel;
  double logoSize = 1;

  @override
  void initState() {
    super.initState();
    animate();
    viewModel = SplashController(
      yearlySubscriptionId: widget.yearlySubscriptionId,
      monthlySubscriptionId: widget.monthlySubscriptionId,
      appName: widget.appName,
      appVersion: widget.appVersion,
      featuresList: widget.featuresList,
      nextPage: widget.nextPage,
      navKey: widget.navKey,
      onUpdateUI: onUpdateUI,
    );
    viewModel!.initializeSplash();
    if (!getIt.isRegistered<SplashController>()) {
      getIt.registerSingleton<SplashController>(viewModel!);
      getIt.registerSingleton<UserController>(UserController());
    }
    animate();
  }

  animate() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        logoSize = 1.1;
      });
    });
  }

  // Callback function that calls setState
  void onUpdateUI() {
    setState(() {
      logoSize = 1.1; // Update the logo size
    });
  }

  @override
  Widget build(BuildContext context) {
    Nav.key = widget.navKey;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        color: AppColor.primaryBlack,
        child: Center(
          child: AnimatedScale(
            scale: logoSize,
            duration: const Duration(milliseconds: 2000),
            curve: Curves.linearToEaseOut,
            child: Image.asset(
              "assets/images/jhg_logo.png",
              package: 'reg_page',
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.height * 0.30,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
