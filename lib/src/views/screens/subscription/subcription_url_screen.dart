import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/subscription/subscription_url_controller.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/utils/utils.dart';
import 'package:reg_page/src/views/widgets/heading.dart';
import 'package:reg_page/src/views/widgets/patform_selection_widget.dart';

class SubscriptionUrlScreen extends StatefulWidget {
  const SubscriptionUrlScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<SubscriptionUrlScreen> {
  @override
  Widget build(BuildContext context) {
    final height = Utils.height(context);
    final width = Utils.width(context);
    final controller = getIt<SubscriptionUrlController>()..initController();
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
              bottom: height * 0.1, left: width * 0.090, right: width * 0.090),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.030),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColor.primaryWhite,
                  size: 25,
                ),
              ),
              SizedBox(height: height * 0.1),
              const Heading(
                  text: Constants.chooseYourSubscriptionText, height: 320),
              SizedBox(height: height * 0.06),
              Text(
                Constants.subscriptionUrlSubText,
                style: TextStyle(
                  color: AppColor.greySecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: Constants.kFontFamilySS3,
                ),
              ),
              SizedBox(height: height * 0.04),
              const Expanded(child: SelectUrlsWidget()),
              JHGPrimaryBtn(
                label: Constants.continueText,
                onPressed: () => controller.getProductIds(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectUrlsWidget extends StatefulWidget {
  const SelectUrlsWidget({super.key});
  @override
  State<SelectUrlsWidget> createState() => _SelectUrlsWidgetState();
}

class _SelectUrlsWidgetState extends State<SelectUrlsWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = getIt<SubscriptionUrlController>();
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return PlatformSelectionWidget(
          model: controller.platformsList[index],
          selectedPlatform: controller.selectedModel.platform,
          onTap: (model) => setState(() {
            controller.onPlatformSelected(model);
          }),
        );
      },
      itemCount: controller.platformsList.length,
    );
  }
}
