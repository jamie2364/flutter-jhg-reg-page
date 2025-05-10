import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';

class Nav {
  Nav._();
  static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static to(Widget page, [BuildContext? context]) => Navigator.push(
      context ?? key.currentState!.context,
      MaterialPageRoute(
        builder: (context) => page,
      ));

  static BuildContext get context => key.currentState!.context;

  static off(Widget page, [BuildContext? context]) => Navigator.pushReplacement(
      context ?? key.currentState!.context,
      MaterialPageRoute(
        builder: (context) => page,
      ));

  static offAll(Widget page, [BuildContext? context]) {
    final effectiveContext = context ?? key.currentState?.context;
    if (effectiveContext != null && Navigator.canPop(effectiveContext)) {
      Navigator.pushAndRemoveUntil(
        effectiveContext,
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false,
      );
    } else {
      // Handle the case where the context is null or there's no valid navigation stack
      off(page);
      debugLog("Navigation context is invalid or no routes in the stack.");
    }
  }

  static back([result]) => Navigator.pop(key.currentState!.context, result);
}
