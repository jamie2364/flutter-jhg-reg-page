import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/colors.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/custom_button.dart';

class SubscriptionUrlScreen extends StatefulWidget {
  const SubscriptionUrlScreen(
      {super.key,
      required this.yearlySubscriptionId,
      required this.monthlySubscriptionId,
      required this.appName,
      required this.appVersion,
      required this.nextPage});

  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
  final String appName;
  final String appVersion;
  final Widget Function() nextPage;

  @override
  State<StatefulWidget> createState() => _SubcriptionState();
}

class _SubcriptionState extends State<SubscriptionUrlScreen> {
  int selectedPosition = 1;

  onUrlSelect(int plan) {
    setState(() {
      selectedPosition = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColor.primaryBlack,
        body: SafeArea(
          child: Container(
              margin: EdgeInsets.only(
                  top: height * 0.1,
                  bottom: height * 0.1,
                  left: width * 0.090,
                  right: width * 0.090),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Constant.chooseYourSubscriptionText,
                    style: TextStyle(
                      color: AppColor.primaryWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  Text(
                    Constant.subscriptionUrlSubText,
                    style: TextStyle(
                      color: AppColor.greySecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  GestureDetector(
                    onTap: () {
                      onUrlSelect(1);
                    },
                    child: Container(
                      height: height * 0.06,
                      width: width * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedPosition == 1
                              ? AppColor.primaryRed
                              : AppColor.primaryWhite,
                          width: 1.5,
                        ),
                        color: AppColor.primaryBlack,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.050,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Constant.evoloUrlText,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColor.greySecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Container(
                                  height: height * 0.027,
                                  width: height * 0.027,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selectedPosition == 1
                                        ? AppColor.primaryRed
                                        : AppColor.primaryBlack,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selectedPosition == 1
                                          ? AppColor.primaryRed
                                          : AppColor.primaryWhite,
                                      width: 1.8,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.done,
                                    color: AppColor.primaryBlack,
                                    size: width * 0.04,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      onUrlSelect(2);
                    },
                    child: Container(
                      height: height * 0.06,
                      width: width * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedPosition == 2
                              ? AppColor.primaryRed
                              : AppColor.primaryWhite,
                          width: 1.5,
                        ),
                        color: AppColor.primaryBlack,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.050,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Constant.jamieUrlText,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColor.greySecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Container(
                                  height: height * 0.027,
                                  width: height * 0.027,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selectedPosition == 2
                                        ? AppColor.primaryRed
                                        : AppColor.primaryBlack,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selectedPosition == 2
                                          ? AppColor.primaryRed
                                          : AppColor.primaryWhite,
                                      width: 1.8,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.done,
                                    color: AppColor.primaryBlack,
                                    size: width * 0.04,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                      buttonName: Constant.continueText,
                      buttonColor: AppColor.primaryRed,
                      textColor: AppColor.primaryWhite,
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUp(
                                yearlySubscriptionId:
                                    widget.yearlySubscriptionId,
                                monthlySubscriptionId:
                                    widget.monthlySubscriptionId,
                                appName: widget.appName,
                                appVersion: widget.appVersion,
                                nextPage: widget.nextPage,
                                loginUrl: selectedPosition == 1
                                    ? Constant.evoloBaseUrl
                                    : Constant.loginUrl,
                                platform: selectedPosition == 1
                                    ? 'evolo'
                                    : 'jamieharrisonguitar',
                                productIds: selectedPosition == 1
                                    ? ''
                                    : '1144975,1144971',
                              );
                            },
                          ),
                        );
                      })
                ],
              )),
        ));
  }
}
