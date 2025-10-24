import 'package:http/http.dart' as http;
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/models/result.dart';
import 'package:reg_page/src/models/user.dart';
import 'package:reg_page/src/services/base_service.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/utils/url/urls.dart';

class UserRepo extends BaseService with BaseController {
  //User

  Future<Result?> registerUser(Map<String, dynamic> userData) async {
    try {
      final res = await post(
        Urls.register,
        userData,
      ).catchError((error) => handleError(error));
      // print('res in repo ==> $res');
      if (res == null) return null;
      return Result.fromMap(res);
    } catch (e) {
      Log.ex('exception on  register user repo $e');
      return null;
    }
  }

  Future<Result> loginUser(
    Map<String, dynamic> userData, {
    bool checkError = false,
    bool hideLoader = false,
    String? baseUrl,
  }) async {
    Result result = Result(code: 0, message: '');
    try {
      // print('----->>>> requesting');
      final res = await post(Urls.login, userData, baseUrl: baseUrl)
          .catchError((error) {
        // print('----->>>> error in login user res $error');
        if (checkError) return handleError(error, hideLoader: hideLoader);
        if (error is UnAutthorizedException) {
          // print(
          //     '----->>>> in UnAutthorizedException error in login user res $error');
          if (error.errorCode == null) return handleError(error);
          if (error.errorCode!.contains('incorrect_password')) {
            // print(
            //     '----->>>> in UnAutthorizedException error in login user res incorrect_password');
            result = Result(code: error.errorCode, message: error.message);
            return null;
          } else if (error.errorCode!.contains('invalid_username') ||
              error.errorCode!.contains('invalid_email')) {
            // print(
            //     '----->>>> in UnAutthorizedException error in login user res invalid_email');
            result = Result(code: error.errorCode, message: error.message);
            return null;
          }
        }
        return handleError(error, hideLoader: hideLoader);
      });
      // print('----->>>> res in login user res $result');
      if (res == null) return result;

      return Result(code: 1, message: 'success', data: User.fromMap(res));
    } catch (e) {
      Log.ex('exception on  login user repo $e');
      return result;
    }
  }

  Future<Result?> lostPassword(String email) async {
    // Construct the full URL to the webpage, not an API endpoint
    String url;
    const String path = 'my-account/lost-password/';

    if (Urls.base.isEqual(Urls.jhgUrl)) {
      url = Urls.jhgUrl + path;
    } else if (Urls.base.isEqual(Urls.musicUrl)) {
      url = Urls.musicUrl + path;
    } else if (Urls.base.isEqual(Urls.evoloUrl)) {
      url = Urls.evoloUrl + path;
    } else {
      showErrorToast("Invalid password reset URL.");
      return null;
    }

    try {
      // We must send this as 'application/x-www-form-urlencoded'
      // which mimics a browser form submission.
      // The 'user_login' key is what WooCommerce expects.
      final body = {'user_login': email};
      final uri = Uri.parse(url);

      Log.req(uri, 'POST (FORM)', body: body);

      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      Log.d("Password reset response status: ${response.statusCode}");
      Log.d("Password reset final URL: ${response.request?.url.toString()}");

      // SUCCESS: The http client follows the 302 redirect automatically.
      // We check if the *final* URL it landed on is the success page.
      if (response.request != null &&
          response.request!.url.toString().contains('reset-link-sent=true')) {
        return Result(code: 1, message: Constants.passwordRecoveryEmailSent);
      }
      // FAIL: The page reloaded but showed an error (e.g., invalid email)
      else if (response.statusCode == 200 &&
          response.body.contains('woocommerce-error')) {
        showErrorToast("Invalid username or email.");
        return null;
      }
      // FAIL: Other unexpected error
      else {
        showErrorToast('Could not reset password. Please try again.');
        return null;
      }
    } catch (e) {
      Log.ex('exception on lostPassword repo $e');
      handleError(e);
      return null;
    }
  }
}