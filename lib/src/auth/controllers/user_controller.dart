import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/auth/screens/complete_register_screen.dart';
import 'package:reg_page/src/auth/screens/country.dart';
import 'package:reg_page/src/auth/screens/login_screen.dart';
import 'package:reg_page/src/auth/screens/start_register_screen.dart';
import 'package:reg_page/src/models/user.dart';
import 'package:reg_page/src/repositories/user_repo.dart';

class UserController extends GetxController {
  //register User
  final GlobalKey<FormState> starRegFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> compRegFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  TextEditingController fNameC = TextEditingController();
  TextEditingController lNameC = TextEditingController();
  TextEditingController userNameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();

  String? selectedCountry = Contact.countries.first.name;

  final UserRepo _repo = UserRepo();

  void completeRegister() {
    if (!(starRegFormKey.currentState!.validate())) return;
    Get.to(() => const CompleteRegisterScreen());
  }

  Future<void> registerUser() async {
    if (!(compRegFormKey.currentState!.validate())) return;
    loaderDialog();
    final newUser = User(
      email: emailC.text,
      userName: userNameC.text,
      password: passC.text,
      fName: fNameC.text,
      lName: lNameC.text,
      country: selectedCountry,
    );
    print('new User ${newUser.toString()}');
    final res = await _repo.registerUser(newUser.toMapToRegister());
    hideLoading();
    if (res == null) return;
    if (res.code == 1) {
      print('res in controller ${res.code} ${res.token}');

      await LocalDB.storeAppUser(
          newUser.copyWith(token: res.token, userId: res.userId));
      LocalDB.getBearerToken.then((value) async {
        if (value == null) {
          LocalDB.storeBearerToken(res.token ?? '');
          LocalDB.storeUserId(res.userId ?? -1);
        }
      });
      // token = res.token ?? '';
      // userId = res.userId ?? -1;
      // Get.to(() => OnBoardingScreen());
      Navigator.pushReplacement(
          SplashScreen.staticNavKey!.currentState!.context,
          MaterialPageRoute(builder: (context) => globalNextPage()));
      // AppUtils.showSuccessToast(res.message ?? '');
    } else {
      showErrorToast(res.message ?? '');
    }
  }

  Future<void> loginUser() async {
    if (!(loginFormKey.currentState!.validate())) return;
    loaderDialog();
    final newUser = User(
      userName: userNameC.text,
      password: passC.text,
    );
    print('loggedin User ${newUser.toString()}');
    final res = await _repo.loginUser(newUser.toMapToLogin());
    hideLoading();
    print('code in controler  ${res.code}');

    if (res.code == 1) {
      final user = res.data as User;
      print('success ${user.userId}   ${user.token}');
      await LocalDB.storeAppUser(user);

      Navigator.pushReplacement(
          SplashScreen.staticNavKey!.currentState!.context,
          MaterialPageRoute(builder: (context) => globalNextPage()));
    } else {
      showErrorToast(res.message ?? "");
    }
  }

  RxBool tryAgain = false.obs;

  Future<void> checkUserAccount() async {
    tryAgain(false);
    final userName = await LocalDB.getUserName ?? '';
    final password = await LocalDB.getPassword ?? '';
    final newUser = User(
      userName: userName,
      password: password,
    );
    print('loggedin User ${newUser.toString()}');
    final res = await _repo.loginUser(newUser.toMapToLogin());
    print('code and token controler ${res.code} ${res.data?.token}');
    if (res.code is int) {
      if (res.code == 0) {
        showErrorToast('Something went wrong');
        tryAgain(true);
        return;
      }
      // await SharedPrefs.storeEvoloJwt(res.data!.token!);
      // await SharedPrefs.storeEvoloUid(res.data.userId ?? -1);

      // token = res.data!.token!;
      // userId = res.data.userId ?? -1;
      // Get.to(OnBoardingScreen());
      Navigator.pushReplacement(
          SplashScreen.staticNavKey!.currentState!.context,
          MaterialPageRoute(builder: (context) => globalNextPage()));
      return;
    }
    if (res.code.contains('incorrect_password')) {
      // AppUtils.showErrorToast(
      //     'Your Evolo password is different from the JHG password please log in evolo');
      Get.to(const LoginScreen());
      return;
    }
    if (res.code.contains('invalid_username')) {
      // AppUtils.showErrorToast(
      //     'Your account in not registered on Evolo please Register to Continue');
      Get.to(const StartRegisterScreen());
      return;
    }
  }
}
