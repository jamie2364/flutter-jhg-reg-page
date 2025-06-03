import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/utils/dialogs/restore_popup_dialog.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/utils/url/urls.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({
    super.key,
    required this.callback,
  });

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
      backgroundColor: JHGColors.primaryBlack,
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: Utils.screenHrPadding(context),
        ),
        color: JHGColors.primaryBlack,
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.04),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.030,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    JHGBackButton(),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Icon(
                    //     Icons.arrow_back_ios,
                    //     color: JHGColors.primaryWhite,
                    //     size: 25,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: height * 0.030,
                ),
                AppInfoSection(
                  title: Constants.appName,
                  subtitle: getIt<SplashController>().appName,
                ),
                SizedBox(
                  height: height * 0.010,
                ),
                AppInfoSection(
                  title: Constants.version,
                  subtitle: getIt<SplashController>().appVersion,
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
                        color: JHGColors.secondaryWhite,
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
                        color: JHGColors.secondaryWhite,
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
                      color: JHGColors.secondaryWhite,
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
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
        color: JHGColors.secondaryWhite,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: Constants.kFontFamilySS3);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textStyle,
        ),
        Text(
          subtitle,
          style: textStyle.copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

class InfoButtonSection extends StatelessWidget {
  const InfoButtonSection({
    super.key,
    required this.title,
    required this.onPressed,
  });

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
          padding: const EdgeInsets.only(left: 15, right: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: JHGColors.greyPrimary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: JHGColors.secondaryWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: Constants.kFontFamilySS3),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: JHGColors.secondaryWhite,
                // size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
