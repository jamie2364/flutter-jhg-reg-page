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
import 'package:reg_page/src/views/widgets/welcome/already_subscribed.dart';
import 'package:reg_page/src/views/widgets/welcome/header_image.dart';
import 'package:reg_page/src/views/widgets/welcome/plan_options_widget.dart';
import 'package:reg_page/src/views/widgets/welcome/welcome_text.dart';
import 'package:upgrader/upgrader.dart';

import '../subscription/subscription_url_screen.dart';

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

  // The image + "Welcome / to Music Tools / <app>" title, plus the info chip.
  // It is the first thing in the scroll view, so the plan content that follows
  // can never be drawn under the title (the old overlap) and the title can never
  // push the content off-screen.
  Widget _header(double height, double width) {
    return Stack(
      children: [
        HeaderImage(height: height, width: width),
        Positioned(
          right: width * 0.05,
          top: MediaQuery.of(context).padding.top + height * 0.01,
          child: JhgIconChipButton.header(
            icon: LucideIcons.info,
            onTap: () => Nav.to(InfoScreen(
              callback: controller.restorePurchase,
            )),
          ),
        ),
        Positioned(
          left: width < 768 ? width * .07 : 50,
          bottom: 0,
          right: width < 768 ? width * .07 : 50,
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: Utils.sWidth(context),
              child: WelcomeText(
                  appName: controller.replaceAppName(), height: height),
            ),
          ),
        ),
      ],
    );
  }

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
    final double btnWidth = width > 768 ? 500 : width * 0.85;
    return SafeArea(
      top: false,
      child: UpgradeAlert(
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
              // One scroll view for the whole page. Fixed gaps (never Spacers,
              // which collapse to nothing and cram the plan cards, the Login row
              // and the Continue button together) keep consistent breathing room
              // on every device; the page simply scrolls on a short screen
              // instead of clipping the Continue button.
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: kIsWeb
                        ? [
                            _header(height, width),
                            SizedBox(height: height * 0.12),
                            Center(
                              child: JHGPrimaryBtn(
                                width: btnWidth,
                                label: Constants.getStarted,
                                onPressed: () =>
                                    Nav.to(const SubscriptionUrlScreen()),
                              ),
                            ),
                            SizedBox(height: height * 0.08),
                          ]
                        : [
                            _header(height, width),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  width * 0.07, 24, width * 0.07, 28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Text(
                                      Constants.pleaseChoosePlan,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: JHGColors.secondaryWhite,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: Constants.kFontFamilySS3,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Center(
                                    child: PlanOptionsWidget(
                                      plans: plans,
                                      selectedPlan:
                                          controller.selectedPlan.value,
                                      onPlanSelect: onPlanSelect,
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  Center(
                                    child: AlreadySubscribed(onLogin: () {
                                      LocalDB.setIsFreePlan(false);
                                      controller.launchNextPage();
                                    }),
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: ListenableBuilder(
                                      listenable: controller.selectedPlan,
                                      builder: (context, _) {
                                        return JHGPrimaryBtn(
                                          width: btnWidth,
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
                                              Nav.offAll(
                                                  spController.nextPage());
                                              return;
                                            }
                                            await controller
                                                .purchaseSubscription(controller
                                                    .selectedPlan.value);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                  ),
                ),
        ),
      ),
    );
  }
}
