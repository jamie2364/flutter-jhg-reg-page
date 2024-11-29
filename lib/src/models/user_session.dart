// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/models/user.dart';

class UserSession {
  BaseUrl url;
  User? user;
  bool isFreePlan;
  UserSession({
    required this.url,
    required this.user,
    this.isFreePlan = false,
  });

  @override
  String toString() => 'UserSession(url: $url, user: $user)';
}
