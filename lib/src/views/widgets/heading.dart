import 'package:flutter/material.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constants.dart';

class Heading extends StatelessWidget {
  const Heading(
      {super.key, required this.text, required this.height, this.textAlign});
  final String text;
  final double height;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: AppColor.primaryRed,
          fontSize: height > 650
              ? 36
              : height > 440
                  ? 30
                  : 28,
          fontWeight: FontWeight.w800,
          fontFamily: Constants.kFontFamilySS3),
    );
  }
}
