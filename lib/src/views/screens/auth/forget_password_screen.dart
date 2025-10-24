import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/user/user_controller.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/views/widgets/heading.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({
    super.key,
  });

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
                Heading(text: Constants.resetPassword, height: height),
                SizedBox(height: height * .03),
                Text(
                  'Please enter your email address to receive a password reset link.',
                  style: JHGTextStyles.labelStyle,
                ),
                SizedBox(height: height * 0.15),
                Form(
                  key: controller.forgetPasswordFormKey,
                  child: Column(
                    children: [
                      JHGTextFormField(
                        controller: controller.forgetEmailC,
                        label: Constants.email,
                        validator: (String? val) {
                          if (val == null || !Utils.isValidEmail(val)) {
                            return Constants.enterAEmail;
                          }
                          return null;
                        },
                        inputType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.05),
                JHGPrimaryBtn(
                  label: Constants.resetPassword,
                  onPressed: () => controller.sendPasswordResetEmail(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}