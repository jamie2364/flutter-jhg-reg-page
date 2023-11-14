import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/subscription_model.dart';
import 'colors.dart';
import 'custom_button.dart';
import 'heading.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen(
      {super.key,required this.appName,required this.appVersion});

  final String appName;
  final String appVersion;

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.primaryBlack,
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            color: AppColor.primaryBlack,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.08, vertical: height * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.030,
                  ),
                  // BACK ICON BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColor.secondaryWhite,
                          size: width * 0.050,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: height * 0.050,
                  ),
                  AppInfoSection(title: Constant.appName, subtitle: widget.appName),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  AppInfoSection(title: Constant.version, subtitle: widget.appVersion),
                  // SPACER
                  SizedBox(
                    height: height * 0.050,
                  ),

                  InfoButtonSection(title: Constant.viewPrivacyPolicy, onPressed: (){}),

                  InfoButtonSection(title: Constant.viewTermsOfUse, onPressed: (){}),

                  InfoButtonSection(title: Constant.restorePurchases, onPressed: (){}),

                  InfoButtonSection(title: Constant.visitJamieHarrisonGuitar, onPressed: (){}),

                  SizedBox(
                    height: height * 0.060,
                  ),
                  // QUOTES
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: width*0.02),
                    child: Text(
                      Constant.appQuotes,
                      style:  TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColor.secondaryWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: height * 0.18,
                  ),
                  // COPY RIGHT TEXT
                  Center(
                    child: Text(
                      Constant.copyRight,
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                        color: AppColor.secondaryWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Positioned(
              top: height*0.68,
              left: width*0.35,
              child:     // SIGNATURE
              Container(
               // color: Colors.red,
                height: height*0.15,
                width: width*0.4,
                child: Image.asset(
                  "assets/images/sign.png",
                  fit: BoxFit.fill,
                ),
              ),)
        ],
      ),
    );
  }
}

class AppInfoSection extends StatelessWidget {
  const AppInfoSection({super.key,required this.title,required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: width*0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(
          title,
         style:  TextStyle(
            color: AppColor.secondaryWhite,
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
      ),

          Text(
            subtitle,
            style:  TextStyle(
                color: AppColor.secondaryWhite,
                fontSize: 14,
                fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
    );
  }
}


class InfoButtonSection extends StatelessWidget {
  const InfoButtonSection({super.key,required this.title,required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding:  EdgeInsets.symmetric(vertical:height*0.01),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: height * 0.065,
          width: width * 0.85,
          padding: EdgeInsets.symmetric(horizontal: width*0.035),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color:AppColor.greyPrimary ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                title,
                style:  TextStyle(
                    color: AppColor.secondaryWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),

             Icon(Icons.arrow_forward_ios,color: AppColor.secondaryWhite,size: width*0.050,)

            ],
          ),
        ),
      ),
    );
  }
}