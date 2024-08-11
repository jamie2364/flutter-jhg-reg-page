import 'package:reg_page/reg_page.dart';

class UserSession {
  BaseUrl url;
  String token;
  int userId;
  String userName;
  UserSession({
    required this.url,
    required this.token,
    required this.userId,
    required this.userName,
  });
}
