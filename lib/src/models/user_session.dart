import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/models/user.dart';

class UserSession {
  BaseUrl url;
  User? user;
  UserSession({
    required this.url,
    required this.user,
  });
}
