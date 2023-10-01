import 'package:shared_preferences/shared_preferences.dart';

class LocalDB{


  static String isLoginKey = "isLogin";
  static String bearerTokenKey = "BearerToken";



  // Set user is Login
  static Future<void> storeLogin(bool value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store bearer token in shared preferences
    sharedPreferences.setBool(isLoginKey, value);
  }

  // Get user login Status
  static Future<bool?> get getLogin async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    bool? isLogin = sharedPreferences.getBool(isLoginKey);
    return isLogin;
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


  // Clear bearer token
  static Future<void> clearBearerToken() async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    await  sharedPreferences.remove(bearerTokenKey);
  }

}