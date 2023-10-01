import 'package:flutter/material.dart';
import 'package:reg_page/src/colors.dart';


loaderDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            backgroundColor:AppColor.primaryWhite,
            insetPadding: const EdgeInsets.all(110),
            clipBehavior: Clip.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child:
             SizedBox(
                  height: MediaQuery.sizeOf(context).height*0.15,
                  width: MediaQuery.sizeOf(context).height*0.15,
                  child: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryRed,
                      )
                  )),
            );
      });
}
