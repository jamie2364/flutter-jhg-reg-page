// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/auth/controllers/user_controller.dart';
import 'package:reg_page/src/colors.dart';
import 'package:reg_page/src/constant.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final controller = getIt<UserController>();
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.07, vertical: height * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const JHGAppBar(
                  title: Text(Constant.login),
                ),
                // Heading(
                //   text: Constant.login,
                //   height: height,
                // ),
                SizedBox(
                  height: height * 0.32,
                ),
                Form(
                  key: controller.loginFormKey,
                  child: Column(
                    children: [
                      JHGTextFormField(
                        controller: controller.userNameC,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        label: Constant.userNameHint,
                      ),
                      SizedBox(height: height * 0.02),
                      JHGTextFormField(
                        controller: controller.passC,
                        isPasswordField: true,
                        label: Constant.passwordHint,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                JHGPrimaryBtn(
                  label: Constant.login,
                  onPressed: () => controller.userLogin(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
