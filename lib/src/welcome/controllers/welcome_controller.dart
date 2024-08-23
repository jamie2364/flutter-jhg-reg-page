// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:reg_page/reg_page.dart';

// class WelcomeController {
//   static String replaceAppName(String appName) {
//     // Define the text to remove (uppercase)
//     const excludedText = "JHG";
//     // Replace the specified text with an empty string
//     String result = appName.replaceAll(excludedText, '');

//     return result;
//   }

//   Future<void> purchaseSubscription(int plan, BuildContext context) async {
//     loaderDialog(context);
//     debugLog("SELECTED PLAN IS $plan");

//     int selectedProductIndex = -1;

//     // Determine the index of the product based on the plan and keyword
//     for (int i = 0; i < products.length; i++) {
//       if (plan == 1 && products[i].id.contains("annual")) {
//         selectedProductIndex = i;
//         break;
//       } else if (plan == 2 && products[i].id.contains("monthly")) {
//         selectedProductIndex = i;
//         break;
//       }
//     }

//     // If no matching product is found, default to the first product
//     if (selectedProductIndex == -1) {
//       selectedProductIndex = 0;
//     }

//     final PurchaseParam param =
//         PurchaseParam(productDetails: products[selectedProductIndex]);

//     try {
//       Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

//       // Listen for stream
//       streamSubscription = purchaseUpdated.listen((purchaseList) async {
//         for (var purchaseDetails in purchaseList) {
//           if (purchaseDetails.pendingCompletePurchase) {
//             await inAppPurchase.completePurchase(purchaseDetails);
//           }
//         }
//       });
//       bool isAvailable = await inAppPurchase.isAvailable();
//       if (isAvailable) {
//         await inAppPurchase.buyNonConsumable(purchaseParam: param);
//       }
//     } on PlatformException catch (e) {
//       // ignore: use_build_context_synchronously
//       Navigator.pop(context);
//       // ignore: use_build_context_synchronously
//       showToast(context: context, message: e.message!, isError: true);
//     }
//   }
// }
