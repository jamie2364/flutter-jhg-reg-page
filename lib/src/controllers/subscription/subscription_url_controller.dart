import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/models/platform_model.dart';
import 'package:reg_page/src/repositories/repo.dart';
import 'package:reg_page/src/utils/navigate/nav.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/utils/url/urls.dart';

class SubscriptionUrlController {
  var platformsList = <PlatformModel>[];
  late PlatformModel selectedModel;
  // String productIds = '';

  void initController() {
    platformsList = PlatformModel.getList();
    if (!Constants.evoloApps.contains(getIt<SplashController>().appName)) {
      platformsList.removeAt(1);
    }
    onPlatformSelected(platformsList[0]);
  }

  void onPlatformSelected(PlatformModel model) {
    selectedModel = model;
    Urls.base = BaseUrl.fromString(model.baseUrl);
  }

  Future<void> getProductIds() async {
    try {
      loaderDialog();
      final res = await Repo().getProductIds(getIt<SplashController>().appName);
      hideLoading();
      if (res != null) {
        getIt<SplashController>().productIds = res;
        LocalDB.saveProductIds(res);
        Nav.to(const LoginScreen());
      } else {
        showErrorToast(Constants.productIdsFailedMessage);
      }
    } catch (e) {
      showErrorToast(Constants.productIdsFailedMessage);
    }
  }
}
