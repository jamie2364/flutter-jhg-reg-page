import 'dart:io';

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

      // Create a client that does NOT follow redirects
      final client = http.Client();
      final request = http.Request('POST', uri)
        ..headers.addAll({
          'Content-Type': 'application/x-www-form-urlencoded',
        })
        ..followRedirects = false // Do not follow the 302 redirect
        ..body = body.entries
            .map((e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&'); // Correctly encode the form body

      final response = await client.send(request);
      final streamedResponse = await http.Response.fromStream(response);

      Log.d("Password reset response status: ${streamedResponse.statusCode}");
      Log.d("Password reset headers: ${streamedResponse.headers}");

      // SUCCESS:
      // A successful form submission will return a 302 redirect.
      // We check the 'location' header for the success parameter.
      if (streamedResponse.statusCode == 302 ||
          streamedResponse.statusCode == 301) {
        final location = streamedResponse.headers[HttpHeaders.locationHeader];
        if (location != null && location.contains('reset-link-sent=true')) {
          return Result(code: 1, message: Constants.passwordRecoveryEmailSent);
        } else {
          // It redirected, but not to the success page. This means an error.
          showErrorToast("Invalid username or email.");
          return null;
        }
      }
      // FAIL: The page loaded again (status 200), meaning an error message
      // is displayed on the page itself.
      else if (streamedResponse.statusCode == 200 &&
          streamedResponse.body.contains('woocommerce-error')) {
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