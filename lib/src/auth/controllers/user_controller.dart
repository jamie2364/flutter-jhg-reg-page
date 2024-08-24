import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/auth/screens/complete_register_screen.dart';
import 'package:reg_page/src/auth/screens/start_register_screen.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/models/country.dart';
import 'package:reg_page/src/models/user.dart';
import 'package:reg_page/src/models/user_session.dart';
import 'package:reg_page/src/repositories/repo.dart';
import 'package:reg_page/src/repositories/user_repo.dart';
import 'package:reg_page/src/splash/controllers/splash_controller.dart';
import 'package:reg_page/src/utils/nav.dart';
import 'package:reg_page/src/utils/urls.dart';
import 'package:reg_page/src/utils/utils.dart';

class UserController {
  final GlobalKey<FormState> starRegFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> compRegFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  final TextEditingController fNameC = TextEditingController();
  final TextEditingController lNameC = TextEditingController();
  final TextEditingController userNameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController confirmPassC = TextEditingController();

  String? selectedCountry = Contact.countries.first.name;
  bool tryAgain = false;

  final UserRepo _repo = UserRepo();

  void completeRegister(BuildContext context) {
    if (!starRegFormKey.currentState!.validate()) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CompleteRegisterScreen()),
    );
  }

  Future<void> registerUser(BuildContext context) async {
    if (!compRegFormKey.currentState!.validate()) return;
    loaderDialog();
    final newUser = User(
      email: emailC.text,
      userName: userNameC.text,
      password: passC.text,
      fName: fNameC.text,
      lName: lNameC.text,
      country: selectedCountry,
    );
    final res = await _repo.registerUser(newUser.toMapToRegister());
    hideLoading();
    if (res == null) return;
    if (res.code == 1) {
      await LocalDB.storeAppUser(
          newUser.copyWith(token: res.token, userId: res.userId));
      SplashScreen.session.user = newUser;
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => globalNextPage()),
        (route) => false,
      );
    } else {
      showErrorToast(res.message ?? '');
    }
  }

  Future<void> loginUser(BuildContext context) async {
    if (!loginFormKey.currentState!.validate()) return;
    loaderDialog();
    final newUser = User(
      userName: userNameC.text,
      password: passC.text,
    );
    final res = await _repo.loginUser(newUser.toMapToLogin());
    hideLoading();

    if (res.code == 1) {
      final user = res.data as User;
      await LocalDB.storeAppUser(user);
      SplashScreen.session.user = user;
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => globalNextPage()),
        (route) => false,
      );
    } else {
      showErrorToast(res.message ?? "");
    }
  }

  Future<void> checkUserAccount(BuildContext context) async {
    tryAgain = false;
    final userName = await LocalDB.getUserName ?? '';
    final password = await LocalDB.getPassword ?? '';
    final newUser = User(
      userName: userName,
      password: password,
    );
    final res =
        await _repo.loginUser(newUser.toMapToLogin(), checkError: false);
    print('res in controller $res');
    if (res.code is int) {
      if (res.code == 0) {
        showErrorToast('Something went wrong');
        tryAgain = true;
        return;
      }
      final u = res.data as User;
      await LocalDB.storeAppUser(u);
      SplashScreen.session.user = u;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => globalNextPage()),
        (route) => false,
      );
    } else if (res.code.contains('incorrect_password')) {
      // Handle incorrect password case
    } else if (res.code.contains('invalid_username')) {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const StartRegisterScreen()),
      );
    }
  }

  Future marketingApi(String email) async {
    bool? isAlreadyLoggedIn = await LocalDB.getFirstTimeLogin;
    if (isAlreadyLoggedIn == null) {
      await LocalDB.storeFirstTimeLogin(true);
      await Repo().marketingAPi(email, getIt<SplashController>().appName);
    } else {
      debugPrint("Already Logged In");
    }
  }

  userLogin() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }
    loaderDialog();
    try {
      final newUser = User(userName: userNameC.text, password: passC.text);
      final loginRes =
          await UserRepo().loginUser(newUser.toMapToLogin(), checkError: true);
      // print('login res $loginRes ${loginRes.code}${loginRes.data}');
      if (loginRes.code == 0) return;
      SplashController splashController = getIt<SplashController>();
      final appName = splashController.appName;
      final loggedInUser = loginRes.data as User;
      SplashScreen.session = UserSession(url: Urls.base, user: loggedInUser);
      if (Constant.jhgApps.contains(appName) &&
          Urls.base.isEqual(Urls.jhgUrl)) {
        await LocalDB.storeAppUser(loggedInUser);
      }
      if (Constant.evoloApps.contains(appName) &&
          Urls.base.isEqual(Urls.evoloUrl)) {
        await LocalDB.storeAppUser(loggedInUser);
      }
      if (Constant.musictoolsApps.contains(appName) &&
          Urls.base.isEqual(Urls.musicUrl)) {
        await LocalDB.storeAppUser(loggedInUser);
      }
      //! currently hardcoced for looper
      if (appName == 'JHG Looper') {
        await LocalDB.storeAppUser(loggedInUser);
      }
      await LocalDB.storeBearerToken(loggedInUser.token!);
      // if (appName == "JHG Course Hub") {
      final subRes =
          await Repo().checkSubscription(splashController.productIds);
      //print("response is ${response.data}");
      bool isActive = Utils.isSubscriptionActive(subRes,
          isCourseHubApp: appName == "JHG Course Hub");
      debugLog('isSubscriptionActive $isActive');
      if (isActive) {
        await LocalDB.storeUserEmail(loggedInUser.email!);
        await LocalDB.storeUserName(loggedInUser.userName);

        await LocalDB.storeUserId(loggedInUser.userId!);
        await LocalDB.storeSubscriptionPurchase(false);
        await LocalDB.saveBaseUrl(Urls.base.url);
        await LocalDB.saveProductIds(splashController.productIds);
        await LocalDB.saveLoginTime(DateTime.now().toIso8601String());

        debugLog(Constant.musictoolsApps.contains(appName));
        Utils.handleNextScreenOnSuccess(appName);

        await LocalDB.storeSubscriptionPurchase(true);

        marketingApi(loggedInUser.email ?? '');
      } else {
        await LocalDB.clearLocalDB();
        showErrorToast(Constant.serverErrorMessage);
      }
      Nav.back();
    } catch (e) {
      showErrorToast("Something Went Wrong ");
    }
  }
}
