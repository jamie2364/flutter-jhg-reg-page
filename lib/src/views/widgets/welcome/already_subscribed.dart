import 'package:flutter/material.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constants.dart';

class AlreadySubscribed extends StatelessWidget {
  final void Function() onLogin;

  const AlreadySubscribed({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Constants.alreadySubscribed,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColor.primaryWhite,
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: Constants.kFontFamilySS3,
          ),
        ),
        GestureDetector(
          onTap: onLogin,
          child: Text(
            Constants.logIn,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColor.primaryWhite,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: Constants.kFontFamilySS3,
            ),
          ),
        ),
      ],
    );
  }
}
