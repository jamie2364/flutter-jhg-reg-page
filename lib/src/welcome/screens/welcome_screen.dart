// // ignore_for_file: use_build_context_synchronously

// import 'dart:async';
// import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:reg_page/reg_page.dart';
// import 'package:reg_page/src/colors.dart';
// import 'package:reg_page/src/constant.dart';
// import 'package:reg_page/src/custom_button.dart';
// import 'package:reg_page/src/repositories/repo.dart';
// import 'package:reg_page/src/utils/urls.dart';
// import 'package:reg_page/src/welcome/components/already_subscribed.dart';
// import 'package:reg_page/src/welcome/components/header_image.dart';
// import 'package:reg_page/src/welcome/components/info_button.dart';
// import 'package:reg_page/src/welcome/components/plane_option.dart';
// import 'package:reg_page/src/welcome/components/welcome_text.dart';
// import 'package:reg_page/src/welcome/controllers/in_app_purchase_controller.dart';
// import 'package:reg_page/src/welcome/controllers/purchase_controller.dart';

// class Welcome extends StatefulWidget {
//   const Welcome({
//     Key? key,
//     required this.yearlySubscriptionId,
//     required this.monthlySubscriptionId,
//     required this.appName,
//     required this.appVersion,
//     required this.featuresList,
//     required this.nextPage,
//   }) : super(key: key);

//   final String yearlySubscriptionId;
//   final String monthlySubscriptionId;
//   final String appName;
//   final String appVersion;
//   final List<String> featuresList;
//   final Widget Function() nextPage;

//   @override
//   // ignore: library_private_types_in_public_api
//   _WelcomeState createState() => _WelcomeState();
// }

// class _WelcomeState extends State<Welcome> {
//   bool loading = true;
//   String? monthlyPrice;
//   String? yearlyPrice;
//   int selectedPlan = 2;
//   List<ProductDetails> products = [];

//   late InAppPurchaseHandler purchaseHandler;
//   late TrackingTransparencyHandler trackingTransparencyHandler;

//   @override
//   void initState() {
//     super.initState();
//     purchaseHandler = InAppPurchaseHandler(
//       setLoading: (bool value) {
//         setState(() {
//           loading = value;
//         });
//       },
//       updateProducts: (List<ProductDetails> productList) {
//         setState(() {
//           products = productList;
//           for (var element in products) {
//             if (element.id == widget.yearlySubscriptionId) {
//               yearlyPrice = element.price;
//             } else if (element.id == widget.monthlySubscriptionId) {
//               monthlyPrice = element.price;
//             }
//           }
//         });
//       },
//       onError: (String? error) {
//         if (error != null) {
//           showToast(context: context, message: error, isError: true);
//         }
//       },
//       onPurchaseSuccess: onPurchaseSuccess,
//       context: context,
//     );

//     trackingTransparencyHandler = TrackingTransparencyHandler();

//     initializeData();
//   }

//   Future<void> initializeData() async {
//     await purchaseHandler.initialize(
//         {widget.yearlySubscriptionId, widget.monthlySubscriptionId});
//     await trackingTransparencyHandler.initTrackingTransparency();
//   }

//   void onPlanSelect(int plan) {
//     setState(() {
//       selectedPlan = plan;
//     });
//     LocalDB.setIsFreePlan(plan == 0);
//   }

//   Future<void> onPurchaseSuccess() async {
//     loaderDialog(context);
//     await LocalDB.storeSubscriptionPurchase(true);
//     await LocalDB.storeInAppSubscriptionPurchase(true);

//     final proIds =
//         await Repo().getProductIds(widget.appName, baseUrl: Urls.evoloUrl);
//     if (proIds == null) return;

//     await LocalDB.saveProductIds(proIds);
//     await LocalDB.saveBaseUrl(Urls.evoloUrl);

//     Navigator.pop(context);
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => widget.nextPage()),
//         (route) => false);
//   }

//   Future<void> purchaseSubscription() async {
//     loaderDialog(context);
//     await purchaseHandler.purchaseSubscription(selectedPlan, products);
//     Navigator.pop(context);
//   }

//   Future<void> restorePurchases() async {
//     loaderDialog(context);
//     await purchaseHandler.restorePurchases();
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: AppColor.primaryBlack,
//       body: loading
//           ? Center(
//               child: CircularProgressIndicator(
//                 color: AppColor.primaryRed,
//               ),
//             )
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Stack(
//                   children: [
//                     HeaderImage(height: height, width: width),
//                     Positioned(
//                       left: width * 0.05,
//                       bottom: 20,
//                       child: WelcomeText(height: height),
//                     ),
//                     InfoButton(
//                       width: width,
//                       height: height,
//                       appName: widget.appName,
//                       appVersion: widget.appVersion,
//                       restorePurchase: restorePurchases,
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: width * 0.07),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         Constant.pleaseChoosePlan,
//                         style: TextStyle(
//                           color: AppColor.secondaryWhite,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: Constant.kFontFamilySS3,
//                         ),
//                       ),
//                       SizedBox(
//                           height: height > 650 ? height * 0.03 : height * 0.02),
//                       if (!widget.appName.contains("Course Hub"))
//                         PlanOption(
//                           label: Constant.freeWithAds,
//                           description: Constant.freeWithAdsSubtitle,
//                           selectedPlan: selectedPlan,
//                           planIndex: 0,
//                           onPlanSelect: onPlanSelect,
//                           yearlyPrice: yearlyPrice ?? '',
//                           featuresList: widget.featuresList,
//                         ),
//                       SizedBox(
//                           height: height > 650 ? height * 0.02 : height * 0.01),
//                       PlanOption(
//                         label: Constant.monthlyPlan,
//                         description:
//                             "$monthlyPrice ${Constant.perMonth}, renews automatically",
//                         selectedPlan: selectedPlan,
//                         planIndex: 2,
//                         onPlanSelect: onPlanSelect,
//                         yearlyPrice: yearlyPrice ?? '',
//                         featuresList: widget.featuresList,
//                       ),
//                       SizedBox(
//                           height: height > 650 ? height * 0.02 : height * 0.01),
//                       PlanOption(
//                         label: Constant.annualPlan,
//                         description:
//                             "${Constant.oneWeekFree}$yearlyPrice ${Constant.perYear}",
//                         selectedPlan: selectedPlan,
//                         planIndex: 1,
//                         onPlanSelect: onPlanSelect,
//                         yearlyPrice: yearlyPrice ?? '',
//                         featuresList: widget.featuresList,
//                       ),
//                       SizedBox(
//                           height: height > 650 ? height * 0.03 : height * 0.02),
//                       AlreadySubscribed(onLogin: () {
//                        // widget.nextPage();
//                         print("Kia masla ha ${widget.nextPage}");
//                       }),
//                       SizedBox(
//                           height: height > 650 ? height * 0.03 : height * 0.02),
//                       CustomButton(
//                         buttonName: selectedPlan == 1
//                             ? Constant.tryFree
//                             : Constant.continueText,
//                         buttonColor: AppColor.primaryRed,
//                         textColor: AppColor.primaryWhite,
//                         onPressed: () async {
//                           if (selectedPlan == 0) {
//                             LocalDB.setIsFreePlan(true);
//                             Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => widget.nextPage()),
//                               (route) => false,
//                             );
//                             return;
//                           }
//                           await purchaseSubscription();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   @override
//   void dispose() {
//     purchaseHandler.dispose();
//     super.dispose();
//   }
// }


