import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/views/screens/auth/complete_register_screen.dart';
import 'package:reg_page/src/views/screens/auth/start_register_screen.dart';
import 'package:reg_page/src/utils/res/constant.dart';
import 'package:reg_page/src/models/country.dart';
import 'package:reg_page/src/models/user.dart';
import 'package:reg_page/src/models/user_session.dart';
import 'package:reg_page/src/repositories/repo.dart';
import 'package:reg_page/src/repositories/user_repo.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/utils/nav.dart';
import 'package:reg_page/src/utils/res/urls.dart';
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

  Future<void> loginUserForApp() async {
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
      Nav.offAll(globalNextPage());
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
        // showErrorToast('Something went wrong');
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
      Nav.off(const LoginScreen());
    } else if (res.code.contains('invalid_username')) {
      Nav.off(const StartRegisterScreen());
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
    if (!loginFormKey.currentState!.validate()) return;
    loaderDialog();
    try {
      final newUser = User(userName: userNameC.text, password: passC.text);
      final loginRes =
          await UserRepo().loginUser(newUser.toMapToLogin(), checkError: true);
      // print('login res $loginRes ${loginRes.code}${loginRes.data}');

      await Future.delayed(const Duration(seconds: 2));
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
      bool isActive = Utils.isSubscriptionActive(subRes,
          isCourseHubApp: appName == "JHG Course Hub");
      // debugLog('isSubscriptionActive $isActive');
      if (isActive) {
        LocalDB.storeUserEmail(loggedInUser.email!);
        LocalDB.storeUserName(loggedInUser.userName);
        LocalDB.storePassword(passC.text);
        LocalDB.storeUserId(loggedInUser.userId!);
        LocalDB.storeSubscriptionPurchase(false);
        LocalDB.saveBaseUrl(Urls.base.url);
        LocalDB.saveProductIds(splashController.productIds);
        LocalDB.saveLoginTime(DateTime.now().toIso8601String());
        debugLog(Constant.musictoolsApps.contains(appName));
        hideLoading();
        Utils.handleNextScreenOnSuccess(appName);
        await LocalDB.storeSubscriptionPurchase(true);
        marketingApi(loggedInUser.email ?? '');
      } else {
        await LocalDB.clearLocalDB();
        hideLoading();
        showErrorToast(Constant.serverErrorMessage);
      }
    } catch (e) {
      showErrorToast("Something Went Wrong ");
    }
  }

  Future<void> clearFields() async {
    await Future.delayed(Durations.short1);
    fNameC.clear();
    lNameC.clear();
    userNameC.clear();
    emailC.clear();
    passC.clear();
    confirmPassC.clear();
  }
}
