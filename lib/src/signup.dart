import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'custom_button.dart';
import 'heading.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key,
    required this.onBackPress,
    required this.onEyePress,
    required this.onButtonPress,
    required this.onMenuPress,
    required this.showPassword,
    required this.nameController,
    required this.emailController,
    required this.passwordController,

  });


  final bool showPassword;
  final VoidCallback onEyePress;
  final VoidCallback onBackPress;
  final VoidCallback onMenuPress;
  final VoidCallback onButtonPress;
  final TextEditingController nameController ;
  final TextEditingController emailController  ;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final height =  MediaQuery.of(context).size.height;
    final width =  MediaQuery.of(context).size.width;
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height*0.030,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onBackPress,
              child: Icon(Icons.arrow_back_ios,color: AppColor.primaryWhite,
                size: width*0.060,
              ),
            ),
            InkWell(
              onTap: onMenuPress,
              child: Icon(Icons.more_vert,color: AppColor.primaryWhite,
                size: width*0.060,
              ),
            )
          ],),
        SizedBox(height: height*0.030,),
        const Heading(text: "Log in"),

        SizedBox(height: height*0.23,),

        //Full Name
        TextFormField(
            scrollController: ScrollController(keepScrollOffset: true),
            textAlignVertical: TextAlignVertical.center,
            autofocus: false,
            controller: nameController,
            autovalidateMode:
            emailController.text.isNotEmpty
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            style:  TextStyle(
                fontSize: 14,color: AppColor.secondaryWhite),
            obscureText: false,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50)
            ],
            decoration: InputDecoration(
              errorStyle:  TextStyle(fontSize: 12, color: AppColor.primaryRed,),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'Enter Your Name',
              hintStyle: TextStyle(
                  fontSize: 12, color:AppColor.secondaryWhite,fontWeight: FontWeight.w100),
              labelText:"FULL NAME" ,
              labelStyle: TextStyle(
                fontSize: 25, color:AppColor.secondaryWhite,),
            )),

        SizedBox(height: height*0.02,),

        //Email Address
        TextFormField(
            scrollController: ScrollController(keepScrollOffset: true),
            textAlignVertical: TextAlignVertical.center,
            autofocus: false,
            controller: emailController,
            autovalidateMode:
            emailController.text.isNotEmpty
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            style:  TextStyle(
                fontSize: 14,color: AppColor.secondaryWhite),
            obscureText: false,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50)
            ],

            decoration: InputDecoration(
              errorStyle:  TextStyle(fontSize: 12, color: AppColor.primaryRed,),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'Enter Your Email',
              hintStyle: TextStyle(
                  fontSize: 12, color:AppColor.secondaryWhite,fontWeight: FontWeight.w100),
              labelText:"EMAIL ADDRESS" ,
              labelStyle: TextStyle(
                fontSize: 25, color:AppColor.secondaryWhite,),
            )),

        SizedBox(height: height*0.02,),



        //Full Name
        TextFormField(
            scrollController: ScrollController(keepScrollOffset: true),
            textAlignVertical: TextAlignVertical.center,
            autofocus: false,
            controller: passwordController,
            autovalidateMode:
            passwordController.text.isNotEmpty
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            style:  TextStyle(
                fontSize: 14,color: AppColor.secondaryWhite),
            obscureText: showPassword,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50)
            ],
            decoration: InputDecoration(
              suffixIcon: InkWell(
                  onTap:onEyePress,
                  child: Icon(
                      showPassword == false ?
                      Icons.visibility_off_sharp:
                      Icons.visibility
                  )),
              errorStyle:  TextStyle(fontSize: 12, color: AppColor.primaryRed,),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'Enter Your Password',
              hintStyle: TextStyle(
                  fontSize: 12, color:AppColor.secondaryWhite,fontWeight: FontWeight.w100),
              labelText:"PASSWORD" ,
              labelStyle: TextStyle(
                fontSize: 25, color:AppColor.secondaryWhite,),
            )),

        SizedBox(height: height*0.07,),

        CustomButton(buttonName: "Sign Up",
            buttonColor: AppColor.primaryRed,
            textColor:AppColor.primaryWhite,
            onPressed: onButtonPress)
      ],
    );
  }
}
