import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/user/user_controller.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/views/widgets/heading.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    this.isAppLogin = false,
  });

  ///
  ///[isAppLogin] identifies the second time user login for the spcific platform/baseURL of that app.
  ///e.g. evolo for practice routines
  ///
  ///
  final bool isAppLogin;
  @override
  Widget build(BuildContext context) {
    final height = Utils.height(context);
    final width = Utils.width(context);
    final controller = getIt<UserController>();
    return Scaffold(
      backgroundColor: JHGColors.primaryBlack,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Utils.screenHrPadding(context),
          ),
          height: height,
          width: width,
          color: JHGColors.primaryBlack,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const JHGAppBar(),
                SizedBox(height: height * 0.1),
                Heading(text: Constants.login, height: height),
                SizedBox(height: height * .03),
                isAppLogin
                    ? Text(
                        Constants.loginAppDesc(Utils.urlInText),
                        style:
                            JHGTextStyles.subLabelStyle.copyWith(fontSize: 14),
                      )
                    : Text(
                        Constants.loginDesc(Utils.urlInText),
                        style: JHGTextStyles.labelStyle,
                      ),
                SizedBox(height: isAppLogin ? height * .05 : height * 0.15),
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
                        onSubmitted: (val) => onLogin(controller),
                      ),
                      SizedBox(height: height * 0.02),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Nav.to(const ForgetPasswordScreen());
                          },
                          child: Text(
                            Constants.forgetPassword,
                            style: TextStyle(
                              color: JHGColors.primary,
                              fontFamily: Constants.kFontFamilySS3,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.05),
                JHGPrimaryBtn(
                    label: Constants.login,
                    onPressed: () => onLogin(controller))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onLogin(UserController controller) async {
    isAppLogin
        ? await controller.loginUserForApp()
        : await controller.loginUserForPlatform();
  }
}