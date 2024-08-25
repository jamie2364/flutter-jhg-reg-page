import 'package:flutter/material.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constant.dart';
import 'package:reg_page/src/utils/nav.dart';

showToast(
    {required BuildContext context,
    required String message,
    required bool isError}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width < 850
          ? 24
          : MediaQuery.of(context).size.width < 1100 &&
                  MediaQuery.of(context).size.width >= 850
              ? MediaQuery.sizeOf(context).width * .25
              : MediaQuery.sizeOf(context).width * .30,
    ),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: AppColor.primaryWhite,
          fontSize: 16,
          fontFamily: Constant.kFontFamilySS3),
    ),
    backgroundColor: isError ? AppColor.primaryRed : AppColor.primaryGreen,
    padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.02,
        vertical: MediaQuery.of(context).size.height * 0.02),
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(MediaQuery.of(context).size.height * 0.01),
    ),
    elevation: 10,
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
  ));
}

showErrorToast(String message) => showToast(
    context: Nav.key.currentState!.context, message: message, isError: true);
