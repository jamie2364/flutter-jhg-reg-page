import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/loader_dialog.dart';
import 'package:reg_page/src/login_model.dart';
import 'package:reg_page/src/repo.dart';
import 'package:reg_page/src/show_toast.dart';
import 'colors.dart';
import 'connection_checker.dart';
import 'custom_button.dart';
import 'heading.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
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


  ApiRepo repo = ApiRepo();
  LoginModel loginModel = LoginModel();

  @override
  Widget build(BuildContext context) {
    final height =  MediaQuery.of(context).size.height;
    final width =  MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: AppColor.primaryBlack,
      body:
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.07, vertical: height * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height*0.030,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){},
                    child: Icon(Icons.arrow_back_ios,color: AppColor.primaryWhite,
                      size: width*0.060,
                    ),
                  ),
                  InkWell(
                    onTap: (){},
                    child: Icon(Icons.more_vert,color: AppColor.primaryWhite,
                      size: width*0.060,
                    ),
                  )
                ],),
              SizedBox(height: height*0.030,),
              const  Heading(text: Constant.login),

              SizedBox(height: height*0.23,),


              SizedBox(height: height*0.02,),

              //USER NAME
              TextFormField(
                  scrollController: ScrollController(keepScrollOffset: true),
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: false,
                  controller: userNameController,
                  autovalidateMode: userNameController.text.isNotEmpty
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
                    hintText: Constant.userNameHint,
                    hintStyle: TextStyle(
                        fontSize: 12, color:AppColor.secondaryWhite,fontWeight: FontWeight.w100),
                    labelText: Constant.userNameLabel ,
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
                  autovalidateMode: passwordController.text.isNotEmpty
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
                        onTap:(){
                          onEyeTap();
                        },
                        child: Icon(
                            showPassword == false ?
                            Icons.visibility_off_sharp:
                            Icons.visibility
                        )),
                    errorStyle:  TextStyle(fontSize: 12, color: AppColor.primaryRed,),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: Constant.passwordHint,
                    hintStyle: TextStyle(
                        fontSize: 12, color:AppColor.secondaryWhite,fontWeight: FontWeight.w100),
                    labelText:Constant.passwordLabel ,
                    labelStyle: TextStyle(
                      fontSize: 25, color:AppColor.secondaryWhite,),
                  )),

              SizedBox(height: height*0.07,),

              CustomButton(buttonName: Constant.signUp,
                  buttonColor: AppColor.primaryRed,
                  textColor:AppColor.primaryWhite,
                  onPressed:()async{

                  bool? hasInternet = await checkInternet();
                  if(!hasInternet){
                    // ignore: use_build_context_synchronously
                    showToast(context: context, message: "Please check your internet", isError: true);
                    return;
                  }else{
                    // ignore: use_build_context_synchronously
                    loaderDialog(context);
                    try{
                      Response response =
                      await repo.postRequest(Constant.loginUrl,{
                        "username":userNameController.text,
                        "password":passwordController.text,
                      });
                      loginModel = LoginModel.fromJson(response.data);
                      setState(() {});
                      if(response.statusCode == 200 || response.statusCode == 201 ){
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        showToast(context: context, message: "User logged in successfully ", isError: false);

                        LocalDB.storeBearerToken(loginModel.token!);
                        LocalDB.storeLogin(true);

                      }else{
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        showToast(context: context, message:"Error ${response.statusCode} ${response.statusMessage}", isError: true);

                      }
                    }catch(e){
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      showToast(context: context, message: "Something Went Wrong ", isError: true);

                    }
                  }

              })
            ],
          ),
        ),
      ),
    );
  }
}
