import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/utils/dialogs/restore_popup_dialog.dart';
import 'package:reg_page/src/utils/res/urls.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({
    Key? key,
    required this.appName,
    required this.appVersion,
    required this.callback,
  }) : super(key: key);

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
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width < 850
              ? 0
              : width < 1100 && width >= 850
                  ? width * .25
                  : width * .30,
        ),
        color: AppColor.primaryBlack,
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.08,
            right: width * 0.08,
            top: height * 0.04,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.030,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColor.primaryWhite,
                        size: 25,
                      ),
                    ),
                    // Swap the positions of the Report a Bug icon and text
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => BugReportPage(),
                    //       ),
                    //     );
                    //   },
                    //   child: Row(
                    //     children: [
                    //       SizedBox(width: 10),
                    //       Padding(
                    //         padding: EdgeInsets.only(
                    //             right: 4.0), // Add padding to the right
                    //         child: Icon(
                    //           Icons.error_outline_rounded,
                    //           color: AppColor.primaryRed,
                    //           size: 16,
                    //         ),
                    //       ),
                    //       Text(
                    //         'Report an Issue',
                    //         style: TextStyle(
                    //           color: AppColor.primaryRed,
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: height * 0.030,
                ),
                AppInfoSection(
                  title: Constants.appName,
                  subtitle: widget.appName,
                ),
                SizedBox(
                  height: height * 0.010,
                ),
                AppInfoSection(
                  title: Constants.version,
                  subtitle: widget.appVersion,
                ),
                SizedBox(
                  height: height * 0.030,
                ),
                InfoButtonSection(
                  title: Constants.viewPrivacyPolicy,
                  onPressed: () {
                    _launchUrl(Constants.policyPrivacyUrl);
                  },
                ),
                InfoButtonSection(
                  title: Constants.viewTermsOfUse,
                  onPressed: () {
                    _launchUrl(Constants.termAndServicesUrl);
                  },
                ),
                InfoButtonSection(
                  title: Constants.restorePurchases,
                  onPressed: () {
                    restorePopupDialog(
                      context,
                      Constants.restoreNotFound,
                      Constants.restoreNotFoundDescription,
                    );
                  },
                ),
                kIsWeb
                    ? const SizedBox()
                    : Platform.isAndroid
                        ? InfoButtonSection(
                            title: Constants.cancelSubscription,
                            onPressed: () {
                              _launchUrl(Constants.cancelSubscriptionUrl);
                            },
                          )
                        : const SizedBox(),
                InfoButtonSection(
                  title: Constants.visitJamieHarrisonGuitar,
                  onPressed: () {
                    _launchUrl(Urls.jhgUrl);
                  },
                ),
                SizedBox(
                  height: height * 0.045,
                ),
                Center(
                  child: Text(
                    Constants.appQuotes,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColor.secondaryWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: Constants.kFontFamilySS3),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Center(
                  child: Text(
                    Constants.williamShakespeare,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColor.secondaryWhite,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: Constants.kFontFamilySS3),
                  ),
                ),
                SizedBox(
                    height: height * 0.16,
                    width: width,
                    child: Center(
                      child: SizedBox(
                        height: height * 0.16,
                        width: width * 0.6,
                        child: Image.asset(
                          "assets/images/jhg_sign.png",
                          package: Constants.regPackage,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )),
                SizedBox(
                  height: height * 0.02,
                ),
                Center(
                  child: Text(
                    Constants.copyRight,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.secondaryWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: Constants.kFontFamilySS3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppInfoSection extends StatelessWidget {
  const AppInfoSection({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: AppColor.secondaryWhite,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: Constants.kFontFamilySS3),
          ),
          Text(
            subtitle,
            style: TextStyle(
                color: AppColor.secondaryWhite,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: Constants.kFontFamilySS3),
          ),
        ],
      ),
    );
  }
}

class InfoButtonSection extends StatelessWidget {
  const InfoButtonSection({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: height * 0.065,
          width: width * 0.85,
          padding: EdgeInsets.symmetric(horizontal: width * 0.01),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColor.greyPrimary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: AppColor.secondaryWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: Constants.kFontFamilySS3),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColor.secondaryWhite,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
