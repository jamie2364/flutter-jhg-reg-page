import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/src/utils/res/constants.dart';

restorePopupDialog(BuildContext context, String title, String description) {
  return showDialog(
      context: (context),
      builder: (context) {
        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: width < 850
                ? 24
                : width < 1100 && width >= 850
                    ? width * .25
                    : width * .35,
          ),
          alignment: Alignment.center,
          child: Align(
            alignment: Alignment.center,
            child: Container(
                height: height * 0.5,
                width: width,
                decoration: BoxDecoration(
                  color: JHGColors.greyPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: JHGColors.greyPrimary,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                // color: Colors.red,
                                height: height * 0.020,
                                width: height * 0.020,
                                child: Image.asset(
                                  "assets/images/icon_cross.png",
                                  package: 'reg_page',
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        SizedBox(
                          height: height * 0.080,
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                              color: JHGColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: Constants.kFontFamilySS3),
                        ),
                        SizedBox(
                          height: height * 0.050,
                        ),
                        Text(
                          description,
                          style: TextStyle(
                              color: JHGColors.greySecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: Constants.kFontFamilySS3),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Container(
                              height: height * 0.065,
                              width: width * 06,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.055),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: JHGColors.primary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                Constants.close,
                                style: TextStyle(
                                    color: JHGColors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Constants.kFontFamilySS3),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.020,
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        );
      });
}
