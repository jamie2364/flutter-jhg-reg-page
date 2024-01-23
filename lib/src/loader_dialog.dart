import 'package:flutter/material.dart';
import 'package:reg_page/src/colors.dart';


loaderDialog(BuildContext context) {
  return showDialog(

      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            backgroundColor:AppColor.loaderBackground,
            insetPadding: EdgeInsets.zero,
            child:
             Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).height,
                  color: AppColor.loaderBackground,
                  child: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryRed,
                      )
                  )),
            );
      });
}
