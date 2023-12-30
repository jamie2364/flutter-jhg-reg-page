import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    if (await InternetConnectionChecker().hasConnection) {
      return true;
    } else {
      return false;
    }
  } else if (connectivityResult == ConnectivityResult.wifi) {
    if (await InternetConnectionChecker().hasConnection) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
