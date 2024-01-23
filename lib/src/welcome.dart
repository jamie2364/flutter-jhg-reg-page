// ignore_for_file: use_build_context_synchronously

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
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

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
    print("VARIANT IS $variant");

    variant.add(widget.yearlySubscriptionId);
    variant.add(widget.monthlySubscriptionId);
    print("VARIANT IS $variant");

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
      streamSubscription.cancel();
    });
    initStore(context);
  }

  initStore(BuildContext context) async {
    // Getting subscription
    ProductDetailsResponse productDetailsResponse =
        await inAppPurchase.queryProductDetails(variant);
    print("VARIANT IS $variant");

    if (productDetailsResponse.error == null) {
      products = productDetailsResponse.productDetails;
      debugPrint("$products");
      for (var element in products) {
        print("products id  IS ${element.id}");

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

  listenToPurchase(List<PurchaseDetails> purchaseDetailsList) {
    print("list");
    print("PList :${purchaseDetailsList}");

    if (purchaseDetailsList.isEmpty) {
      restorePopupDialog(context, Constant.restoreNotFound,
          Constant.restoreNotFoundDescription);
    } else {
      // ignore: avoid_function_literals_in_foreach_calls
      purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        print("productID IS ${purchaseDetails.productID}");
        print("purchaseID IS ${purchaseDetails.purchaseID}");
        if (purchaseDetails.status == PurchaseStatus.pending) {
          print("productID IS ${purchaseDetails.productID}");
          print("purchaseID IS ${purchaseDetails.purchaseID}");
          
          debugPrint("pending");
          //Navigator.pop(context);
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          Navigator.pop(context);
          debugPrint("error");
          print("ERROR IS ${purchaseDetails.error}");
          // purchaseDetails.error == null
          //     ? const SizedBox()
          //     : showToast(
          //         context: context,
          //         message: purchaseDetails.error!.message,
          //         isError: true,
          //       );
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          debugPrint("Purchased");
          Navigator.pop(context);
          purchaseDetails.error == null
              ? const SizedBox()
              : showToast(
                  context: context,
                  message: purchaseDetails.error!.message,
                  isError: false,
                );
          //ignore: use_build_context_synchronously
          await LocalDB.storeSubscriptionPurchase(true);

          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return widget.nextPage();

          }), (route) => false);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          debugPrint("canceled");
          Navigator.pop(context);
          print("ERROR IS::: ${purchaseDetails.error}");
        }
         else if (purchaseDetails.status == PurchaseStatus.restored) {
          debugPrint("restored");
          Navigator.pop(context);
          //ignore: use_build_context_synchronously
          await LocalDB.storeSubscriptionPurchase(true);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return widget.nextPage();
          }), (route) => false);
          restorePopupDialog(context, Constant.restoreSuccess,
              Constant.restoreSuccessDescription); 
        }
        else if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance
              .completePurchase(purchaseDetails);
        }
      });
    }
  }

Future<void> purchaseSubscription(int plan) async {
  loaderDialog(context);
  print("SELECTED PLAN IS $plan");

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



  final PurchaseParam param = PurchaseParam(productDetails: products[selectedProductIndex]);
  
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
      await  inAppPurchase.buyNonConsumable(purchaseParam: param);
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
                      height: height * 0.46,
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
                  padding: EdgeInsets.only(
                    right: width * 0.07,
                    left: width * 0.07,
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

                      // SPACER
                      SizedBox(
                        height: height * 0.02,
                      ),

                      // ANNUAL PLAN BUTTON

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            onPlanSelect(1);
                          },
                          child: Container(
                            height: height * 0.13,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height * 0.07,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        Constant.annualPlan,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColor.primaryWhite,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${Constant.oneWeekFree}$yearlyPrice ${Constant.perYear}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColor.secondaryWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      trailing: Container(
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
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: AppColor.secondaryWhite,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showWeeklySaveInfoDialog(
                                          context, yearlyPrice);
                                    },
                                    child: Text(
                                      Constant.weeklySave,
                                      style: TextStyle(
                                        color: AppColor.primaryRed,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration
                                            .underline, // Add underline to indicate it's clickable
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // SPACER
                      SizedBox(
                        height: height * 0.03,
                      ),

                      // MONTHLY PLAN BUTTON
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            onPlanSelect(2);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.85,
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
                              child: Row(
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
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Text(
                                        "$monthlyPrice ${Constant.perMonth}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColor.secondaryWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
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
                            ),
                          ),
                        ),
                      ),

                      // SPACER
                      SizedBox(
                        height: height * 0.02,
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
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SignUp(
                                      yearlySubscriptionId:
                                          widget.yearlySubscriptionId,
                                      monthlySubscriptionId:
                                          widget.monthlySubscriptionId,
                                      appName: widget.appName,
                                      appVersion: widget.appVersion,
                                      nextPage: widget.nextPage,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text(
                              Constant.logIn,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColor.primaryWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // SPACER
                      SizedBox(
                        height: height * 0.03,
                      ),

                      // START FREE TRAIL  , CONTINUE BUTTON
                      CustomButton(
                        buttonName: selectedPlan == 1
                            ? Constant.tryFree
                            : Constant.continueText,
                        buttonColor: AppColor.primaryRed,
                        textColor: AppColor.primaryWhite,
                        onPressed: () async {
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
}
