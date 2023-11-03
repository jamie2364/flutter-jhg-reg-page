import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:reg_page/reg_page.dart';
import 'constant.dart';
import 'colors.dart';
import 'custom_button.dart';
import 'heading.dart';

class Welcome extends StatefulWidget {
  const Welcome(
      {super.key,
      required this.yearlySubscriptionId,
      required this.monthlySubscriptionId,
      required this.nextPage});
  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
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

  //========================================================================
  //IN APP PURCHASE

  // static const String yearlyKey = "com.jamieharrisonguitar.taptempo.freetrial";
  // static const  String monthlyKey = "com.jamieharrisonguitar.taptempo.monthly";

  InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<dynamic> streamSubscription;
  List<ProductDetails> products = [];
  //Set<String> variant = <String> {yearlyKey, monthlyKey};

  // Initialize subscription
  Future<void> initializedData() async {
    variant.clear();

    variant.add(widget.yearlySubscriptionId);
    variant.add(widget.monthlySubscriptionId);

    yearlyKey = widget.yearlySubscriptionId;
    monthlyKey = widget.monthlySubscriptionId;
    await subscriptionStream();
  }

  // payment stream listener
  Future<void> subscriptionStream() async {
    // clear the product list
    products.clear();

    // instance of the purchase stream
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    // listen for stream
    streamSubscription = purchaseUpdated.listen((purchaseList) async {
      //  calling for purchases
      await listenToPurchase(purchaseList);
    }, onDone: () {
      streamSubscription.cancel();
    }, onError: (error) {
      debugPrint("Error");
    });
    initStore(context);
  }

  initStore(BuildContext context) async {
    // getting subscription
    ProductDetailsResponse productDetailsResponse =
        await inAppPurchase.queryProductDetails(variant);
    if (productDetailsResponse.error == null) {
      products = productDetailsResponse.productDetails;
      print(products);
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
      // ignore: use_build_context_synchronously
      showToast(
          context: context,
          message: productDetailsResponse.error!.message,
          isError: true);
      debugPrint("Error ${productDetailsResponse.error}");
    }
  }

  listenToPurchase(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showToast(
            context: context,
            message: purchaseDetails.error!.message,
            isError: true);
        debugPrint("pending");
        Navigator.pop(context);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint("error");
        showToast(
            context: context,
            message: purchaseDetails.error!.message,
            isError: true);
        Navigator.pop(context);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        debugPrint("Purchased");
        showToast(
            context: context,
            message: purchaseDetails.error!.message,
            isError: false);
        Navigator.pop(context);
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        debugPrint("canceled");
        showToast(
            context: context,
            message: purchaseDetails.error!.message,
            isError: true);
        Navigator.pop(context);
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        debugPrint("restored");
        showToast(
            context: context,
            message: purchaseDetails.error!.message,
            isError: false);
        Navigator.pop(context);
      }
    });
  }

  Future<void> purchaseSubscription(int plan) async {
    loaderDialog(context);
    final PurchaseParam param =
        PurchaseParam(productDetails: plan == 1 ? products[0] : products[1]);
    try {
      bool isAvailable = await inAppPurchase.isAvailable();
      if (isAvailable) {
        await inAppPurchase.buyNonConsumable(purchaseParam: param);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } on PlatformException catch (e) {
      Navigator.pop(context);
      showToast(context: context, message: e.message!, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.primaryBlack,
      body: Padding(
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
                      SizedBox(
                        width: width,
                        height: height * 0.44,
                        child: Image.asset(
                          "assets/images/jhg.png",
                          fit: BoxFit.cover,
                        ),
                      ),
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
                              AppColor.primaryBlack
                            ])),
                      )),
                      Positioned(
                          left: width * 0.05,
                          bottom: 0,
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
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.07,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.06,
                        ),
                        Text(
                          Constant.pleaseChoosePlan,
                          style: TextStyle(
                              color: AppColor.secondaryWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Center(
                            child: Container(
                          height: height * 0.13,
                          width: width * 0.85,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: selectedPlan == 1
                                      ? AppColor.primaryRed
                                      : AppColor.primaryWhite,
                                  width: 1.5),
                              color: AppColor.primaryBlack),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.050),
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
                                          style: TextStyle(
                                              color: AppColor.primaryWhite,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                          "${Constant.oneWeekFree}$yearlyPrice per Year",
                                          style: TextStyle(
                                              color: AppColor.secondaryWhite,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            onPlanSelect(1);
                                          },
                                          child: Container(
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
                                                  width: 1.8),
                                            ),
                                            child: Icon(
                                              Icons.done,
                                              color: AppColor.primaryBlack,
                                              size: width * 0.04,
                                            ),
                                          ),
                                        )),
                                  ),
                                  Divider(
                                    color: AppColor.secondaryWhite,
                                  ),
                                  Text(Constant.weeklySave,
                                      style: TextStyle(
                                          color: AppColor.secondaryWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400))
                                ],
                              )),
                        )),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Center(
                            child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: selectedPlan == 2
                                      ? AppColor.primaryRed
                                      : AppColor.primaryWhite,
                                  width: 1.5),
                              color: AppColor.primaryBlack),
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.035),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        Constant.monthlyPlan,
                                        style: TextStyle(
                                            color: AppColor.primaryWhite,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Text(
                                        monthlyPrice ?? '',
                                        style: TextStyle(
                                            color: AppColor.secondaryWhite,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ]),
                                GestureDetector(
                                  onTap: () {
                                    onPlanSelect(2);
                                  },
                                  child: Container(
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
                                          width: 1.8),
                                    ),
                                    child: Icon(
                                      Icons.done,
                                      color: AppColor.primaryBlack,
                                      size: width * 0.04,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Constant.alreadySubscribed,
                              style: TextStyle(
                                  color: AppColor.primaryWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SignUp(
                                    yearlySubscriptionId:
                                        widget.yearlySubscriptionId,
                                    monthlySubscriptionId:
                                        widget.monthlySubscriptionId,
                                    nextPage: widget.nextPage,
                                  );
                                }));
                              },
                              child: Text(
                                Constant.logIn,
                                style: TextStyle(
                                    color: AppColor.primaryWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        CustomButton(
                            buttonName: selectedPlan == 1
                                ? Constant.tryFree
                                : Constant.continueText,
                            buttonColor: AppColor.primaryRed,
                            textColor: AppColor.primaryWhite,
                            onPressed: () async {
                              await purchaseSubscription(selectedPlan);
                            })
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
