import 'package:flutter/material.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/views/screens/info_screen.dart';

class InfoButton extends StatelessWidget {
  final double width;
  final double height;
  final String appName;
  final String appVersion;
  final Function() restorePurchase;

  const InfoButton({
    super.key,
    required this.width,
    required this.height,
    required this.appName,
    required this.appVersion,
    required this.restorePurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: width * 0.05,
      top: MediaQuery.of(context).padding.top + height * 0.01,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoScreen(
                appName: appName,
                appVersion: appVersion,
                callback: restorePurchase,
              ),
            ),
          );
        },
        child: Icon(
          Icons.info_rounded,
          color: AppColor.primaryWhite,
          size: 30,
        ),
      ),
    );
  }
}
