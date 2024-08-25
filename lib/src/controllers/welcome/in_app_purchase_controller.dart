// // ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseHandler {
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> streamSubscription;
  final Function(bool) setLoading;
  final Function(List<ProductDetails>) updateProducts;
  final Function(String?) onError;
  final Function() onPurchaseSuccess;
  final BuildContext context;

  InAppPurchaseHandler({
    required this.setLoading,
    required this.updateProducts,
    required this.onError,
    required this.onPurchaseSuccess,
    required this.context,
  });

  Future<void> initialize(Set<String> productIds) async {
    setLoading(true);
    bool isAvailable = await inAppPurchase.isAvailable();

    if (!isAvailable) {
      onError("In-App Purchases are not available.");
      setLoading(false);
      return;
    }

    await _initializeStream();

    ProductDetailsResponse productDetailsResponse =
        await inAppPurchase.queryProductDetails(productIds);

    if (productDetailsResponse.error != null) {
      onError(productDetailsResponse.error!.message);
    } else {
      updateProducts(productDetailsResponse.productDetails);
    }

    setLoading(false);
  }

  Future<void> _initializeStream() async {
    streamSubscription = inAppPurchase.purchaseStream.listen(
      (purchaseDetailsList) {
        _handlePurchase(purchaseDetailsList);
      },
      onError: (error) {
        onError(error.toString());
      },
    );
  }

  Future<void> _handlePurchase(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        onPurchaseSuccess();
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        onError(purchaseDetails.error?.message);
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> purchaseSubscription(
      int plan, List<ProductDetails> products) async {
    final product = plan == 1
        ? products.firstWhere((product) => product.id.contains("annual"))
        : products.firstWhere((product) => product.id.contains("monthly"));

    final PurchaseParam param = PurchaseParam(productDetails: product);

    try {
      await inAppPurchase.buyNonConsumable(purchaseParam: param);
    } on PlatformException catch (e) {
      onError(e.message);
    }
  }

  Future<void> restorePurchases() async {
    try {
      await inAppPurchase.restorePurchases();
    } on PlatformException catch (e) {
      onError(e.message);
    }
  }

  void dispose() {
    streamSubscription.cancel();
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

// class InAppPurchaseController {
//   final InAppPurchase inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> streamSubscription;
//   final List<ProductDetails> products = [];
//   final Function(bool) setLoading;
//   final Function(String?, String?) updatePrices;
//   String monthlyPrice, yearlyPrice;

//   InAppPurchaseController({
//     required this.setLoading,
//     required this.updatePrices,
//     required this.monthlyPrice,
//     required this.yearlyPrice,
//   });

//   Future<void> initialize(
//     Set<String> variant,
//     String yearlyKey,
//     String monthlyKey,
//     BuildContext context,
//   ) async {
//     setLoading(true);

//     if (!await inAppPurchase.isAvailable()) {
//       setLoading(false);
//       return;
//     }

//     // Initialize subscription stream
//     await _initializeStream(context);

//     // Query product details
//     ProductDetailsResponse productDetailsResponse =
//         await inAppPurchase.queryProductDetails(variant);

//     if (productDetailsResponse.error == null) {
//       products.addAll(productDetailsResponse.productDetails);

//       for (var element in products) {
//         if (element.id == yearlyKey) {
//           updatePrices(element.price, monthlyPrice);
//         } else if (element.id == monthlyKey) {
//           updatePrices(yearlyPrice, element.price);
//         }
//       }
//     }

//     setLoading(false);
//   }

//   Future<void> _initializeStream(BuildContext context) async {
//     streamSubscription = inAppPurchase.purchaseStream.listen(
//       (purchaseList) async {
//         for (var purchaseDetails in purchaseList) {
//           if (purchaseDetails.pendingCompletePurchase) {
//             await inAppPurchase.completePurchase(purchaseDetails);
//           }
//         }
//       },
//       onDone: () {
//         streamSubscription.cancel();
//       },
//       onError: (error) {
//         streamSubscription.cancel();
//       },
//     );
//   }

//   Future<void> purchaseSubscription(
//     int plan,
//     BuildContext context,
//   ) async {
//     final selectedProduct = plan == 1
//         ? products.firstWhere((element) => element.id.contains("annual"))
//         : products.firstWhere((element) => element.id.contains("monthly"));

//     final PurchaseParam param = PurchaseParam(productDetails: selectedProduct);

//     try {
//       await inAppPurchase.buyNonConsumable(purchaseParam: param);
//     } on PlatformException catch (e) {
//       Navigator.pop(context);
//       _showToast(context, e.message!);
//     }
//   }

//   Future<void> restorePurchase(BuildContext context) async {
//     try {
//       await inAppPurchase.restorePurchases();
//     } on PlatformException catch (e) {
//       Navigator.pop(context);
//       _showToast(context, e.message!);
//     }
//   }

//   void _showToast(BuildContext context, String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   void dispose() {
//     streamSubscription.cancel();
//   }
// }
