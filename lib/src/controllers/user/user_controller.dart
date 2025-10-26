import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/models/country.dart';
import 'package:reg_page/src/models/user.dart';
import 'package:reg_page/src/models/user_session.dart';
import 'package:reg_page/src/repositories/repo.dart';
import 'package:reg_page/src/repositories/user_repo.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/utils/url/urls.dart';
import 'package:reg_page/src/views/screens/auth/complete_register_screen.dart';
import 'package:reg_page/src/views/screens/auth/start_register_screen.dart';

class UserController {
  final GlobalKey<FormState> starRegFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> compRegFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  final TextEditingController fNameC = TextEditingController();
  final TextEditingController lNameC = TextEditingController();
  final TextEditingController userNameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController confirmPassC = TextEditingController();
  final TextEditingController forgetEmailC = TextEditingController();

  String? selectedCountry = Contact.countries.first.name;
  bool tryAgain = false;

  final UserRepo _repo = UserRepo();

  void completeRegister() {
    if (!starRegFormKey.currentState!.validate()) return;
    Nav.to(const CompleteRegisterScreen());
  }

  Future<void> registerUser(BuildContext context) async {
    if (!compRegFormKey.currentState!.validate()) return;
    loaderDialog();
    User newUser = User(
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
      newUser = newUser.copyWith(token: res.token, userId: res.userId);
      await LocalDB.storeAppUser(
          newUser.copyWith(token: res.token, userId: res.userId));
      SplashScreen.session.user = newUser;
      Nav.offAll(getIt<SplashController>().nextPage());
    } else {
      showErrorToast(res.message ?? '');
    }
  }

  Future<void> loginUserForApp() async {
    if (!loginFormKey.currentState!.validate()) return;
    loaderDialog();
    final newUser = User(userName: userNameC.text, password: passC.text);
    final res = await _repo.loginUser(newUser.toMapToLogin());
    hideLoading();
    if (res.code == 1) {
      final user = res.data as User;
      await LocalDB.storeAppUser(user);
      SplashScreen.session.user = user;
      Nav.offAll(getIt<SplashController>().nextPage());
    } else {
      // showErrorToast(res.message ?? "");
    }
  }

  Future<void> checkUserAccount(BuildContext context) async {
    tryAgain = false;
    final userName = await LocalDB.getUserName ?? '';
    final password = await LocalDB.getPassword ?? '';
    final newUser = User(userName: userName, password: password);
    final res =
        await _repo.loginUser(newUser.toMapToLogin(), checkError: false);
    Log.d('res in controller $res');
    if (res.code is int) {
      if (res.code == 0) {
        // showErrorToast('Something went wrong');
        tryAgain = true;
        return;
      }
      final u = res.data as User;
      await LocalDB.storeAppUser(u);
      SplashScreen.session.user = u;
      tryAgain = false;
      Nav.offAll(getIt<SplashController>().nextPage());
    } else if (res.code.contains('incorrect_password')) {
      // Handle incorrect password case
      clearFields();
      Nav.off(const LoginScreen(isAppLogin: true));
    } else if (res.code.contains('invalid_username') ||
        res.code.contains('invalid_email')) {
      clearFields();
      Nav.off(const StartRegisterScreen());
    }
  }

  Future<void> marketingApi(String email) async {
    bool? isAlreadyLoggedIn = await LocalDB.getFirstTimeLogin;
    if (isAlreadyLoggedIn == null) {
      await LocalDB.storeFirstTimeLogin(true);
      await Repo().marketingApi(email, getIt<SplashController>().appName);
    }
  }

  Future<void> loginUserForPlatform() async {
    if (loginFormKey.currentState != null &&
        !loginFormKey.currentState!.validate()) {
      return;
    }
    bool showingLoader = true;
    loaderDialog();
    try {
      final newUser = User(userName: userNameC.text, password: passC.text);
      final loginRes = await UserRepo().loginUser(
        newUser.toMapToLogin(),
        checkError: true,
      );

      if (loginRes.code == 0) {
        if (!Constants.isTest) hideLoading();
        return;
      }
      SplashController splashController = getIt<SplashController>();
      final appName = splashController.appName;
      final loggedInUser = loginRes.data as User;
      SplashScreen.session = UserSession(url: Urls.base, user: loggedInUser);
      if (Constants.jhgApps.contains(appName) &&
          Urls.base.isEqual(Urls.jhgUrl)) {
        await LocalDB.storeAppUser(loggedInUser);
      }
      if (Constants.evoloApps.contains(appName) &&
          Urls.base.isEqual(Urls.evoloUrl)) {
        await LocalDB.storeAppUser(loggedInUser);
      }
      if (Constants.musictoolsApps.contains(appName) &&
          Urls.base.isEqual(Urls.musicUrl)) {
        await LocalDB.storeAppUser(loggedInUser);
      }
      //! currently hardcoced for looper
      if (appName == 'Looper') {
        await LocalDB.storeAppUser(loggedInUser);
      }
      await LocalDB.storeBearerToken(loggedInUser.token!);
      final subRes =
          await Repo().checkSubscription(splashController.productIds);
      if (!Constants.isTest) hideLoading();
      showingLoader = false;
      if (subRes == null) return;
      bool isActive = Utils.isSubscriptionActive(subRes,
          isCourseHubApp: appName == "Course Hub");
      Log.d('isSubscriptionActive $isActive');
      if (isActive) {
        LocalDB.storeUserEmail(loggedInUser.email!);
        LocalDB.storeUserName(loggedInUser.userName);
        LocalDB.storePassword(passC.text);
        LocalDB.storeUserId(loggedInUser.userId!);
        LocalDB.storeSubscriptionPurchase(false);
        LocalDB.saveBaseUrl(Urls.base.url);
        LocalDB.saveProductIds(splashController.productIds);
        LocalDB.saveLoginTime(DateTime.now().toIso8601String());
        Log.d(Constants.musictoolsApps.contains(appName));
        if (!Constants.isTest) hideLoading();
        Utils.handleNextScreenOnSuccess(appName);
        await LocalDB.storeSubscriptionPurchase(true);
        marketingApi(loggedInUser.email ?? '');
      } else {
        await LocalDB.clearLocalDB(isStringsDownloaded: false);
        showErrorToast(Constants.noSubscriptionMessage);
      }
    } catch (e) {
      if (showingLoader) hideLoading();
      showErrorToast('Something Went Wdrong');
    }
  }

  Future<void> sendPasswordResetEmail() async {
    if (!forgetPasswordFormKey.currentState!.validate()) return;
    loaderDialog();
    final res = await _repo.lostPassword(forgetEmailC.text);
    hideLoading();
    if (res != null && res.code == 1) {
      showToast(message: res.message ?? Constants.passwordRecoveryEmailSent);
      forgetEmailC.clear();
      Nav.back();
    } else {
      // Error toast is handled by the repo/base service
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