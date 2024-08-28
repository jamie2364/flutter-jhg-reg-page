import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/user/user_controller.dart';
import 'package:reg_page/src/utils/utils.dart';
import 'package:reg_page/src/views/widgets/heading.dart';

class CompleteRegisterScreen extends StatefulWidget {
  const CompleteRegisterScreen({super.key});

  @override
  State<CompleteRegisterScreen> createState() => _CompleteRegisterScreenState();
}

class _CompleteRegisterScreenState extends State<CompleteRegisterScreen> {
  late UserController _controller;

  @override
  void initState() {
    super.initState();
    _controller = getIt<UserController>();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isMobile = MediaQuery.of(context).size.width < 600;
    _controller.clearFields();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 50,
          top: 25,
          left: kBodyHrPadding,
          right: kBodyHrPadding,
        ),
        child: JHGPrimaryBtn(
          label: 'Next',
          onPressed: () {
            _controller.registerUser(context);
          },
        ),
      ),
      body: JHGBody(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile
              ? kBodyHrPadding
              : MediaQuery.of(context).size.width * (isMobile ? 0.25 : 0.30),
        ),
        bodyAppBar: const JHGAppBar(),
        body: Form(
          key: _controller.compRegFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * .02),
              Heading(
                text: 'Step 2 - Create your account',
                height: height,
              ),
              SizedBox(height: height * .04),
              JHGTextFormField(
                label: 'User Name',
                controller: _controller.userNameC,
                spacing: const EdgeInsets.only(bottom: 20),
              ),
              JHGTextFormField(
                label: 'Email',
                validator: (String? val) {
                  if (val == null || !Utils.isValidEmail(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                inputType: TextInputType.emailAddress,
                controller: _controller.emailC,
                spacing: const EdgeInsets.only(bottom: 20),
              ),
              JHGTextFormField(
                label: 'Password',
                isPasswordField: true,
                controller: _controller.passC,
                validator: (String? val) {
                  if (val == null || val.length < 6) {
                    return 'Minimum password length must be 6';
                  }
                  return null;
                },
                spacing: const EdgeInsets.only(bottom: 20),
              ),
              JHGTextFormField(
                label: 'Confirm Password',
                isPasswordField: true,
                controller: _controller.confirmPassC,
                validator: (value) {
                  if (value != _controller.passC.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                spacing: const EdgeInsets.only(bottom: 25),
              ),
              SizedBox(height: height * .05),
            ],
          ),
        ),
      ),
    );
  }
}
