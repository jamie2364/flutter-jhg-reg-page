import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/repositories/repo.dart';
import 'package:reg_page/src/utils/dialogs/restore_popup_dialog.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/utils/url/urls.dart';
import 'package:reg_page/src/views/screens/subscription/subscription_url_screen.dart';

class WelcomeController {
  late String appName;
  late String yearlySubscriptionId;
  late String monthlySubscriptionId;
  late SplashController spController;

  ValueNotifier<int> selectedPlan = ValueNotifier<int>(1);
  String? monthlyPrice;
  String? yearlyPrice;
  bool loading = true;
  String? monthlyKey;
  String? yearlyKey;

  Set<String> variant = <String>{};

  late InAppPurchase inAppPurchase;
  late StreamSubscription<dynamic> streamSubscription;
  List<ProductDetails> products = [];

  WelcomeController() {
    spController = getIt<SplashController>();
    appName = spController.appName;
    yearlySubscriptionId = spController.yearlySubscriptionId;
    monthlySubscriptionId = spController.monthlySubscriptionId;
    if (kIsWeb) return;
    inAppPurchase = InAppPurchase.instance;
  }

  void onPlanSelect(int plan) {
    selectedPlan.value = plan;
  }

  replaceAppName() {
    const excludedText = "JHG";
    String result = appName.replaceAll(excludedText, '');
    return result;
  }

  // Initialize data
  Future<void> initializeData() async {
    debugLog(yearlySubscriptionId);
    debugLog(monthlySubscriptionId);

    variant.clear();
    variant.add(yearlySubscriptionId);
    variant.add(monthlySubscriptionId);

    yearlyKey = yearlySubscriptionId;
    monthlyKey = monthlySubscriptionId;
    if (kIsWeb) {
      loading = false;
      return;
    }
    if (!await inAppPurchase.isAvailable()) {
      loading = false;
      return;
    }

    await _subscriptionStream();
    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((_) => _initTrackingTransparency());
  }

  // Subscription stream listener
  Future<void> _subscriptionStream() async {
    debugLog("Subscription stream called");
    products.clear();
    Stream purchaseUpdated = inAppPurchase.purchaseStream;

    streamSubscription = purchaseUpdated.listen((purchaseList) async {
      await _listenToPurchase(purchaseList);
    }, onDone: () {
      streamSubscription.cancel();
    }, onError: (error) {
      exceptionLog("Error $error");
      streamSubscription.cancel();
    });

    await _initStore();
  }

  // Initialize store
  Future<void> _initStore() async {
    try {
      ProductDetailsResponse productDetailsResponse =
          await inAppPurchase.queryProductDetails(variant);

      if (productDetailsResponse.error == null) {
        products = productDetailsResponse.productDetails;
        for (var element in products) {
          if (element.id == yearlyKey) {
            yearlyPrice = element.price;
          } else if (element.id == monthlyKey) {
            monthlyPrice = element.price;
          }
        }
        loading = false;
      } else {
        loading = false;
        showToast(
          message: productDetailsResponse.error!.message,
          isError: true,
        );
        debugPrint("Error ${productDetailsResponse.error}");
      }
    } catch (e) {
      loading = false;
      exceptionLog(e.toString());
      showToast(message: "Error initializing store", isError: true);
    } finally {
      // hideLoading();
    }
  }

  // Listen to purchase
  Future<void> _listenToPurchase(
      List<PurchaseDetails> purchaseDetailsList) async {
    debugLog('listening to purchase $purchaseDetailsList');
    try {
      if (purchaseDetailsList.first.error != null) {
        debugLog(purchaseDetailsList.first.error.toString(), name: 'ERROR');
        hideLoading();
        return;
      }

      if (purchaseDetailsList.isEmpty) {
        _restorePopupDialog(
            Constants.restoreNotFound, Constants.restoreNotFoundDescription);
      } else {
        for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
          if (purchaseDetails.status == PurchaseStatus.purchased) {
            await _onPurchasedSuccess();
            Nav.off(spController.nextPage());
          } else if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
        }
      }
    } catch (e) {
      hideLoading();
      exceptionLog(e.toString());
      showToast(message: "Error processing purchase", isError: true);
    }
  }

  // Handle purchased success
  Future<void> _onPurchasedSuccess() async {
    try {
      loaderDialog();
      await LocalDB.storeSubscriptionPurchase(true);
      await LocalDB.storeInAppSubscriptionPurchase(true);

      final proIds =
          await Repo().getProductIds(appName, baseUrl: Urls.evoloUrl);
      if (proIds != null) {
        await LocalDB.saveProductIds(proIds);
        await LocalDB.saveBaseUrl(Urls.evoloUrl);
      }
    } catch (e) {
      exceptionLog(e.toString());
      showToast(
          message: "Error during purchase success handling", isError: true);
    }
  }

  // Restore purchases
  Future<void> restorePurchase() async {
    try {
      loaderDialog();
      await inAppPurchase.restorePurchases();
    } on PlatformException catch (e) {
      exceptionLog(e);
      showToast(message: e.message!, isError: true);
    } finally {
      hideLoading();
    }
  }

  // Purchase subscription
  Future<void> purchaseSubscription(int plan) async {
    try {
      loaderDialog();
      debugLog("SELECTED PLAN IS $plan");

      int selectedProductIndex = _getProductIndex(plan);

      final PurchaseParam param =
          PurchaseParam(productDetails: products[selectedProductIndex]);

      if (await inAppPurchase.isAvailable()) {
        await inAppPurchase.buyNonConsumable(purchaseParam: param);
      }
    } on PlatformException catch (e) {
      hideLoading();
      showToast(message: e.message!, isError: true);
    }
  }

  // Helper function to get the index of the selected product
  int _getProductIndex(int plan) {
    for (int i = 0; i < products.length; i++) {
      if (plan == 2 && products[i].id.contains("annual")) {
        return i;
      } else if (plan == 1 && products[i].id.contains("monthly")) {
        return i;
      }
    }
    return 1;
  }

  void _restorePopupDialog(String title, String description) {
    restorePopupDialog(Nav.key.currentState!.context, title, description);
  }

  // Launch next page logic
  Future<void> launchNextPage() async {
    if (Constants.jhgApps.contains(appName)) {
      Urls.base = BaseUrl.jhg;
      loaderDialog();
      final productIds = await Repo().getProductIds(appName);
      if (productIds == null) return;
      getIt<SplashController>().productIds = productIds;
      hideLoading();
      Nav.to(const LoginScreen());
      return;
    }
    Nav.to(const SubscriptionUrlScreen());
  }

  // Tracking transparency initialization
  Future<void> _initTrackingTransparency() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    if (kDebugMode) print("UUID: $uuid");
  }
}
