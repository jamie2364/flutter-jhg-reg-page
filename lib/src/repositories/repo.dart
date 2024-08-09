import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/services/base_service.dart';
import 'package:reg_page/src/utils/app_urls.dart';

class Repo extends BaseService with BaseController {
  Future<LoginModel?> login(String userName, String password) async {
    try {
      final res = await BaseService().post(AppUrls.login, {
        'username': userName,
        'password': password,
      }).catchError(handleError);
      if (res == null) return null;
      return LoginModel.fromJson(res);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getProductIds(String appName, {String? baseUrl}) async {
    try {
      final res = await get(AppUrls.productIds,
              queryParams: {'app_name': _formatAppName(appName)},
              baseUrl: baseUrl)
          .catchError(handleError);
      if (res == null) return null;
      return res['product_ids'];
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> checkSubscription(String productIds,
      {String? baseUrl}) async {
    try {
      final token = await LocalDB.getBearerToken;
      final res = await get(
        AppUrls.checkSub,
        baseUrl: baseUrl,
        queryParams: {
          "product_ids": productIds,
        },
        headers: {'Authorization': 'Bearer $token'},
      ).catchError(handleError);
      return res;
    } catch (e) {
      return null;
    }
  }

  dynamic postBug(Map<String, dynamic> requestData) async {
    try {
      final token = await LocalDB.getBearerToken;

      final response = await post(
        AppUrls.reportBugUrl,
        baseUrl: '',
        requestData,
        headers: {'Authorization': 'Bearer $token'},
      ).catchError(handleError);
      return response;
    } catch (e) {
      return null;
    }
  }

  String _formatAppName(String input) {
    if (input.toLowerCase().startsWith('jhg')) {
      input = input.substring(3);
    }
    input = input.toLowerCase().trim();
    input = input.replaceAll(' ', '-');
    return input;
  }

  marketingAPi(String email, String appName) async {
    try {
      final res = await post(
              AppUrls.marketingUrl,
              baseUrl: '',
              {
                "subscribers": [
                  {"email": email, "tag_as_event": "$appName User"}
                ]
              },
              headers: Constant.marketingHeaders)
          .catchError(handleError);
      return res;
    } catch (e) {
      return null;
    }
  }
}
