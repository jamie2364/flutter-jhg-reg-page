// // // ignore_for_file: use_build_context_synchronously

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

// class InAppPurchaseHandler {
//   final InAppPurchase inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> streamSubscription;
//   final Function(bool) setLoading;
//   final Function(List<ProductDetails>) updateProducts;
//   final Function(String?) onError;
//   final Function() onPurchaseSuccess;
//   final BuildContext context;

//   InAppPurchaseHandler({
//     required this.setLoading,
//     required this.updateProducts,
//     required this.onError,
//     required this.onPurchaseSuccess,
//     required this.context,
//   });

//   Future<void> initialize(Set<String> productIds) async {
//     setLoading(true);
//     bool isAvailable = await inAppPurchase.isAvailable();

//     if (!isAvailable) {
//       onError("In-App Purchases are not available.");
//       setLoading(false);
//       return;
//     }

//     await _initializeStream();

//     ProductDetailsResponse productDetailsResponse =
//         await inAppPurchase.queryProductDetails(productIds);

//     if (productDetailsResponse.error != null) {
//       onError(productDetailsResponse.error!.message);
//     } else {
//       updateProducts(productDetailsResponse.productDetails);
//     }

//     setLoading(false);
//   }

//   Future<void> _initializeStream() async {
//     streamSubscription = inAppPurchase.purchaseStream.listen(
//       (purchaseDetailsList) {
//         _handlePurchase(purchaseDetailsList);
//       },
//       onError: (error) {
//         onError(error.toString());
//       },
//     );
//   }

//   Future<void> _handlePurchase(
//       List<PurchaseDetails> purchaseDetailsList) async {
//     for (var purchaseDetails in purchaseDetailsList) {
//       if (purchaseDetails.status == PurchaseStatus.purchased) {
//         onPurchaseSuccess();
//       } else if (purchaseDetails.status == PurchaseStatus.error) {
//         onError(purchaseDetails.error?.message);
//       }

//       if (purchaseDetails.pendingCompletePurchase) {
//         await inAppPurchase.completePurchase(purchaseDetails);
//       }
//     }
//   }

//   Future<void> purchaseSubscription(
//       int plan, List<ProductDetails> products) async {
//     final product = plan == 1
//         ? products.firstWhere((product) => product.id.contains("annual"))
//         : products.firstWhere((product) => product.id.contains("monthly"));

//     final PurchaseParam param = PurchaseParam(productDetails: product);

//     try {
//       await inAppPurchase.buyNonConsumable(purchaseParam: param);
//     } on PlatformException catch (e) {
//       onError(e.message);
//     }
//   }

//   Future<void> restorePurchases() async {
//     try {
//       await inAppPurchase.restorePurchases();
//     } on PlatformException catch (e) {
//       onError(e.message);
//     }
//   }

//   void dispose() {
//     streamSubscription.cancel();
//   }
// }
