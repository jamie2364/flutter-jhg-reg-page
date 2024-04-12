import 'package:flutter/material.dart';
import 'package:reg_page/src/constant.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.buttonName,
      required this.onPressed,
      required this.buttonColor,
      required this.textColor});

  final String buttonName;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: onPressed,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: buttonColor),
            child: Center(
                child: Text(
              buttonName,
              style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: Constant.kFontFamilySS3),
            )),
          )),
    );
  }
}
