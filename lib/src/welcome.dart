// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/info_screen.dart';
import 'package:reg_page/src/repositories/repo.dart';
import 'package:reg_page/src/restore_popup_dialog.dart';
import 'package:reg_page/src/subcription_url_screen.dart';
import 'package:reg_page/src/utils/urls.dart';
import 'package:reg_page/src/utils/utils.dart';

import 'colors.dart';
import 'constant.dart';
import 'custom_button.dart';
import 'heading.dart';
import 'subscription_info_popup.dart';

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
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool loading = true;

  String? monthlyKey;
  String? yearlyKey;

  String? monthlyPrice;
  String? yearlyPrice;

  Set<String> variant = <String>{};

  @override
  void initState() {
    initializedData();
    super.initState();
  }

  int selectedPlan = 2;

  onPlanSelect(int plan) {
    setState(() {
      selectedPlan = plan;
    });
    LocalDB.setIsFreePlan(plan == 0 ? true : false);
  }

  replaceAppName() {
    // Define the text to remove (uppercase)
    const excludedText = "JHG";

    // Replace the specified text with an empty string
    String result = widget.appName.replaceAll(excludedText, '');

    return result;
  }

  //========================================================================
  // IN APP PURCHASE

  InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<dynamic> streamSubscription;
  List<ProductDetails> products = [];

  // Initialize subscription
  Future<void> initializedData() async {
    debugLog(widget.yearlySubscriptionId);
    debugLog(widget.monthlySubscriptionId);

    variant.clear();
    variant.add(widget.yearlySubscriptionId);
    variant.add(widget.monthlySubscriptionId);

    yearlyKey = widget.yearlySubscriptionId;
    monthlyKey = widget.monthlySubscriptionId;
    if (kIsWeb) {
      setState(() {
        loading = false;
      });
      return;
    }
    await subscriptionStream();
    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((_) => initTrackingTransparency());
  }

  // Payment stream listener
  Future<void> subscriptionStream() async {
    debugLog("subscriptionStream Calllled");
    // Clear the product list
    products.clear();

    // Instance of the purchase stream
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    bool isAvailable = await InAppPurchase.instance.isAvailable();
    debugLog("InAppPurchase isAvailable : $isAvailable");
    // int purchaseList=await purchaseUpdated.length;
    //  print("purchaseList : Before : ${purchaseList}");
    // Listen for stream
    streamSubscription = purchaseUpdated.listen((purchaseList) async {
      // Calling for purchases
      await listenToPurchase(purchaseList);
    }, onDone: () {
      streamSubscription.cancel();
    }, onError: (error) {
      exceptionLog("Error $error");
      streamSubscription.cancel();
    });
    initStore(context);
  }

  initStore(BuildContext context) async {
    // Getting subscription
    ProductDetailsResponse productDetailsResponse =
        await inAppPurchase.queryProductDetails(variant);
    debugLog("VARIANT IS $variant");
    if (productDetailsResponse.error == null) {
      products = productDetailsResponse.productDetails;
      debugLog("products $products");
      for (var element in products) {
        if (element.id == yearlyKey) {
          setState(() {
            yearlyPrice = element.price;
          });
        } else if (element.id == monthlyKey) {
          setState(() {
            monthlyPrice = element.price;
          });
        }
      }
      setState(() {
        loading = false;
      });
    } else if (productDetailsResponse.error != null) {
      setState(() {
        loading = false;
      });

      // Ignore: use_build_context_synchronously
      productDetailsResponse.error == null
          ? const SizedBox()
          : showToast(
              context: context,
              message: productDetailsResponse.error!.message,
              isError: true,
            );
      debugPrint("Error ${productDetailsResponse.error}");
    }
  }

  listenToPurchase(List<PurchaseDetails> purchaseDetailsList) async {
    debugLog("PList :$purchaseDetailsList");

    if (purchaseDetailsList.isEmpty) {
      restorePopupDialog(Utils.getContext ?? context, Constant.restoreNotFound,
          Constant.restoreNotFoundDescription);
    } else {
      // ignore: avoid_function_literals_in_foreach_calls
      int check = 0;
      for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
        // }
        // purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        if (check == 1) break;
        debugLog("purchaseDetails.status : ${purchaseDetails.status}");
        // print("productID IS ${purchaseDetails.productID}");
        // print("purchaseID IS ${purchaseDetails.purchaseID}");
        if (purchaseDetails.status == PurchaseStatus.pending) {
          debugLog("productID IS ${purchaseDetails.productID}");

          debugLog("pending");
          //Navigator.pop(context);
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          Navigator.pop(Utils.getContext ?? context);

          debugLog("ERROR IS ${purchaseDetails.error}");
          // purchaseDetails.error == null
          //     ? const SizedBox()
          //     : showToast(
          //         context: context,
          //         message: purchaseDetails.error!.message,
          //         isError: true,
          //       );
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          debugLog("Purchased");
          Navigator.pop(Utils.getContext ?? context);
          purchaseDetails.error == null
              ? const SizedBox()
              : showToast(
                  context: Utils.getContext ?? context,
                  message: purchaseDetails.error!.message,
                  isError: false,
                );

          //purchased Success
          try {
            await onPurchasedSuccess();
          } catch (e) {
            exceptionLog('exception on $e');
          }
          //
          Navigator.pushAndRemoveUntil(Utils.getContext ?? context,
              MaterialPageRoute(builder: (context) {
            return widget.nextPage();
          }), (route) => false);
          debugLog('pushed to the next page ${widget.nextPage()}');
          check = 1;
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          debugPrint("canceled");
          Navigator.pop(Utils.getContext ?? context);
          debugLog("ERROR IS::: ${purchaseDetails.error}");
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          debugPrint("restored");
          Navigator.pop(Utils.getContext ?? context);
          await LocalDB.storeSubscriptionPurchase(true);
          Navigator.pushAndRemoveUntil(Utils.getContext ?? context,
              MaterialPageRoute(builder: (context) {
            return widget.nextPage();
          }), (route) => false);
          restorePopupDialog(Utils.getContext ?? context,
              Constant.restoreSuccess, Constant.restoreSuccessDescription);
        } else if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
      // );
    }
  }

  Future<void> purchaseSubscription(int plan) async {
    loaderDialog(context);
    debugLog("SELECTED PLAN IS $plan");

    int selectedProductIndex = -1;

    // Determine the index of the product based on the plan and keyword
    for (int i = 0; i < products.length; i++) {
      if (plan == 1 && products[i].id.contains("annual")) {
        selectedProductIndex = i;
        break;
      } else if (plan == 2 && products[i].id.contains("monthly")) {
        selectedProductIndex = i;
        break;
      }
    }

    // If no matching product is found, default to the first product
    if (selectedProductIndex == -1) {
      selectedProductIndex = 0;
    }

    final PurchaseParam param =
        PurchaseParam(productDetails: products[selectedProductIndex]);

    try {
      Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

      // Listen for stream
      streamSubscription = purchaseUpdated.listen((purchaseList) async {
        for (var purchaseDetails in purchaseList) {
          if (purchaseDetails.pendingCompletePurchase) {
            await inAppPurchase.completePurchase(purchaseDetails);
          }
        }
      });
      bool isAvailable = await inAppPurchase.isAvailable();
      if (isAvailable) {
        await inAppPurchase.buyNonConsumable(purchaseParam: param);
      }
    } on PlatformException catch (e) {
      Navigator.pop(context);
      showToast(context: context, message: e.message!, isError: true);
    }
  }

  Future<void> restorePurchase() async {
    try {
      loaderDialog(context);
      await InAppPurchase.instance.restorePurchases();
      Navigator.pop(context);
    } on PlatformException catch (e) {
      exceptionLog(e);
      Navigator.pop(context);
      // Error restoring purchases
    }
  }

  onPurchasedSuccess() async {
    loaderDialog(Utils.getContext ?? context);
    await LocalDB.storeSubscriptionPurchase(true);
    await LocalDB.storeInAppSubscriptionPurchase(true);

    final proIds =
        await Repo().getProductIds(widget.appName, baseUrl: Urls.evoloUrl);
    if (proIds == null) return;
    debugLog('product ids onPurchasedSuccess $proIds');
    await LocalDB.saveProductIds(proIds);
    await LocalDB.saveBaseUrl(Urls.evoloUrl);
    Navigator.pop(Utils.getContext ?? context);
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // IMAGE
                    SizedBox(
                      width: width,
                      height: height > 650
                          ? height * 0.46
                          : height > 440
                              ? height * 0.36
                              : height * 0.30,
                      child: Image.asset(
                        "assets/images/jhg_background.png",
                        package: 'reg_page',
                        fit: BoxFit.cover,
                      ),
                    ),

                    // IMAGE TRANSPARENT BACKGROUND
                    Positioned(
                      child: Container(
                        width: width,
                        height: height > 650
                            ? height * 0.46
                            : height > 440
                                ? height * 0.36
                                : height * 0.30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              AppColor.primaryBlack,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // WELCOME TEXT WITH APP NAME
                    Positioned(
                      left: width * 0.05,
                      bottom:
                          20, // Adjust the bottom value to move it downwards
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading(
                            text: Constant.welcome,
                            height: height,
                          ),
                          Text(
                            Constant.welcomeDescription,
                            style: TextStyle(
                                color: AppColor.primaryWhite,
                                fontSize: height > 650
                                    ? 18
                                    : height > 440
                                        ? 16
                                        : 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: Constant.kFontFamilySS3),
                          ),
                          Text(
                            replaceAppName(),
                            style: TextStyle(
                                color: AppColor.primaryWhite,
                                fontSize: height > 650
                                    ? 30
                                    : height > 440
                                        ? 25
                                        : 22,
                                fontWeight: FontWeight.w700,
                                fontFamily: Constant.kFontFamilySS3),
                          ),
                        ],
                      ),
                    ),

                    // INFORMATION BUTTON

                    Positioned(
                        right: width * 0.05,
                        top: MediaQuery.of(context).padding.top +
                            height *
                                0.01, // Adjust the bottom value to move it downwards
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return InfoScreen(
                                appName: widget.appName,
                                appVersion: widget.appVersion,
                                callback: restorePurchase,
                              );
                            }));
                          },
                          child: Icon(
                            Icons.info_rounded,
                            color: AppColor.primaryWhite,
                            size: 30,
                          ),
                        )),
                  ],
                ),

                // PACKAGE SELECTION
                Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.07,
                    left: width * 0.07,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SPACER
                      // SizedBox(
                      //   height: height * 0.02,
                      // ),

                      // PLEASE CHOOSE TEXT
                      Text(
                        Constant.pleaseChoosePlan,
                        style: TextStyle(
                            color: AppColor.secondaryWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: Constant.kFontFamilySS3),
                      ),

                      // SPACER
                      SizedBox(
                        height: height > 650 ? height * 0.03 : height * 0.02,
                      ),
                      //FREE WITH ADS
                      if (!widget.appName.contains("Course Hub"))
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              onPlanSelect(0);
                            },
                            child: Container(
                              height: selectedPlan == 0
                                  ? height > 640
                                      ? height * 0.13
                                      : height > 470
                                          ? height * 0.18
                                          : height > 410
                                              ? height * 0.20
                                              : height * 0.25
                                  : height > 440
                                      ? height * 0.06
                                      : height * 0.07,
                              width: width * 0.85,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedPlan == 0
                                      ? AppColor.primaryRed
                                      : AppColor.primaryWhite,
                                  width: 1.5,
                                ),
                                color: AppColor.primaryBlack,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.050,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Constant.freeWithAds,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: AppColor.primaryWhite,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily:
                                                  Constant.kFontFamilySS3),
                                        ),
                                        Container(
                                          height: height * 0.027,
                                          width: height * 0.027,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: selectedPlan == 0
                                                ? AppColor.primaryRed
                                                : AppColor.primaryBlack,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: selectedPlan == 0
                                                  ? AppColor.primaryRed
                                                  : AppColor.primaryWhite,
                                              width: 1.8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.done,
                                            color: AppColor.primaryBlack,
                                            size: width * 0.04,
                                          ),
                                        )
                                      ],
                                    ),
                                    Visibility(
                                        visible: selectedPlan == 0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Constant.freeWithAdsSubtitle,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color:
                                                      AppColor.secondaryWhite,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      Constant.kFontFamilySS3),
                                            ),
                                            Divider(
                                              color: AppColor.secondaryWhite,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showWeeklySaveInfoDialog(
                                                    context,
                                                    yearlyPrice,
                                                    widget.featuresList,
                                                    label: Constant.freeWithAds,
                                                    desc: Constant
                                                        .freeWithAdsNote);
                                              },
                                              child: Text(
                                                Constant.weeklySave,
                                                style: TextStyle(
                                                    color: AppColor.primaryRed,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: Constant
                                                        .kFontFamilySS3 // Add underline to indicate it's clickable
                                                    ),
                                              ),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      // SPACER
                      SizedBox(
                        height: height > 650 ? height * 0.02 : height * 0.01,
                      ),

                      // ANNUAL PLAN BUTTON

                      // MONTHLY PLAN BUTTON
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            onPlanSelect(2);
                          },
                          child: Container(
                            height: selectedPlan == 2
                                ? height > 640
                                    ? height * 0.13
                                    : height > 470
                                        ? height * 0.18
                                        : height > 410
                                            ? height * 0.20
                                            : height * 0.25
                                : height > 440
                                    ? height * 0.06
                                    : height * 0.07,
                            width: width * 0.85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedPlan == 2
                                    ? AppColor.primaryRed
                                    : AppColor.primaryWhite,
                                width: 1.5,
                              ),
                              color: AppColor.primaryBlack,
                            ),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.035,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              Constant.monthlyPlan,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: AppColor.primaryWhite,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily:
                                                      Constant.kFontFamilySS3),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: height * 0.027,
                                          width: height * 0.027,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: selectedPlan == 2
                                                ? AppColor.primaryRed
                                                : AppColor.primaryBlack,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: selectedPlan == 2
                                                  ? AppColor.primaryRed
                                                  : AppColor.primaryWhite,
                                              width: 1.8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.done,
                                            color: AppColor.primaryBlack,
                                            size: width * 0.04,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                        visible: selectedPlan == 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "$monthlyPrice ${Constant.perMonth}, renews automatically",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color:
                                                      AppColor.secondaryWhite,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      Constant.kFontFamilySS3),
                                            ),
                                            Divider(
                                              color: AppColor.secondaryWhite,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showMonthlySaveInfoDialog(
                                                    context,
                                                    yearlyPrice,
                                                    widget.featuresList);
                                              },
                                              child: Text(
                                                Constant.weeklySave,
                                                style: TextStyle(
                                                    color: AppColor.primaryRed,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: Constant
                                                        .kFontFamilySS3),
                                              ),
                                            )
                                          ],
                                        ))
                                  ],
                                )),
                          ),
                        ),
                      ),

                      // SPACER
                      SizedBox(
                        height: height > 650 ? height * 0.02 : height * 0.01,
                      ),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            onPlanSelect(1);
                          },
                          child: Container(
                            height: selectedPlan == 1
                                ? height > 640
                                    ? height * 0.13
                                    : height > 470
                                        ? height * 0.18
                                        : height > 410
                                            ? height * 0.20
                                            : height * 0.25
                                : height > 440
                                    ? height * 0.06
                                    : height * 0.07,
                            width: width * 0.85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedPlan == 1
                                    ? AppColor.primaryRed
                                    : AppColor.primaryWhite,
                                width: 1.5,
                              ),
                              color: AppColor.primaryBlack,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.050,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Constant.annualPlan,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: AppColor.primaryWhite,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily:
                                                Constant.kFontFamilySS3),
                                      ),
                                      Container(
                                        height: height * 0.027,
                                        width: height * 0.027,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: selectedPlan == 1
                                              ? AppColor.primaryRed
                                              : AppColor.primaryBlack,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: selectedPlan == 1
                                                ? AppColor.primaryRed
                                                : AppColor.primaryWhite,
                                            width: 1.8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.done,
                                          color: AppColor.primaryBlack,
                                          size: width * 0.04,
                                        ),
                                      )
                                    ],
                                  ),
                                  Visibility(
                                      visible: selectedPlan == 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${Constant.oneWeekFree}$yearlyPrice ${Constant.perYear}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: AppColor.secondaryWhite,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    Constant.kFontFamilySS3),
                                          ),
                                          Divider(
                                            color: AppColor.secondaryWhite,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showWeeklySaveInfoDialog(
                                                  context,
                                                  yearlyPrice,
                                                  widget.featuresList);
                                            },
                                            child: Text(
                                              Constant.weeklySave,
                                              style: TextStyle(
                                                  color: AppColor.primaryRed,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: Constant
                                                      .kFontFamilySS3 // Add underline to indicate it's clickable
                                                  ),
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // SPACER
                      SizedBox(
                        height: height > 650 ? height * 0.03 : height * 0.02,
                      ),

                      // ALREADY SUBSCRIBED AND LOGIN TEXT BUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Constant.alreadySubscribed,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColor.primaryWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                fontFamily: Constant.kFontFamilySS3),
                          ),
                          GestureDetector(
                            onTap: () {
                              LocalDB.setIsFreePlan(false);
                              launchNextPage();
                            },
                            child: Text(
                              Constant.logIn,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColor.primaryWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: Constant.kFontFamilySS3),
                            ),
                          ),
                        ],
                      ),

                      // SPACER
                      SizedBox(
                        height: height > 650 ? height * 0.03 : height * 0.02,
                      ),

                      // START FREE TRAIL  , CONTINUE BUTTON
                      CustomButton(
                        buttonName: selectedPlan == 1
                            ? Constant.tryFree
                            : Constant.continueText,
                        buttonColor: AppColor.primaryRed,
                        textColor: AppColor.primaryWhite,
                        onPressed: () async {
                          if (selectedPlan == 0) {
                            LocalDB.setIsFreePlan(true);
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return widget.nextPage();
                            }), (route) => false);
                            return;
                          }
                          await purchaseSubscription(selectedPlan);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> launchNextPage() async {
    if (Constant.jhgApps.contains(widget.appName)) {
      Urls.base = BaseUrl.jhg;
      loaderDialog();
      final productIds = await Repo().getProductIds(widget.appName);
      if (productIds == null) return;
      hideLoading();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SignUp(
              yearlySubscriptionId: widget.yearlySubscriptionId,
              monthlySubscriptionId: widget.monthlySubscriptionId,
              appName: widget.appName,
              appVersion: widget.appVersion,
              nextPage: widget.nextPage,
              productIds: productIds,
            );
          },
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SubscriptionUrlScreen(
            yearlySubscriptionId: widget.yearlySubscriptionId,
            monthlySubscriptionId: widget.monthlySubscriptionId,
            appName: widget.appName,
            appVersion: widget.appVersion,
            nextPage: widget.nextPage,
          );
        },
      ),
    );
  }

  initTrackingTransparency() async {
    const String authStatus = 'Unknown';
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    // setState(() => _authStatus = '$status');
    // print("Auth Status: $_authStatus");

    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      // await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      // final TrackingStatus status =
      await AppTrackingTransparency.requestTrackingAuthorization();
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("Auth Status: $authStatus, UUID: $uuid");
  }
}
