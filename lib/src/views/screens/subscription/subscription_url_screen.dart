import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/subscription/subscription_url_controller.dart';

import 'package:reg_page/src/utils/res/constants.dart';
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
      backgroundColor: JHGColors.primaryBlack,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: width < 850
                ? 0
                : width < 1100 && width >= 850
                    ? width * .25
                    : width * .30,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.07),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: height * 0.030),
                const JHGAppBar(),
                SizedBox(height: height * 0.1),
                const Heading(
                    text: Constants.chooseYourSubscriptionText, height: 320),
                SizedBox(height: height * 0.08),
                Text(
                  Constants.subscriptionUrlSubText,
                  style: TextStyle(
                    color: JHGColors.greySecondary,
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
                SizedBox(height: height * 0.04),
              ],
            ),
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