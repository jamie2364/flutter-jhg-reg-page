import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:get/get.dart';
import 'package:reg_page/src/auth/controllers/user_controller.dart';

class CompleteRegisterScreen extends GetView<UserController> {
  const CompleteRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          bottom: 50,
          top: 25,
          left: kBodyHrPadding,
          right: kBodyHrPadding,
        ),
        child: JHGPrimaryBtn(
          label: 'Next',
          onPressed: () => controller.registerUser(),
        ),
      ),
      body: JHGBody(
        padding: EdgeInsets.symmetric(
          horizontal: JHGResponsive.isMobile(context)
              ? 0
              : JHGResponsive.isTablet(context)
              ? MediaQuery.sizeOf(context).width * .25
              : MediaQuery.sizeOf(context).width * .30,
        ),
        bodyAppBar: const JHGAppBar(),
        body: Form(
          key: controller.compRegFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * .02),
              Text(
                'Step 2 - Create your account',
                textAlign: TextAlign.center,
                style: JHGTextStyles.lrlabelStyle.copyWith(fontSize: 29),
              ),
              SizedBox(height: height * .04),
              // Text(
              //   'Your journey begins here – complete your profile to get started.',
              //   style: JHGTextStyles.subLabelStyle.copyWith(fontSize: 14),
              // ),
              // SizedBox(height: height * .05),
              // const Spacer(),
              JHGTextFormField(
                label: 'User Name',
                controller: controller.userNameC,
                spacing: const EdgeInsets.only(bottom: 20),
              ),
              JHGTextFormField(
                label: 'Email',
                validator: (String? val) {
                  if (!(val!.isEmail)) return 'Please enter a valid email';
                  return null;
                },
                inputType: TextInputType.emailAddress,
                controller: controller.emailC,
                spacing: const EdgeInsets.only(bottom: 20),
              ),
              JHGTextFormField(
                label: 'Password',
                isPasswordField: true,
                controller: controller.passC,
                validator: (String? val) {
                  if (val!.length < 6) {
                    return 'Minimum password length must be 6';
                  }
                  return null;
                },
                spacing: const EdgeInsets.only(bottom: 20),
              ),
              JHGTextFormField(
                label: 'Confirm Password',
                isPasswordField: true,
                controller: controller.confirmPassC,
                validator: (value) {
                  if (controller.passC.text == '') return null;
                  if (value != controller.passC.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                spacing: const EdgeInsets.only(bottom: 20 + 5),
              ),
              // const Spacer(),

              SizedBox(height: height * .05),

              // SizedBox(height: height * .2),
            ],
          ),
        ),
      ),
    );
  }
}
