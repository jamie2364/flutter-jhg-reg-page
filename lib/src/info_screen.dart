import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'colors.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen(
      {super.key,required this.appName,required this.appVersion,required this.callback});

  final String appName;
  final String appVersion;
  final VoidCallback callback;

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {



  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

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
              padding: EdgeInsets.only(
                  left: width * 0.08,right: width * 0.08,top:height * 0.04),
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

                  // POLICY PRIVACY
                  InfoButtonSection(title: Constant.viewPrivacyPolicy, onPressed: (){
                    _launchUrl(Constant.policyPrivacyUrl);
                  }),

                  // TERM AND SERVICES
                  InfoButtonSection(title: Constant.viewTermsOfUse, onPressed: (){
                    _launchUrl(Constant.termAndServicesUrl);
                  }),

                  // RESTORE PURCHASES
                  InfoButtonSection(title: Constant.restorePurchases, onPressed: (){
                    widget.callback();
                  }),

                  //JAMIE HARRISON
                  InfoButtonSection(title: Constant.visitJamieHarrisonGuitar, onPressed: (){
                    _launchUrl(Constant.jamieUrl);
                  }),


                  SizedBox(
                    height: height * 0.060,
                  ),

                  // QUOTES
                  Center(
                    child: Text(
                      Constant.appQuotes,
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColor.secondaryWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: height * 0.01,
                  ),

                  Center(
                    child: Text(
                      Constant.williamShakespeare,
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                        color: AppColor.secondaryWhite,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: height * 0.19,
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
              top: height*0.73,
              left: width*0.25,
              child:     // SIGNATURE
              Container(
               // color: Colors.red,
                height: height*0.16,
                width: width*0.5,
                child: Image.asset(
                  "assets/images/jhg_sign.png",
                  package: 'reg_page',
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