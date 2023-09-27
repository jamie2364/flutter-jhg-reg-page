import 'package:flutter/material.dart';
import 'colors.dart';
import 'custom_button.dart';
import 'heading.dart';

class Setting extends StatelessWidget {
  const Setting({super.key,
  required this.onBackPress,
    required this.onCheckedPress,
    required this.onButtonPress,
    required this.onMenuPress,
    required this.checkedEmail,

  });


  final int checkedEmail;
  final VoidCallback onCheckedPress;
  final VoidCallback onBackPress;
  final VoidCallback onMenuPress;
  final VoidCallback onButtonPress;


  @override
  Widget build(BuildContext context) {
    final height =  MediaQuery.of(context).size.height;
    final width =  MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height*0.030,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onButtonPress,
              child: Icon(Icons.arrow_back_ios,color: AppColor.primaryWhite,
                size: width*0.060,
              ),
            ),
            InkWell(
              onTap: (){
                onMenuPress();
              },
              child: Icon(Icons.more_vert,color: AppColor.primaryWhite,
                size: width*0.060,
              ),
            )
          ],),
        SizedBox(height: height*0.030,),
        const Heading(text: "Setting"),
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
                        "SOCIAL",
                        style:  TextStyle(
                            color: AppColor.secondaryWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Text(
                        "MEDIA",
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
                            "LINK",
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
                        "EMAIL &",
                        style:  TextStyle(
                            color: AppColor.secondaryWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Text(
                        "MESSAGES",
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
                            "I want to receive email\nabout the sales",
                            style:  TextStyle(
                                color: AppColor.secondaryWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          IconButton(onPressed: onCheckedPress, icon:
                          Icon(
                            checkedEmail == 1 ?  Icons.check_box :
                            Icons.check_box_outline_blank_rounded,
                            color:  checkedEmail == 1 ? AppColor.primaryGreen : AppColor.primaryWhite,
                            size: width*0.060,
                          ),)
                        ],
                      ),
                      Divider(color: AppColor.primaryBlack,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "I want to receive messages\nabout the sales",
                            style:  TextStyle(
                                color: AppColor.secondaryWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          IconButton(onPressed: onCheckedPress, icon:
                          Icon(
                            checkedEmail == 2 ?  Icons.check_box :
                            Icons.check_box_outline_blank_rounded,
                            color:  checkedEmail == 2 ? AppColor.primaryGreen : AppColor.primaryWhite,
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

        CustomButton(buttonName: "Log Out",
            buttonColor:  AppColor.primaryWhite,
            textColor: AppColor.primaryRed,
            onPressed: onButtonPress)
      ],
    );
  }
}
