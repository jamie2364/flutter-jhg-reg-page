import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/info_screen.dart';
import 'package:reg_page/src/restore_popup_dialog.dart';
import 'constant.dart';
import 'colors.dart';
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
    required this.nextPage,
  }) : super(key: key);

  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
  final String appName;
  final String appVersion;
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

  int selectedPlan = 1;

  onPlanSelect(int plan) {
    setState(() {
      selectedPlan = plan;
    });
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
    print(widget.yearlySubscriptionId);
    print(widget.monthlySubscriptionId);

    variant.clear();

    variant.add(widget.yearlySubscriptionId);
    variant.add(widget.monthlySubscriptionId);

    yearlyKey = widget.yearlySubscriptionId;
    monthlyKey = widget.monthlySubscriptionId;
    await subscriptionStream();
  }

  // Payment stream listener
  Future<void> subscriptionStream() async {
    // Clear the product list
    products.clear();

    // Instance of the purchase stream
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    // Listen for stream
    streamSubscription = purchaseUpdated.listen((purchaseList) async {
      // Calling for purchases
      await listenToPurchase(purchaseList);
    }, onDone: () {
      streamSubscription.cancel();
    }, onError: (error) {
      debugPrint("Error");
    });
    initStore(context);
  }

  initStore(BuildContext context) async {
    // Getting subscription
    ProductDetailsResponse productDetailsResponse =
        await inAppPurchase.queryProductDetails(variant);
    if (productDetailsResponse.error == null) {
      products = productDetailsResponse.productDetails;
      debugPrint("$products");
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
      showToast(
        context: context,
        message: productDetailsResponse.error!.message,
        isError: true,
      );
      debugPrint("Error ${productDetailsResponse.error}");
    }
  }

  listenToPurchase(List<PurchaseDetails> purchaseDetailsList) {
    print("list");
    print("PList :$purchaseDetailsList");

    if (purchaseDetailsList.isEmpty) {
      restorePopupDialog(context, Constant.restoreNotFound,
          Constant.restoreNotFoundDescription);
    } else {
      purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          showToast(
            context: context,
            message: purchaseDetails.error!.message,
            isError: true,
          );
          debugPrint("pending");
          Navigator.pop(context);
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint("error");
          showToast(
            context: context,
            message: purchaseDetails.error!.message,
            isError: true,
          );
          Navigator.pop(context);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          debugPrint("Purchased");
          showToast(
            context: context,
            message: purchaseDetails.error!.message,
            isError: false,
          );
          Navigator.pop(context);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          debugPrint("canceled");
          showToast(
            context: context,
            message: purchaseDetails.error!.message,
            isError: true,
          );
          Navigator.pop(context);
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          debugPrint("restored");

          restorePopupDialog(context, Constant.restoreSuccess,
              Constant.restoreSuccessDescription);
        }
      });
    }
  }

  Future<void> purchaseSubscription(int plan) async {
    loaderDialog(context);
    final PurchaseParam param =
        PurchaseParam(productDetails: plan == 1 ? products[0] : products[1]);
    try {
      bool isAvailable = await inAppPurchase.isAvailable();
      if (isAvailable) {
        await inAppPurchase.buyNonConsumable(purchaseParam: param);
        // Ignore: use_build_context_synchronously
        Navigator.pop(context);
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
      print(e);
      Navigator.pop(context);
      // Error restoring purchases
    }
  }

  // void showWeeklySaveInfoDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding:
  //             EdgeInsets.only(top: 100.0), // Adjust the top padding as needed
  //         child: AlertDialog(
  //           title: Text(
  //             "Annual Subscription Info",
  //             style: TextStyle(
  //               color: AppColor.secondaryWhite,
  //               fontSize: 22, // Adjust the font size as needed
  //               fontWeight: FontWeight.bold, // Adjust the font weight as needed
  //             ),
  //           ),
  //           content: Text(
  //             "Get a free trial for 7 days, after which you will be automatically charged the annual fee. You may cancel at any time during the trial period, or anytime after. Upon cancellation, your subscription will remain active for one year after your previous payment.",
  //             style: TextStyle(
  //               color: AppColor.secondaryWhite,
  //               fontSize: 14,
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //           backgroundColor: AppColor.primaryBlack,
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text(
  //                 "OK",
  //                 style: TextStyle(
  //                   color: AppColor.primaryRed, // Set the text color here
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Close the dialog
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.primaryBlack,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.04),
          child: loading
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
                          height: height * 0.44,
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
                            height: height * 0.44,
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
                              0, // Adjust the bottom value to move it downwards
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Heading(text: Constant.welcome),
                              Text(
                                Constant.welcomeDescription,
                                style: TextStyle(
                                  color: AppColor.primaryWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                replaceAppName(),
                                style: TextStyle(
                                  color: AppColor.primaryWhite,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
        
                        // INFORMATION BUTTON
        
                        Positioned(
                            right: width * 0.05,
                            top: height *
                                0.03, // Adjust the bottom value to move it downwards
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
                                size: width * 0.065,
                              ),
                            )),
                      ],
                    ),
        
                    // PACKAGE SELECTION
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.07,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SPACER
                          SizedBox(
                            height: height * 0.02,
                          ),
        
                          // PLEASE CHOOSE TEXT
                          Text(
                            Constant.pleaseChoosePlan,
                            style: TextStyle(
                              color: AppColor.secondaryWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SignUp(
                            yearlySubscriptionId:
                            widget.yearlySubscriptionId,
                            monthlySubscriptionId:
                            widget.monthlySubscriptionId,
                            appName: widget.appName,
                            appVersion: widget.appVersion,
                            nextPage: widget.nextPage,
                          ),
                          // SPACER
                          SizedBox(
                            height: height * 0.02,
                          ),
        
        
        
                          // SPACER
                          SizedBox(
                            height: height * 0.03,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
