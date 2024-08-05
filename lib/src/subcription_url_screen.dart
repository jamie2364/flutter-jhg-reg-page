import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/colors.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/custom_button.dart';
import 'package:reg_page/src/models/platform_model.dart';
import 'package:reg_page/src/utils/platform_utils.dart';
import 'package:reg_page/src/widgets/patform_selection_widget.dart';

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
  ApiRepo repo = ApiRepo();

  var platformsList = <PlatformModel>[];
  String selectedPlatform = "";
  PlatformModel? selectedModel;

  String productIds = '';

  @override
  void initState() {
    super.initState();
    platformsList = PlatformUtils.getList();
    if (!widget.appName.contains("Practice Routines")) {
      platformsList.removeAt(1);
    }
    selectedPlatform = platformsList[0].platform;
    selectedModel = platformsList[0];
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
                  bottom: height * 0.1,
                  left: width * 0.090,
                  right: width * 0.090),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.030,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColor.primaryWhite,
                      size: width * 0.060,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Text(
                    Constant.chooseYourSubscriptionText,
                    style: TextStyle(
                        color: AppColor.primaryWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: Constant.kFontFamilySS3),
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
                        fontFamily: Constant.kFontFamilySS3),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return PlatformSelectionWidget(
                          model: platformsList[index],
                          selectedPlatform: selectedPlatform,
                          onTap: (model) {
                            setState(() {
                              selectedPlatform = model.platform;
                              selectedModel = model;
                            });
                          });
                    },
                    itemCount: platformsList.length,
                  )),
                  CustomButton(
                      buttonName: Constant.continueText,
                      buttonColor: AppColor.primaryRed,
                      textColor: AppColor.primaryWhite,
                      onPressed: () async {
                        getProductIds();
                      })
                ],
              )),
        ));
  }

  Future<void> getProductIds() async {
    loaderDialog(context);
    try {
      Response response = await repo.getRequestWithoutHeader(
          "${selectedModel?.baseUrl}${Constant.productIdEndPoint}", {});
      if (response.data != null && response.data["product_ids"] != null) {
        productIds = response.data["product_ids"];
        Navigator.pop(context);
        launchSignupPage();
      } else {
        showFailureMessage();
      }
    } catch (e) {
      showFailureMessage();
    }
  }

  void launchSignupPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SignUp(
            yearlySubscriptionId: widget.yearlySubscriptionId,
            monthlySubscriptionId: widget.monthlySubscriptionId,
            appName: widget.appName,
            appVersion: widget.appVersion,
            nextPage: widget.nextPage,
            loginUrl: selectedModel!.loginUrl,
            platform: selectedModel!.baseUrl,
            productIds: productIds,
            subscriptionUrl: selectedModel!.subscriptionURL,
          );
        },
      ),
    );
  }

  void showFailureMessage() {
    Navigator.pop(context);
    showToast(
        context: context,
        message: Constant.productIdsFailedMessage,
        isError: true);
  }
}
