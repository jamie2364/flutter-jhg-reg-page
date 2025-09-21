import 'dart:convert';

import 'package:reg_page/src/models/user.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  static String bearerTokenKey = "BearerToken";
  static String endDateKey = "endDateKey";
  static String firstTimeLoginKey = "firstTimerLogin";
  static String userNameKey = "userName";
  static String passwordKey = "password";
  static String userEmailKey = "userEmail";
  static String userIdKey = "UserId";
  static String subscriptionPurchase = "subscriptionPurchase";
  static String subscriptionInAppPurchase = "subscriptionInAppPurchase";
  static String baseUrl = "base_url";
  static String productIds = "product_ids";
  static String loginDateTime = "loginDateTime";

  static Future<SharedPreferences?> get getPref async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  static Future<void> storeEndDate(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(endDateKey, value);
  }

  static Future<String?> get getEndDate async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? bearerToken = sharedPreferences.getString(endDateKey);
    return bearerToken;
  }

  static Future<void> storeBearerToken(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(bearerTokenKey, value);
  }

  static Future<String?> get getBearerToken async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? bearerToken = sharedPreferences.getString(bearerTokenKey);
    return bearerToken;
  }

  static Future<void> storeFirstTimeLogin(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(firstTimeLoginKey, value);
  }

  static Future<bool?> get getFirstTimeLogin async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? login = sharedPreferences.getBool(firstTimeLoginKey);
    return login;
  }

  static Future<void> storeUserName(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(userNameKey, value);
  }

  static Future<String?> get getUserName async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userName = sharedPreferences.getString(userNameKey);
    return userName;
  }

  static Future<void> storePassword(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(passwordKey, value);
  }

  static Future<String?> get getPassword async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(passwordKey);
  }

  static Future<void> get removePassword async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(passwordKey);
  }

  static Future<void> storeUserEmail(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(userEmailKey, value);
  }

  static Future<String?> get getUserEmail async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userEmail = sharedPreferences.getString(userEmailKey);
    return userEmail;
  }

  static Future<void> storeUserId(int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(userIdKey, value);
  }

  static Future<int?> get getUserId async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? userEmail = sharedPreferences.getInt(userIdKey);
    return userEmail;
  }

  static Future<void> storeSubscriptionPurchase(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(subscriptionPurchase, value);
  }

  static Future<void> storeInAppSubscriptionPurchase(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(subscriptionInAppPurchase, value);
  }

  static Future<bool?> get getSubscriptionPurchase async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? purchase = sharedPreferences.getBool(subscriptionPurchase);
    return purchase;
  }

  static Future<bool?> get getSubscriptionInAppPurchase async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? purchase = sharedPreferences.getBool(subscriptionInAppPurchase);
    return purchase;
  }

  static Future<void> clearLocalDB() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  static Future<void> saveBaseUrl(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(baseUrl, value);
  }

  static Future<String?> get getBaseurl async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? url = sharedPreferences.getString(baseUrl);
    return url;
  }

  static Future<void> saveProductIds(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(productIds, value);
  }

  static Future<String?> get getproductIds async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? id = sharedPreferences.getString(productIds);
    return id;
  }

  static Future<void> saveLoginTime(String dateTime) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(loginDateTime, dateTime);
  }

  static Future<bool> get isLoginTimeExpired async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? lastLoginTime = sharedPreferences.getString(loginDateTime);
    if (lastLoginTime != null) {
      var difference =
          DateTime.now().difference(DateTime.parse(lastLoginTime)).inDays;
      if (difference > 3) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  static Future<void> setIsFreePlan(bool isFreePlan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.freePlan, isFreePlan);
  }

  static Future<bool> getIsFreePlan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.freePlan) ?? false;
  }

  static String appUserIdKey = "appUserId";
  static String appUserNameKey = "appUserName";
  static String appUserTokenKey = "appUserToken";
  static String appUserKey = "user";
  static String downloadedKey = "downloaded";

  static Future<void> storeAppUser(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(appUserIdKey, jsonEncode(user.toMap()));
  }

  static Future<User?> get getAppUser async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final json = sharedPreferences.getString(appUserIdKey);
      if (json == null) return null;
      return User.fromMap(jsonDecode(json));
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveIsFilesDownloaded(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(downloadedKey, value);
  }

  static Future<bool> get getIsFilesDownloaded async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(downloadedKey)?? false;
  }
}
