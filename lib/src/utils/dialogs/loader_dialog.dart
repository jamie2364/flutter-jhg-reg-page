import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/src/utils/navigate/nav.dart';

loaderDialog([BuildContext? context]) {
  return showDialog(
      context: context ?? Nav.key.currentState!.context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (context) {
        return Dialog(
          backgroundColor: JHGColors.loaderBackground.withOpacity(0.2),
          insetPadding: EdgeInsets.zero,
          surfaceTintColor: JHGColors.loaderBackground,
          child: Container(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).height,
              color: JHGColors.loaderBackground.withOpacity(0.7),
              child: const Center(
                  child: CircularProgressIndicator(
                color: JHGColors.primary,
              ))),
        );
      });
}

hideLoading([BuildContext? context]) {
  Navigator.pop(context ?? Nav.key.currentState!.context);
}
