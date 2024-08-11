import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/repositories/repo.dart';
import 'package:reg_page/src/subscription_model.dart';
import 'package:reg_page/src/utils/app_urls.dart';

import 'colors.dart';
import 'custom_button.dart';
import 'heading.dart';

class SignUp extends StatefulWidget {
  const SignUp({
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
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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

  LoginModel loginModel = LoginModel();
  SubscriptionModel subscriptionModel = SubscriptionModel();

  Future marketingApi(String email) async {
    bool? isAlreadyLoggedIn = await LocalDB.getFirstTimeLogin;

    if (isAlreadyLoggedIn == null) {
      await LocalDB.storeFirstTimeLogin(true);
      bool? hasInternet = await checkInternet();
      if (!hasInternet) {
        return;
      } else {
        await Repo().marketingAPi(email, widget.appName);
      }
    } else {
      debugPrint("Already Logged In");
    }
  }

  userLogin() async {
    bool? hasInternet = await checkInternet();
    if (!hasInternet) {
      // ignore: use_build_context_synchronously
      showToast(
          context: context,
          message: "Please check your internet",
          isError: true);
      return;
    } else {
      // ignore: use_build_context_synchronously
      loaderDialog(context);

      try {
        // final res = await BaseService().post(AppUrls.login, {
        //   "username": userNameController.text,
        //   "password": passwordController.text,
        // }).catchError(handleError);
        // loginModel = LoginModel.fromJson(res);
        final response = await Repo()
            .login(userNameController.text, passwordController.text);
        if (response != null) {
          loginModel = response;
          setState(() {});

          // ignore: use_build_context_synchronously
          await LocalDB.storeBearerToken(loginModel.token!);
          // if (widget.appName == "JHG Course Hub") {
          final res = await Repo().checkSubscription(widget.productIds);
          //print("response is ${response.data}");
          bool isActive = await isSubscriptionActive(res,
              isCourseHubApp: widget.appName == "JHG Course Hub");
          if (isActive) {
            successFunction();
          } else {
            elseFunction();
          }

          //   // CALLING MARKETING API
          //   await LocalDB.storeSubscriptionPurchase(true);
          //   // ignore: use_build_context_synchronously

          //   await marketingApi(loginModel.userEmail ?? '');
          // }

          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously

          // ignore: use_build_context_synchronously
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        // Navigator.pop(context);
        // ignore: use_build_context_synchronously
        showToast(
            context: context, message: "Something Went Wrong ", isError: true);
      }
    }
  }

  Future<bool> isSubscriptionActive(Map<String, dynamic>? json,
      {bool isCourseHubApp = false}) async {
    if (json == null) return false;
    for (var entry in json.entries) {
      if ((isCourseHubApp) &&
          (entry.key == 'course_hub') &&
          (entry.value == "active")) {
        return true;
      } else if (entry.value == "active") {
        return true;
      }
    }

    return false;
  }

  successFunction() async {
    await LocalDB.storeUserEmail(loginModel.userEmail!);
    await LocalDB.storeUserName(loginModel.userLogin!);
    await LocalDB.storePassword(passwordController.text);
    await LocalDB.storeUserId(loginModel.userId!);
    await LocalDB.storeSubscriptionPurchase(false);
    await LocalDB.saveBaseUrl(AppUrls.baseUrl);
    await LocalDB.saveProductIds(widget.productIds);
    await LocalDB.saveLoginTime(DateTime.now().toIso8601String());
    // ignore: use_build_context_synchronously
    SplashScreen.session = UserSession(
        url: AppUrls.baseUrl.contains('evolo')
            ? 'evolo'
            : AppUrls.baseUrl.contains('musictools')
                ? 'mt'
                : 'jhg',
        token: loginModel.token ?? '',
        userId: loginModel.userId ?? -1,
        userName: loginModel.userNicename ?? '');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return widget.nextPage();
    }), (route) => false);

    // CALLING MARKETING API
    await LocalDB.storeSubscriptionPurchase(true);
    // ignore: use_build_context_synchronously

    await marketingApi(loginModel.userEmail ?? '');
  }

  elseFunction() async {
    await LocalDB.clearLocalDB();
    // ignore: use_build_context_synchronously
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
                   Heading(text: Constant.login,height: height,),

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
                        String? token = await LocalDB.getBearerToken;
                        if (token == null) {
                          await userLogin();
                        } else {
                          //  await checkSubscription();
                        }
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
