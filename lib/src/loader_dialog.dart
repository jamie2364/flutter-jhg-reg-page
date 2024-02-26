import 'package:flutter/material.dart';
import 'package:reg_page/src/colors.dart';


loaderDialog(BuildContext context) {
  return showDialog(

      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColor.loaderBackground.withOpacity(0.2),
          insetPadding: EdgeInsets.zero,
          surfaceTintColor: AppColor.loaderBackground,
          child: Container(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).height,
              color: AppColor.loaderBackground.withOpacity(0.7),
              child: Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryRed,
                  ))),
        );
      });
}
