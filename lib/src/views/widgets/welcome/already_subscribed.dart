import 'package:flutter/material.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constant.dart';

class AlreadySubscribed extends StatelessWidget {
  final void Function() onLogin;

  const AlreadySubscribed({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Constant.alreadySubscribed,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColor.primaryWhite,
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: Constant.kFontFamilySS3,
          ),
        ),
        GestureDetector(
          onTap: onLogin,
          child: Text(
            Constant.logIn,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColor.primaryWhite,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: Constant.kFontFamilySS3,
            ),
          ),
        ),
      ],
    );
  }
}
