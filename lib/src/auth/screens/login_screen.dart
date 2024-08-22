// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/colors.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/custom_button.dart';
import 'package:reg_page/src/heading.dart';
import 'package:reg_page/src/models/user.dart';
import 'package:reg_page/src/models/user_session.dart';
import 'package:reg_page/src/repositories/repo.dart';
import 'package:reg_page/src/repositories/user_repo.dart';
import 'package:reg_page/src/utils/urls.dart';
import 'package:reg_page/src/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.yearlySubscriptionId,
    required this.monthlySubscriptionId,
    required this.appName,
    required this.appVersion,
    required this.nextPage,
    this.productIds = '',
  });

  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
  final String appName;
  final String appVersion;

  final String productIds;
  final Widget Function() nextPage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPassword = true;

  onEyeTap() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  clearTextField() {
    setState(() {
      userNameController.clear();
      passwordController.clear();
    });
  }

  late User loggedInUser;
  // SubscriptionModel subscriptionModel = SubscriptionModel();

  Future marketingApi(String email) async {
    bool? isAlreadyLoggedIn = await LocalDB.getFirstTimeLogin;
    if (isAlreadyLoggedIn == null) {
      await LocalDB.storeFirstTimeLogin(true);
      await Repo().marketingAPi(email, widget.appName);
    } else {
      debugPrint("Already Logged In");
    }
  }

  userLogin() async {
    loaderDialog(context);

    try {
      final newUser = User(
        userName: userNameController.text,
        password: passwordController.text,
      );
      final loginRes =
          await UserRepo().loginUser(newUser.toMapToLogin(), checkError: true);
      if (loginRes.code == 0) return;
      // print('login res $loginRes ${loginRes.code}${loginRes.data}');
      loggedInUser = loginRes.data as User;
      SplashScreen.session = UserSession(url: Urls.base, user: loggedInUser);
      setState(() {});
      if (Constant.jhgApps.contains(widget.appName) &&
          Urls.base.isEqual(Urls.jhgUrl)) {
        await LocalDB.storeAppUser(loggedInUser);
      }
      if (Constant.evoloApps.contains(widget.appName) &&
          Urls.base.isEqual(Urls.evoloUrl)) {
        await LocalDB.storeAppUser(loggedInUser);
      }
      if (Constant.musictoolsApps.contains(widget.appName) &&
          Urls.base.isEqual(Urls.musicUrl)) {
        await LocalDB.storeAppUser(loggedInUser);
      }
      //! currently hardcoced for looper
      if (widget.appName == 'JHG Looper') {
        await LocalDB.storeAppUser(loggedInUser);
      }
      await LocalDB.storeBearerToken(loggedInUser.token!);
      // if (widget.appName == "JHG Course Hub") {
      final subRes = await Repo().checkSubscription(widget.productIds);
      //print("response is ${response.data}");
      bool isActive = Utils.isSubscriptionActive(subRes,
          isCourseHubApp: widget.appName == "JHG Course Hub");
      debugLog('isSubscriptionActive $isActive');
      if (isActive) {
        successFunction();
      } else {
        elseFunction();
      }
      Navigator.pop(context);
    } catch (e) {
      showToast(
          context: context, message: "Something Went Wrong ", isError: true);
    }
  }

  successFunction() async {
    await LocalDB.storeUserEmail(loggedInUser.email!);
    await LocalDB.storeUserName(loggedInUser.userName);
    await LocalDB.storePassword(passwordController.text);
    await LocalDB.storeUserId(loggedInUser.userId!);
    await LocalDB.storeSubscriptionPurchase(false);
    await LocalDB.saveBaseUrl(Urls.base.url);
    await LocalDB.saveProductIds(widget.productIds);
    await LocalDB.saveLoginTime(DateTime.now().toIso8601String());

    debugLog(Constant.musictoolsApps.contains(widget.appName));
    Utils.handleNextScreenOnSuccess(widget.appName);

    // CALLING MARKETING API
    await LocalDB.storeSubscriptionPurchase(true);

    marketingApi(loggedInUser.email ?? '');
  }

  elseFunction() async {
    await LocalDB.clearLocalDB();
    showToast(
        context: context, message: Constant.serverErrorMessage, isError: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.primaryBlack,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width < 850
              ? 0
              : width < 1100 && width >= 850
                  ? width * .25
                  : width * .30,
        ),
        height: height,
        width: width,
        color: AppColor.primaryBlack,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.07, vertical: height * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.030,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColor.primaryWhite,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.030,
                  ),
                  Heading(
                    text: Constant.login,
                    height: height,
                  ),

                  SizedBox(
                    height: height * 0.23,
                  ),

                  SizedBox(
                    height: height * 0.02,
                  ),

                  // Text(
                  //   Constant.userNameLabel,
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: AppColor.secondaryWhite,
                  //   ),
                  // ),
//USER NAME
                  TextFormField(
                    scrollController: ScrollController(keepScrollOffset: true),
                    textAlignVertical: TextAlignVertical.center,
                    autofocus: false,
                    cursorColor: AppColor.secondaryWhite,
                    controller: userNameController,
                    autovalidateMode: userNameController.text.isNotEmpty
                        ? AutovalidateMode.always
                        : AutovalidateMode.onUserInteraction,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColor.primaryWhite,
                        fontFamily: Constant.kFontFamilySS3),
                    obscureText: false,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                          fontSize: 12,
                          color: AppColor.primaryRed,
                          fontFamily: Constant.kFontFamilySS3),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.primaryRed,
                          width: 2.0, // Thickness when selected
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.secondaryWhite,
                          width: 2.0, // Thickness when not selected
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: Constant.userNameHint,
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColor.secondaryWhite,
                          fontWeight: FontWeight.w400,
                          fontFamily: Constant.kFontFamilySS3),
                      contentPadding:
                          const EdgeInsets.only(left: 16.0, bottom: 12.0),
                    ),
                  ),

                  SizedBox(
                    height: height * 0.02,
                  ),

//Password
                  TextFormField(
                      scrollController:
                          ScrollController(keepScrollOffset: true),
                      textAlignVertical: TextAlignVertical.center,
                      autofocus: false,
                      cursorColor: AppColor.secondaryWhite,
                      controller: passwordController,
                      autovalidateMode: passwordController.text.isNotEmpty
                          ? AutovalidateMode.always
                          : AutovalidateMode.onUserInteraction,
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColor.primaryWhite,
                          fontFamily: Constant.kFontFamilySS3),
                      obscureText: showPassword,
                      inputFormatters: [LengthLimitingTextInputFormatter(50)],
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            onEyeTap();
                          },
                          child: Icon(
                            showPassword == false
                                ? Icons.visibility
                                : Icons.visibility_off_sharp,
                            color: AppColor.secondaryWhite,
                          ),
                        ),
                        errorStyle: TextStyle(
                            fontSize: 12,
                            color: AppColor.primaryRed,
                            fontFamily: Constant.kFontFamilySS3),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.primaryRed,
                            width: 2.0, // Thickness when selected
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.secondaryWhite,
                            width: 2.0, // Thickness when not selected
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: Constant.passwordHint,
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColor.secondaryWhite,
                            fontWeight: FontWeight.w400,
                            fontFamily: Constant.kFontFamilySS3),
                        contentPadding: const EdgeInsets.only(left: 16.0),
                      )),

                  SizedBox(
                    height: height * 0.07,
                  ),

                  CustomButton(
                      buttonName: Constant.login,
                      buttonColor: AppColor.primaryRed,
                      textColor: AppColor.primaryWhite,
                      onPressed: () async {
                        if (userNameController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          showToast(
                              context: context,
                              message: "Please Enter User Name and Password",
                              isError: true);
                          return;
                        }
                        // String? token = await LocalDB.getBearerToken;
                        // if (token == null) {
                        await userLogin();
                        // } else {
                        //   //  await checkSubscription();
                        // }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
