
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reg_page/src/colors.dart';
import 'package:reg_page/src/constant.dart';

restorePopupDialog(
    BuildContext context,
    String title,
    String description
    ){
  return showDialog(context: (context), builder: (context){
     final height = MediaQuery.of(context).size.height;
     final width = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: Colors.transparent,
        alignment: Alignment.center,
        child:   Align(
          alignment: Alignment.center,
          child: Container(
              height: height*0.5,
              width: width,
              decoration: BoxDecoration(
                color:  AppColor.greyPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color:AppColor.greyPrimary,
                borderRadius: BorderRadius.circular(20),
                child:
                Padding(
                  padding:  EdgeInsets.symmetric(
                      horizontal: width*0.065,
                      vertical: height*0.025
                      ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Align(
                        alignment: Alignment.topRight,
                         child: GestureDetector(
                           onTap: (){Navigator.pop(context);},
                          child: Container(
                            // color: Colors.red,
                            height: height*0.020,
                            width:  height*0.020,
                            child: Image.asset(
                              "assets/images/icon_cross.png",
                              package: 'reg_page',
                              fit: BoxFit.cover,
                            ),
                          )
                        ),
                      ),

                      SizedBox(
                        height: height*0.080,
                      ),

                      Text(
                        title,
                        style: TextStyle(
                          color: AppColor.primaryWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(
                        height: height*0.050,
                      ),

                      Text(
                        description ,
                        style: TextStyle(
                          color: AppColor.greySecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      Spacer(),


                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Container(
                            height: height * 0.065,
                            width: width * 06,
                            margin: EdgeInsets.symmetric(horizontal: width*0.055),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppColor.primaryRed,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              Constant.close,
                              style: TextStyle(
                                color: AppColor.primaryWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: height*0.020,
                      ),

                    ],
                  ),
                ),
              )
          ),
        ),
    );
  });
}