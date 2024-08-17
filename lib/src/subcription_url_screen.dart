import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/colors.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/custom_button.dart';
import 'package:reg_page/src/models/platform_model.dart';
import 'package:reg_page/src/repositories/repo.dart';
import 'package:reg_page/src/utils/urls.dart';
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
  // ApiRepo repo = ApiRepo();

  var platformsList = <PlatformModel>[];
  String selectedPlatform = "";
  PlatformModel? selectedModel;

  String productIds = '';

  @override
  void initState() {
    super.initState();
    platformsList = PlatformModel.getList();
    if (!Constant.evoloApps.contains(widget.appName)) {
      platformsList.removeAt(1);
    }
    selectedPlatform = platformsList[0].platform;
    selectedModel = platformsList[0];
    Urls.base = BaseUrl.fromString(platformsList[0].baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColor.primaryBlack,
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width < 850
                    ? 0
                    : width < 1100 && width >= 850
                        ? width * .20
                        : width * .25,
              ),
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
                      size: 25,
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
                            Urls.base = BaseUrl.fromString(model.baseUrl);
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
      final res = await Repo().getProductIds(widget.appName);
      debugLog('res in url screen $res');
      if (res != null) {
        productIds = res;
        Navigator.pop(context);
        launchSignupPage();
      } else {
        // showFailureMessage();
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
            productIds: productIds,
          );
        },
      ),
    );
  }

  void showFailureMessage() {
    showToast(
        context: context,
        message: Constant.productIdsFailedMessage,
        isError: true);
  }
}
