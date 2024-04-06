import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/subscription_model.dart';

import 'colors.dart';
import 'custom_button.dart';
import 'heading.dart';

class SignUp extends StatefulWidget {
  const SignUp(
      {super.key,
      required this.yearlySubscriptionId,
      required this.monthlySubscriptionId,
      required this.appName,
      required this.appVersion,
      required this.nextPage,
      required this.loginUrl,
      this.platform = '',
      this.productIds = '',
      required this.subscriptionUrl});

  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
  final String appName;
  final String appVersion;
  final String loginUrl;
  final String platform;
  final String productIds;
  final String subscriptionUrl;
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

  ApiRepo repo = ApiRepo();
  LoginModel loginModel = LoginModel();
  SubscriptionModel subscriptionModel = SubscriptionModel();

  // checkSubscription() async {
  //   bool? hasInternet = await checkInternet();
  //   if (!hasInternet) {
  //     // ignore: use_build_context_synchronously
  //     showToast(
  //         context: context,
  //         message: "Please check your internet",
  //         isError: true);
  //     return;
  //   } else {
  //     try {
  //       // ignore: use_build_context_synchronously
  //       loaderDialog(context);
  //       // if (widget.appName == "JHG Course Hub") {
  //       Response response = await repo.getRequest(Constant.subscriptionUrl, {});
  //       print("response is ${response.data}");
  //       subscriptionModel = SubscriptionModel.fromJson(response.data);
  //       setState(() {});
  //       if (subscriptionModel.allAccessPass == "active" ||
  //           subscriptionModel.softwareSuite == "active") {
  //         // ignore: use_build_context_synchronously
  //         await LocalDB.storeSubscriptionPurchase(true);
  //         // ignore: use_build_context_synchronously
  //         Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => widget.nextPage()));
  //       } else {
  //         // ignore: use_build_context_synchronously
  //         Navigator.pop(context);

  //         if (response.statusCode == 500) {
  //           // ignore: use_build_context_synchronously
  //           showToast(
  //               context: context,
  //               message: Constant.serverErrorMessage,
  //               isError: true);
  //         } else {
  //           // ignore: use_build_context_synchronously
  //           showToast(
  //               context: context,
  //               message:
  //                   "Error ${response.statusCode} ${response.statusMessage}",
  //               isError: true);
  //         }
  //         print("USER IS NOT LOGGED IN");
  //         // ignore: use_build_context_synchronously
  //         // Navigator.pushReplacement(
  //         //     context,
  //         //     MaterialPageRoute(
  //         //         builder: (context) => Welcome(
  //         //               yearlySubscriptionId: widget.yearlySubscriptionId,
  //         //               monthlySubscriptionId: widget.monthlySubscriptionId,
  //         //               appName: widget.appName,
  //         //               appVersion: widget.appVersion,
  //         //               nextPage: () => widget.nextPage(),
  //         //             )));
  //       }
  //       // } else {
  //       //   // ignore: use_build_context_synchronously
  //       //   Navigator.pushReplacement(context,
  //       //       MaterialPageRoute(builder: (context) => widget.nextPage()));
  //       // }
  //     } catch (e) {
  //       // ignore: use_build_context_synchronously
  //       Navigator.pop(context);
  //       // ignore: use_build_context_synchronously
  //       showToast(
  //           context: context, message: "Something Went Wrong ", isError: true);
  //     }
  //   }
  // }

  Future marketingApi(String email) async {
    bool? isAlreadyLoggedIn = await LocalDB.getFirstTimeLogin;

    if (isAlreadyLoggedIn == null) {
      await LocalDB.storeFirstTimeLogin(true);
      bool? hasInternet = await checkInternet();
      if (!hasInternet) {
        return;
      } else {
        Response response = await repo.postRequest(
            Constant.marketingUrl,
            {
              "subscribers": [
                {"email": email, "tag_as_event": "${widget.appName} User"}
              ]
            },
            isHeader: true);
        print("${response.data}");
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
        Response response = await repo.postRequest(widget.loginUrl, {
          "username": userNameController.text,
          "password": passwordController.text,
        });
        loginModel = LoginModel.fromJson(response.data);
        setState(() {});
        if (response.statusCode == 200 || response.statusCode == 201) {
          // ignore: use_build_context_synchronously
          await LocalDB.storeBearerToken(loginModel.token!);
          // if (widget.appName == "JHG Course Hub") {
          Response response = await repo.getRequest(widget.subscriptionUrl, {
            "product_ids": widget.productIds,
            "platform": widget.platform,
            "app_name": widget.appName
          });
          //print("response is ${response.data}");
          bool isActive = isSubscriptionActive(response.data,
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
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          if (response.statusCode == 403) {
            // ignore: use_build_context_synchronously
            showToast(
                context: context,
                message: Constant.emailPasswordInCorrect,
                isError: true);
          } else if (response.statusCode == 500) {
            // ignore: use_build_context_synchronously
            showToast(
                context: context,
                message: Constant.serverErrorMessage,
                isError: true);
          } else {
            // ignore: use_build_context_synchronously
            showToast(
                context: context,
                message:
                    "Error ${response.statusCode} ${response.statusMessage}",
                isError: true);
          }
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

  bool isSubscriptionActive(Map<String, dynamic>? json,
      {bool isCourseHubApp = false}) {
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
    await LocalDB.saveBaseUrl(widget.platform);
    await LocalDB.saveProductIds(widget.productIds);
    await LocalDB.saveLoginTime(DateTime.now().toIso8601String());
    // ignore: use_build_context_synchronously
    SplashScreen.session = UserSession(
        urlPos: widget.loginUrl.contains('evolo') ? 1 : 2,
        token: loginModel.token ?? '');
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
                          size: width * 0.060,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.030,
                  ),
                  const Heading(text: Constant.login),

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
                    style:
                        TextStyle(fontSize: 14, color: AppColor.primaryWhite),
                    obscureText: false,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontSize: 12,
                        color: AppColor.primaryRed,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red.shade500,
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
                      ),
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
                      style:
                          TextStyle(fontSize: 14, color: AppColor.primaryWhite),
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
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red.shade500,
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
                        ),
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
