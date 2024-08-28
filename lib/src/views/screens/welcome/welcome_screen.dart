// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/controllers/welcome/in_app_purchase_controller.dart';
import 'package:reg_page/src/controllers/welcome/welcome_controller.dart';
import 'package:reg_page/src/models/plan_options.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constant.dart';
import 'package:reg_page/src/views/widgets/welcome/already_subscribed.dart';
import 'package:reg_page/src/views/widgets/welcome/header_image.dart';
import 'package:reg_page/src/views/widgets/welcome/info_button.dart';
import 'package:reg_page/src/views/widgets/welcome/plan_options_widget.dart';
import 'package:reg_page/src/views/widgets/welcome/welcome_text.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<WelcomeScreen> createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomeScreen> {
  bool loading = true;
  String? monthlyPrice;
  String? yearlyPrice;
  int selectedPlan = 1;
  List<ProductDetails> products = [];

  late InAppPurchaseHandler purchaseHandler;
  late WelcomeController controller;

  @override
  void initState() {
    super.initState();
    controller = getIt<WelcomeController>();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await controller.initializeData();
    setState(() {
      loading = controller.loading;
    });
    monthlyPrice = controller.monthlyPrice;
    yearlyPrice = controller.yearlyPrice;
  }

  void onPlanSelect(int plan) {
    controller.onPlanSelect(plan);
    selectedPlan = plan;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final spController = getIt<SplashController>();
    final plans = Plan.getPlans(monthlyPrice ?? '', yearlyPrice ?? '');
    if (spController.appName.contains("Course Hub")) plans.removeAt(0);
    return Scaffold(
      backgroundColor: AppColor.primaryBlack,
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryRed,
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
                      bottom: 20,
                      child: WelcomeText(
                          appName: controller.replaceAppName(), height: height),
                    ),
                    InfoButton(
                      width: width,
                      height: height,
                      appName: spController.appName,
                      appVersion: spController.appVersion,
                      restorePurchase: controller.restorePurchase,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Constant.pleaseChoosePlan,
                        style: TextStyle(
                          color: AppColor.secondaryWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: Constant.kFontFamilySS3,
                        ),
                      ),
                      SizedBox(
                          height: height > 650 ? height * 0.03 : height * 0.02),
                      PlanOptionsWidget(
                        plans: plans,
                        selectedPlan: selectedPlan,
                        onPlanSelect: onPlanSelect,
                      ),
                      SizedBox(
                          height: height > 650 ? height * 0.03 : height * 0.02),
                      AlreadySubscribed(onLogin: () {
                        LocalDB.setIsFreePlan(false);
                        controller.launchNextPage();
                      }),
                      SizedBox(
                          height: height > 650 ? height * 0.03 : height * 0.02),
                      JHGPrimaryBtn(
                        label: selectedPlan == 1
                            ? Constant.tryFree
                            : Constant.continueText,
                        onPressed: () async {
                          if (selectedPlan == 0) {
                            LocalDB.setIsFreePlan(true);
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return spController.nextPage();
                            }), (route) => false);
                            return;
                          }
                          await controller.purchaseSubscription(selectedPlan);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    purchaseHandler.dispose();
    super.dispose();
  }
}
