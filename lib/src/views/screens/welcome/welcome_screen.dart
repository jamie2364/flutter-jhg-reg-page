// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/controllers/welcome/welcome_controller.dart';
import 'package:reg_page/src/models/plan_options.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/views/screens/info/info_screen.dart';
import 'package:reg_page/src/views/screens/subscription/subscription_url_screen.dart';
import 'package:reg_page/src/views/widgets/welcome/already_subscribed.dart';
import 'package:reg_page/src/views/widgets/welcome/header_image.dart';
import 'package:reg_page/src/views/widgets/welcome/plan_options_widget.dart';
import 'package:reg_page/src/views/widgets/welcome/welcome_text.dart';
import 'package:upgrader/upgrader.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
  });
  @override
  State<WelcomeScreen> createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomeScreen> {
  bool loading = true;
  String? monthlyPrice;
  String? yearlyPrice;
  // int selectedPlan = 1;
  List<ProductDetails> products = [];
  void onPlanSelect(int plan) {
    controller.onPlanSelect(plan);
  }

  late WelcomeController controller;
  late SplashController spController;
  @override
  void initState() {
    super.initState();
    controller = getIt<WelcomeController>();
    spController = getIt<SplashController>();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await controller.initializeData();
    setState(() {
      loading = controller.loading;
      monthlyPrice = controller.monthlyPrice;
      yearlyPrice = controller.yearlyPrice;
    });
  }

  // final upgrader = Upgrader(debugDisplayAlways: true);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final plans = Plan.getPlans(monthlyPrice ?? '', yearlyPrice ?? '');
    if (spController.appName.contains(Constants.courseHUB) ||
        spController.appName.contains(Constants.practiceRoutines) ||
        !spController.showFreePlan) {
      plans.removeAt(0);
    }
    return UpgradeAlert(
      // upgrader: upgrader,
      dialogStyle: !kIsWeb
          ? Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material
          : UpgradeDialogStyle.material,
      child: Scaffold(
        backgroundColor: JHGColors.primaryBlack,
        body: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: JHGColors.primary,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      HeaderImage(height: height, width: width),
                      Positioned(
                        left: width * 0.05,
                        bottom: 10,
                        child: WelcomeText(
                            appName: controller.replaceAppName(),
                            height: height),
                      ),
                      Positioned(
                        right: width * 0.05,
                        top: MediaQuery.of(context).padding.top + height * 0.01,
                        child: JHGIconButton(
                          iconData: Icons.info_rounded,
                          size: 30,
                          onTap: () => Nav.to(InfoScreen(
                            callback: controller.restorePurchase,
                          )),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: kIsWeb
                            ? [
                                SizedBox(
                                  height: height * 0.18,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: JHGPrimaryBtn(
                                    width: width > 768 ? 500 : width * 0.85,
                                    label: Constants.getStarted,
                                    onPressed: () =>
                                        Nav.to(const SubscriptionUrlScreen()),
                                  ),
                                )
                              ]
                            : [
                                const Spacer(),
                                Text(
                                  Constants.pleaseChoosePlan,
                                  style: TextStyle(
                                    color: JHGColors.secondaryWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: Constants.kFontFamilySS3,
                                  ),
                                ),
                                // const Spacer(),
                                SizedBox(
                                    height: height > 650
                                        ? height * 0.03
                                        : height * 0.02),
                                Align(
                                  alignment: Alignment.center,
                                  child: PlanOptionsWidget(
                                    plans: plans,
                                    selectedPlan: controller.selectedPlan.value,
                                    onPlanSelect: onPlanSelect,
                                  ),
                                ),
                                // SizedBox(
                                //     height: height > 650
                                //         ? height * 0.03
                                //         : height * 0.02),
                                const Spacer(),
                                AlreadySubscribed(onLogin: () {
                                  LocalDB.setIsFreePlan(false);
                                  controller.launchNextPage();
                                }),
                                // SizedBox(
                                //     height: height > 650
                                //         ? height * 0.03
                                //         : height * 0.02),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.center,
                                  child: ListenableBuilder(
                                    listenable: controller.selectedPlan,
                                    builder: (context, _) {
                                      return JHGPrimaryBtn(
                                        width: width > 768 ? 500 : width * 0.85,
                                        label:
                                            controller.selectedPlan.value == 2
                                                ? Constants.tryFree
                                                : Constants.continueText,
                                        onPressed: () async {
                                          if (controller.selectedPlan.value ==
                                              0) {
                                            LocalDB.setIsFreePlan(true);
                                            SplashScreen.session.isFreePlan =
                                                true;
                                            Nav.offAll(spController.nextPage());
                                            return;
                                          }
                                          await controller.purchaseSubscription(
                                              controller.selectedPlan.value);
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const Spacer(),
                              ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
