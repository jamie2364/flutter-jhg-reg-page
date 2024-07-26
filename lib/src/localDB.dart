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
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  // Set bearer token
  static Future<void> storeEndDate(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store bearer token in shared preferences
    sharedPreferences.setString(endDateKey, value);
  }

  // Get bearer token
  static Future<String?> get getEndDate async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = sharedPreferences.getString(endDateKey);
    return bearerToken;
  }

  // Set bearer token
  static Future<void> storeBearerToken(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store bearer token in shared preferences
    sharedPreferences.setString(bearerTokenKey, value);
  }

  // Get bearer token
  static Future<String?> get getBearerToken async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = sharedPreferences.getString(bearerTokenKey);
    return bearerToken;
  }

  // Set bearer token
  static Future<void> storeFirstTimeLogin(bool value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store bearer token in shared preferences
    sharedPreferences.setBool(firstTimeLoginKey, value);
  }

  // Get bearer token
  static Future<bool?> get getFirstTimeLogin async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    bool? login = sharedPreferences.getBool(firstTimeLoginKey);
    return login;
  }

  // Set user name
  static Future<void> storeUserName(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store bearer token in shared preferences
    sharedPreferences.setString(userNameKey, value);
  }

  // Get user name
  static Future<String?> get getUserName async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    String? userName = sharedPreferences.getString(userNameKey);
    return userName;
  }

  // Set password
  static Future<void> storePassword(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store bearer token in shared preferences
    sharedPreferences.setString(passwordKey, value);
  }

  // Get password
  static Future<String?> get getPassword async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    return sharedPreferences.getString(passwordKey);
  }

  // Set user name
  static Future<void> storeUserEmail(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store bearer token in shared preferences
    sharedPreferences.setString(userEmailKey, value);
  }

  // Get user name
  static Future<String?> get getUserEmail async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    String? userEmail = sharedPreferences.getString(userEmailKey);
    return userEmail;
  }

  // Set user ID
  static Future<void> storeUserId(int value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store User Id in shared preferences
    sharedPreferences.setInt(userIdKey, value);
  }

  // Get User ID
  static Future<int?> get getUserId async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    int? userEmail = sharedPreferences.getInt(userIdKey);
    return userEmail;
  }

  // Set subscription purchase
  static Future<void> storeSubscriptionPurchase(bool value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store subscription purchase in shared preferences
    sharedPreferences.setBool(subscriptionPurchase, value);
  }
  // Set subscription purchase
  static Future<void> storeInAppSubscriptionPurchase(bool value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store subscription purchase in shared preferences
    sharedPreferences.setBool(subscriptionInAppPurchase, value);
  }

  // Get subscription purchase
  static Future<bool?> get getSubscriptionPurchase async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the subscription purchase which we have stored in sharedPreferences before
    bool? purchase = sharedPreferences.getBool(subscriptionPurchase);
    return purchase;
  }  // Get subscription purchase
  static Future<bool?> get getSubscriptionInAppPurchase async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the subscription purchase which we have stored in sharedPreferences before
    bool? purchase = sharedPreferences.getBool(subscriptionInAppPurchase);
    return purchase;
  }

  // Clear bearer token
  static Future<void> clearLocalDB() async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    await sharedPreferences.clear();
  }

  // save the  BaseUrl
  static Future<void> saveBaseUrl(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Save BaseUrl in shared preferences
    sharedPreferences.setString(baseUrl, value);
  }

  // Get BaseUrl
  static Future<String?> get getBaseurl async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the BaseUrl which we have stored in sharedPreferences before
    String? purchase = sharedPreferences.getString(baseUrl);
    return purchase;
  }

  // save the  product_ids
  static Future<void> saveProductIds(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Save product_ids in shared preferences
    sharedPreferences.setString(productIds, value);
  }

  // Get productIds
  static Future<String?> get getproductIds async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the product_ids which we have stored in sharedPreferences before
    String? purchase = sharedPreferences.getString(productIds);
    return purchase;
  }

  // save the user login date time
  static Future<void> saveLoginTime(String dateTime) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // storing the  date time when the user login successfully
    sharedPreferences.setString(loginDateTime, dateTime);
  }

  // get the user login Time Difference status
  static Future<bool> get isLoginTimeExpired async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // get the last login time
    String? lastLoginTime = sharedPreferences.getString(loginDateTime);
    if (lastLoginTime != null) {
      // calculating the difference of 3 days
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
    await prefs.setBool('free_plan', isFreePlan);
  }

  static Future<bool> getIsFreePlan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('free_plan')??false;
  }
}
