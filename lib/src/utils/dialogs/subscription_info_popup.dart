import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/src/utils/res/constants.dart';

void showPlanInfoDialog(
    BuildContext context, String? price, List<String> featuresList,
    {String? label, String? desc}) {
  final height = MediaQuery.of(context).size.height;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        surfaceTintColor: Colors.transparent,
        backgroundColor: JHGColors.dialogBackground,
        shadowColor: Theme.of(context).shadowColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 32),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: height * 0.04),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        label ?? "Annual Subscription",
                        style: TextStyle(
                            color: JHGColors.secondaryWhite,
                            fontSize: 26,
                            // Adjust the font size as needed
                            fontWeight: FontWeight
                                .w700, // Adjust the font weight as needed
                            fontFamily: Constants.kFontFamilySS3),
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Text(
                        desc ??
                            "Get a free trial for 7 days, after which you will be automatically charged $price. You will then be charged this amount each year, starting from your initial payment. You may cancel your subscription at any time during the trial period, or anytime after. Upon cancellation, your subscription will remain active for one year after your previous payment. For this price, you will receive unlimited and unrestricted access to all features the app, the ability to report issues within the app, and full customer support.",
                        style: TextStyle(
                            color: JHGColors.secondaryWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: Constants.kFontFamilySS3),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Column(
                        children: featuresList.map<Widget>((item) {
                          return Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 17,
                                    height: 17,
                                    child: Image.asset(
                                      "assets/images/plus.png",
                                      package: 'reg_page',
                                      fit: BoxFit.cover,
                                      color: JHGColors.primary,
                                    )),
                                const SizedBox(width: 15),
                                Expanded(
                                    child: Text(
                                  item,
                                  style: TextStyle(
                                      color: JHGColors.secondaryWhite,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: Constants.kFontFamilySS3),
                                ))
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            JHGPrimaryBtn(
                label: Constants.done,
                onPressed: () async {
                  Navigator.pop(context);
                })
          ],
        ),
      );
    },
  );
}
