import 'package:flutter/material.dart';
import 'package:reg_page/src/colors.dart';

class HeaderImage extends StatelessWidget {
  final double height;
  final double width;

  const HeaderImage({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: width,
          height: height > 650
              ? height * 0.46
              : height > 440
                  ? height * 0.36
                  : height * 0.30,
          child: Image.asset(
            "assets/images/jhg_background.png",
            package: 'reg_page',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  AppColor.primaryBlack,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
