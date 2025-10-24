library;

export 'src/services/app_exceptions.dart';
export 'src/services/strings_download_service.dart';
export 'src/utils/db/local_db.dart';
export 'src/utils/dialogs/loader_dialog.dart';
export 'src/utils/navigate/nav.dart';
export 'src/utils/res/enums.dart';
export 'src/utils/res/logs.dart';
export 'src/utils/toast/show_toast.dart';
export 'src/utils/utils.dart';
export 'src/views/screens/auth/forget_password_screen.dart';
export 'src/views/screens/auth/login_screen.dart';
export 'src/views/screens/report_bug/bug_report_screen.dart';
export 'src/views/screens/splash/splash_screen.dart';
export 'src/views/screens/welcome/welcome_screen.dart';
import 'package:reg_page/src/utils/url/urls.dart';

enum BaseUrl {
  empty(''),
  musictools(Urls.musicUrl),
  jhg(Urls.jhgUrl),
  evolo(Urls.evoloUrl);

  final String url;
  const BaseUrl(this.url);

  @override
  String toString() => url;

  static BaseUrl fromString(String url) => BaseUrl.values
      .firstWhere((e) => e.url == url, orElse: () => BaseUrl.empty);

  bool isEqual(String other) => url == other;
}