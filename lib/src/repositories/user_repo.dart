import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/models/result.dart';
import 'package:reg_page/src/models/user.dart';
import 'package:reg_page/src/services/base_service.dart';
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
}