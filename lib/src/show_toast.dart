
import 'package:flutter/material.dart';
import 'package:reg_page/src/colors.dart';
showToast({required BuildContext context, required String message,required bool isError}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style:  TextStyle(
        color: AppColor.primaryWhite,
        fontSize: 16,
      ),
    ),
    backgroundColor: isError ? AppColor.primaryRed : AppColor.primaryGreen,
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02, vertical:  MediaQuery.of(context).size.height*0.02),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.01),
    ),

    elevation: 10,
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
  ));


}