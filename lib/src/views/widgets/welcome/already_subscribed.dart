import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/user/user_controller.dart';
import 'package:reg_page/src/utils/res/constants.dart';

import '../../../utils/url/urls.dart';

class AlreadySubscribed extends StatelessWidget {
  final void Function() onLogin;

  const AlreadySubscribed({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          Constants.alreadySubscribed,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: JHGColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: Constants.kFontFamilySS3,
          ),
        ),
        buildTextButton(onLogin, Constants.logIn),
        if (Constants.isTest)
          buildTextButton(
            () {
              final userCtrlr = getIt<UserController>();
              Urls.base = BaseUrl.jhg;
              userCtrlr.userNameC.text = 'jamieharrisontest';
              userCtrlr.passC.text = 'Jasmine-6259JHG';
              userCtrlr.loginUserForPlatform();
            },
            ' Test Login',
            JHGColors.primary,
          ),
      ],
    );
  }

  Widget buildTextButton(void Function()? onTap, String str, [Color? color]) {
    // Padded hit area so "Login" is comfortably tappable instead of a bare,
    // cramped word pinned between the plan box and the Continue button.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Text(
          str,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color ?? JHGColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: Constants.kFontFamilySS3,
          ),
        ),
      ),
    );
  }
}
