import 'package:flutter/material.dart';
import 'package:reg_page/src/utils/res/constant.dart';
import '../../utils/res/colors.dart';

class Heading extends StatelessWidget {
  const Heading({super.key,required this.text, required this.height});
  final String text;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:  TextStyle(
          color: AppColor.primaryRed,

          fontSize: height>650?36:height>440?30:28,
          fontWeight: FontWeight.w800,
          fontFamily: Constant.kFontFamilySS3
      ),
    );
  }
}
