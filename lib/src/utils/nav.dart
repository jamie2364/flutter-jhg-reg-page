import 'package:flutter/material.dart';

class Nav {
  Nav._();
  static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static to(Widget page) => Navigator.push(
      key.currentState!.context,
      MaterialPageRoute(
        builder: (context) => page,
      ));

  static off(Widget page) => Navigator.pushReplacement(
      key.currentState!.context,
      MaterialPageRoute(
        builder: (context) => page,
      ));

  static offAll(Widget page) => Navigator.pushAndRemoveUntil(
        key.currentState!.context,
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false,
      );

  static back([result]) => Navigator.pop(key.currentState!.context, result);
}
