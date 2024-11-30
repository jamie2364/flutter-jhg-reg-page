import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/views/widgets/heading.dart';

class WelcomeText extends StatelessWidget {
  final String appName;
  final double height;

  const WelcomeText({super.key, required this.appName, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Heading(
          text: Constants.welcome,
          height: height,
        ),
        Text(
          appName == "Course Hub"?
          Constants.welcomeToJamieHarrison:
          Constants.welcomeToMusicTools,
          style: TextStyle(
            color: JHGColors.white,
            fontSize: height > 650
                ? 18
                : height > 440
                    ? 16
                    : 14,
            fontWeight: FontWeight.w400,
            fontFamily: Constants.kFontFamilySS3,
          ),
        ),
        Text(
          appName,
          style: TextStyle(
            color: JHGColors.white,
            fontSize: height > 650
                ? 30
                : height > 440
                    ? 25
                    : 22,
            fontWeight: FontWeight.w700,
            fontFamily: Constants.kFontFamilySS3,
          ),
        ),
      ],
    );
  }
}
