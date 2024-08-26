// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/welcome/in_app_purchase_controller.dart';
import 'package:reg_page/src/controllers/welcome/purchase_controller.dart';
import 'package:reg_page/src/controllers/welcome/welcome_controller.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constant.dart';
import 'package:reg_page/src/views/widgets/welcome/already_subscribed.dart';
import 'package:reg_page/src/views/widgets/welcome/header_image.dart';
import 'package:reg_page/src/views/widgets/welcome/info_button.dart';
import 'package:reg_page/src/views/widgets/welcome/plane_option.dart';
import 'package:reg_page/src/views/widgets/welcome/welcome_text.dart';

class Welcome extends StatefulWidget {
  const Welcome({
    Key? key,
    required this.yearlySubscriptionId,
    required this.monthlySubscriptionId,
    required this.appName,
    required this.appVersion,
    required this.featuresList,
    required this.nextPage,
  }) : super(key: key);

  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
  final String appName;
  final String appVersion;
  final List<String> featuresList;
  final Widget Function() nextPage;

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool loading = true;
  String? monthlyPrice;
  String? yearlyPrice;
  int selectedPlan = 2;
  List<ProductDetails> products = [];

  late InAppPurchaseHandler purchaseHandler;
  late TrackingTransparencyHandler trackingTransparencyHandler;
  late WelcomeController _subscriptionService;

  @override
  void initState() {
    super.initState();
    _subscriptionService = WelcomeController(
      context: context,
      appName: widget.appName,
      yearlySubscriptionId: widget.yearlySubscriptionId,
      monthlySubscriptionId: widget.monthlySubscriptionId,
      appVersion: widget.appVersion,
      nextPage: widget.nextPage(),
    );
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _subscriptionService.initializeData();
    setState(() {
      loading = _subscriptionService.loading;
    });
    monthlyPrice = _subscriptionService.monthlyPrice;
    yearlyPrice = _subscriptionService.yearlyPrice;
  }

  void onPlanSelect(int plan) {
    _subscriptionService.onPlanSelect(plan);
    selectedPlan = plan;
    setState(() {});
  }

  Future<void> launchNextPage() async {
    await _subscriptionService.launchNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                          appName: _subscriptionService.replaceAppName(),
                          height: height),
                    ),
                    InfoButton(
                      width: width,
                      height: height,
                      appName: widget.appName,
                      appVersion: widget.appVersion,
                      restorePurchase: _subscriptionService.restorePurchase,
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
                      if (!widget.appName.contains("Course Hub"))
                        PlanOption(
                          label: Constant.freeWithAds,
                          description: Constant.freeWithAdsSubtitle,
                          selectedPlan: selectedPlan,
                          planIndex: 0,
                          onPlanSelect: onPlanSelect,
                          yearlyPrice: yearlyPrice ?? '',
                          featuresList: widget.featuresList,
                        ),
                      SizedBox(
                          height: height > 650 ? height * 0.02 : height * 0.01),
                      PlanOption(
                        label: Constant.monthlyPlan,
                        description:
                            "$monthlyPrice ${Constant.perMonth}, renews automatically",
                        selectedPlan: selectedPlan,
                        planIndex: 2,
                        onPlanSelect: onPlanSelect,
                        yearlyPrice: yearlyPrice ?? '',
                        featuresList: widget.featuresList,
                      ),
                      SizedBox(
                          height: height > 650 ? height * 0.02 : height * 0.01),
                      PlanOption(
                        label: Constant.annualPlan,
                        description:
                            "${Constant.oneWeekFree}$yearlyPrice ${Constant.perYear}",
                        selectedPlan: selectedPlan,
                        planIndex: 1,
                        onPlanSelect: onPlanSelect,
                        yearlyPrice: yearlyPrice ?? '',
                        featuresList: widget.featuresList,
                      ),
                      SizedBox(
                          height: height > 650 ? height * 0.03 : height * 0.02),
                      AlreadySubscribed(onLogin: () {
                        LocalDB.setIsFreePlan(false);
                        launchNextPage();
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
                              return widget.nextPage();
                            }), (route) => false);
                            return;
                          }
                          await _subscriptionService
                              .purchaseSubscription(selectedPlan);
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
