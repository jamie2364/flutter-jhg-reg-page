import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/src/utils/res/constants.dart';

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
          height: kIsWeb
              ? height * 0.7
              : height > 650
                  ? height * 0.44
                  : height > 440
                      ? height * 0.34
                      : height * 0.30,
          child: Image.asset(
            "assets/images/jhg_background.png",
            package: Constants.regPackage,
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
                  JHGColors.primaryBlack,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
