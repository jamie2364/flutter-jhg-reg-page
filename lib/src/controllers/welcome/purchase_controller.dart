import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class TrackingTransparencyHandler {
  Future<void> initTrackingTransparency() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("Tracking UUID: $uuid");
  }
}

// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

// class PurchaseController {
//   final BuildContext context;
//   final Widget Function() nextPage;
//   final Function() onPurchasedSuccess;

//   PurchaseController({
//     required this.context,
//     required this.nextPage,
//     required this.onPurchasedSuccess,
//   });

//   Future<void> listenToPurchase(
//       List<PurchaseDetails> purchaseDetailsList) async {
//     if (purchaseDetailsList.isEmpty) {
//       _restorePopupDialog();
//     } else {
//       for (var purchaseDetails in purchaseDetailsList) {
//         switch (purchaseDetails.status) {
//           case PurchaseStatus.pending:
//             // Handle pending state
//             break;
//           case PurchaseStatus.error:
//             Navigator.pop(context);
//             _showError(purchaseDetails.error);
//             break;
//           case PurchaseStatus.purchased:
//             Navigator.pop(context);
//             await onPurchasedSuccess();
//             _navigateToNextPage();
//             break;
//           case PurchaseStatus.canceled:
//             Navigator.pop(context);
//             _showError(purchaseDetails.error);
//             break;
//           case PurchaseStatus.restored:
//             Navigator.pop(context);
//             await onPurchasedSuccess();
//             _restorePopupDialog();
//             break;
//           case PurchaseStatus.pendingCompletePurchase:
//             await InAppPurchase.instance.completePurchase(purchaseDetails);
//             break;
//         }
//       }
//     } 
//   }

//   void _navigateToNextPage() {
//     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
//       return nextPage();
//     }), (route) => false);
//   }

//   void _restorePopupDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Restore Successful"),
//           content: const Text("Your purchases have been restored successfully."),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showError(IAPError? error) {
//     if (error != null) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(error.message)));
//     }
//   }
// }
