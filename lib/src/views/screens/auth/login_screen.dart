// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/user/user_controller.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/views/widgets/heading.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    this.isAppLogin = false,
  });
  final bool isAppLogin;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final controller = getIt<UserController>();

    // controller.clearFields();
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
                SizedBox(height: height * 0.030),
                const JHGAppBar(),
                SizedBox(height: height * 0.1),
                Heading(text: Constants.login, height: height),
                SizedBox(height: height * 0.18),
                Form(
                  key: controller.loginFormKey,
                  child: Column(
                    children: [
                      JHGTextFormField(
                        controller: controller.userNameC,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        label: Constants.userNameHint,
                      ),
                      SizedBox(height: height * 0.02),
                      JHGTextFormField(
                        controller: controller.passC,
                        isPasswordField: true,
                        label: Constants.passwordHint,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.05),
                JHGPrimaryBtn(
                    label: Constants.login,
                    onPressed: () async {
                      isAppLogin
                          ? await controller.loginUserForApp()
                          : await controller.userLogin();
                      controller.clearFields();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
