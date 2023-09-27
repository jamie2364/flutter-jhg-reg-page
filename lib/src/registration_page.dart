import 'package:flutter/material.dart';
import 'package:reg_page/src/setting.dart';
import 'package:reg_page/src/signup.dart';
import 'package:reg_page/src/welcome.dart';
import 'colors.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int currentPage = 1;
  void changePage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  int selectedPlan = 1;
  onPlanSelect(int plan) {
    setState(() {
      selectedPlan = plan;
    });
  }

  int checkedEmail = 1;
  onEmailChecked(int plan) {
    setState(() {
      checkedEmail = plan;
    });
  }


  onBackPress(int page) {
    setState(() {

    });
  }

  onMenuPress() {
    setState(() {

    });
  }

  bool showPassword = true;
  onEyeTap() {
    setState(() {
      showPassword = !showPassword;
    });
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
        backgroundColor: AppColor.primaryBlack,
        body: SizedBox(height: height,
          width: width,
          child: SingleChildScrollView(child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.07, vertical: height * 0.04), child:

          currentPage == 1 ?

          Welcome(

              selectedPlan: selectedPlan,

              onButtonPress: () {changePage(2);},

              onPlanSelected: () {
                if (selectedPlan == 1) {
                  onPlanSelect(2);
                } else {
                  onPlanSelect(1);
                }
              })

              : currentPage == 2 ?


          SignIn(

              onBackPress: () {
                changePage(1);
              },
              onButtonPress: () {
                changePage(3);
              },
              onEyePress: () {onEyeTap();},
              onMenuPress: () {},
              showPassword: showPassword,
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController)

              :

          Setting(
              onBackPress: () {
                changePage(2);
              },
              onCheckedPress: () {
                if (checkedEmail == 1) {
                  onEmailChecked(2);
                } else {
                  onEmailChecked(1);
                }
              },
              onButtonPress: () {
                changePage(1);
              },
              onMenuPress: () {},
              checkedEmail: checkedEmail)
          ),),));
  }
}