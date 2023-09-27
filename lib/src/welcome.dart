import 'package:flutter/material.dart';
import 'colors.dart';
import 'custom_button.dart';
import 'heading.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key,required this.selectedPlan,required this.onPlanSelected,
  required this.onButtonPress});

  final int selectedPlan;
  final VoidCallback onPlanSelected;
  final VoidCallback onButtonPress;

  @override
  Widget build(BuildContext context) {
    final height =  MediaQuery.of(context).size.height;
    final width =  MediaQuery.of(context).size.width;
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height*0.30,),
        const Heading(text: "Welcome"),

        Text(
          "Please check the world how you would\nlike to get stared",
          style:  TextStyle(
              color: AppColor.secondaryWhite,
              fontSize: 14,
              fontWeight: FontWeight.w400
          ),
        ),

        SizedBox(height: height*0.07,),
        Center(
            child:
            Container(
              height:height * 0.13,
              width:  width * 0.85,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color:
                  selectedPlan == 1 ? AppColor.primaryRed : AppColor.primaryWhite,
                      width: 1.5),
                  color: AppColor.primaryBlack),
              child:  Padding(
                  padding:  EdgeInsets.symmetric(horizontal:width*0.050),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.07,
                        child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title:  Text(
                              "Annual Plan",
                              style:  TextStyle(
                                  color: AppColor.primaryWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            subtitle:Text(
                              "1 week free, then £9.99 per year",
                              style:  TextStyle(
                                  color: AppColor.secondaryWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            trailing:
                            InkWell(
                              onTap: onPlanSelected,
                              child: Container(
                                height: height*0.027,
                                width: height*0.027,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:  selectedPlan == 1 ? AppColor.primaryRed : AppColor.primaryBlack,
                                  shape: BoxShape.circle,
                                  border: Border.all(color:
                                  selectedPlan == 1 ? AppColor.primaryRed : AppColor.primaryWhite,
                                      width: 1.8),
                                ),
                                child: Icon(Icons.done,color: AppColor.primaryBlack,
                                  size: width*0.04,
                                ),
                              ),
                            )

                        ),
                      ),
                      Divider(color: AppColor.secondaryWhite,),
                      Text(
                          "Save 40 % ",
                          style:  TextStyle(
                              color: AppColor.secondaryWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                          ))

                    ],
                  )
              ),
            )

        ),


        SizedBox(height: height*0.03,),

        Center(
            child:
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width:  MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color:
                      selectedPlan == 2 ? AppColor.primaryRed : AppColor.primaryWhite,
                      width: 1.5),
                  color: AppColor.primaryBlack),
              child:  Padding(
                padding:  EdgeInsets.symmetric(horizontal:width*0.035),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Monthly Plan",
                      style:  TextStyle(
                          color: AppColor.primaryWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                        InkWell(
                          onTap: onPlanSelected,
                          child: Container(
                            height: height*0.027,
                            width: height*0.027,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:  selectedPlan == 2 ? AppColor.primaryRed : AppColor.primaryBlack,
                              shape: BoxShape.circle,
                              border: Border.all(color:
                              selectedPlan == 2 ? AppColor.primaryRed : AppColor.primaryWhite,
                                  width: 1.8),
                            ),
                            child: Icon(Icons.done,color: AppColor.primaryBlack,
                              size: width*0.04,
                            ),
                          ),
                        )
                  ],
                ),
              ),
            )

        ),

        SizedBox(height: height*0.05,),

        CustomButton(buttonName: "Try It Free",
            buttonColor: AppColor.primaryRed,
            textColor: AppColor.primaryWhite,
            onPressed: onButtonPress)
      ],
    );
  }
}
