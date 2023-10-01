import 'package:flutter/material.dart';
import 'constant.dart';
import 'colors.dart';
import 'custom_button.dart';
import 'heading.dart';

class Setting extends StatefulWidget {
  const Setting({super.key,});
  @override
  State<Setting> createState() => _SettingState();
}


class _SettingState extends State<Setting> {

  int checkedEmail = 1;
  onEmailChecked(int plan) {
    setState(() {
      checkedEmail = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height =  MediaQuery.of(context).size.height;
    final width =  MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: AppColor.primaryBlack,
      body: Padding(
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
               const Heading(text: Constant.setting),
            SizedBox(height: height*0.07,),
            Center(
                child:
                Container(
                  height:height * 0.12,
                  width:  width * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade900),
                  child:  Padding(
                      padding:  EdgeInsets.symmetric(horizontal:width*0.040,),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Constant.social,
                            style:  TextStyle(
                                color: AppColor.secondaryWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Text(
                            Constant.media,
                            style:  TextStyle(
                                color: AppColor.secondaryWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Constant.link,
                                style:  TextStyle(
                                    color: AppColor.secondaryWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                ),
                              ),

                              Padding(
                                padding:  EdgeInsets.only(right: width*0.032),
                                child: Icon(Icons.arrow_forward_ios,color: AppColor.primaryWhite,
                                  size: width*0.040,
                                ),
                              ),
                            ],
                          )

                        ],
                      )
                  ),
                )

            ),


            SizedBox(height: height*0.03,),

            Center(
                child:
                Container(
                  height:height * 0.23,
                  width:  width * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade900),
                  child:  Padding(
                      padding:  EdgeInsets.symmetric(horizontal:width*0.040),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Constant.emailAnd,
                            style:  TextStyle(
                                color: AppColor.secondaryWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Text(
                            Constant.messages,
                            style:  TextStyle(
                                color: AppColor.secondaryWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Constant.emailDescription,
                                style:  TextStyle(
                                    color: AppColor.secondaryWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              IconButton(onPressed: (){
                                onEmailChecked(1);
                              }, icon:
                              Icon(checkedEmail == 1 ?  Icons.check_box :
                                Icons.check_box_outline_blank_rounded,
                                color: checkedEmail == 1 ? AppColor.primaryGreen : AppColor.primaryWhite,
                                size: width*0.060,
                              ),)
                            ],
                          ),
                          Divider(color: AppColor.primaryBlack,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Constant.messagesDescription,
                                style:  TextStyle(
                                    color: AppColor.secondaryWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              IconButton(onPressed: (){
                                onEmailChecked(2);
                              }, icon:
                              Icon(checkedEmail == 2 ?  Icons.check_box :
                                Icons.check_box_outline_blank_rounded,
                                color: checkedEmail == 2 ? AppColor.primaryGreen : AppColor.primaryWhite,
                                size: width*0.060,
                              ),)
                            ],
                          )

                        ],
                      )
                  ),
                )

            ),

            SizedBox(height: height*0.05,),

            CustomButton(buttonName: Constant.logOut,
                buttonColor:  AppColor.primaryWhite,
                textColor: AppColor.primaryRed,
                onPressed: (){})
          ],
        ),
      ),
    );
  }
}
