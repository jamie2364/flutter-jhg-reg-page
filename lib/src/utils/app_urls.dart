import 'package:reg_page/reg_page.dart';

class AppUrls {
  AppUrls._();
  // static String base = '';
  static BaseUrl base = BaseUrl.empty;

  static const String jhgUrl = 'https://www.Jamieharrisonguitar.com/';
  static const String evoloUrl = 'https://www.evolo.app/';
  static const String musicUrl = 'https://www.musictools.io/';

  static const String marketingUrl =
      "https://app.bentonow.com/api/v1/batch/subscribers?site_uuid=f0eba21f0b6640bbbe47fedefa843b0f";
  static const String reportBugUrl =
      "https://www.jamieharrisonguitar.com/wp-json/custom/v1/report";

  static const String downloadAssetsUrl =
      'https://www.jamieharrisonguitar.com/wp-json/jhg-apps/v1/download-audio/?app_name=';
  static const String productIds = 'wp-json/jhg-apps/v1/product-ids';
  static const String checkSub = 'wp-json/myplugin/v1/jwt-check-subscription/';
  static const String login = '${_jwtCheckRoute}token';
  static const _jwtCheckRoute = 'wp-json/jwt-auth/v1/';

  static const apiBase = '/wp-json/custom/v1/users';
  static String register = "$apiBase/register";
}
