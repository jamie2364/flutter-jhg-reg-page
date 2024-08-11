import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';

class Utils {
  static EdgeInsets customPadding(context) {
    return EdgeInsets.symmetric(
      horizontal: JHGResponsive.isMobile(context)
          ? kBodyHrPadding
          : JHGResponsive.isTablet(context)
              ? MediaQuery.sizeOf(context).width * .25
              : MediaQuery.sizeOf(context).width * .30,
    );
  }
}
