import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen(
      {super.key,
      required this.yearlySubscriptionId,
      required this.monthlySubscriptionId,
        required this.appName,
        required this.nextPage});

  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
  final String appName;
  final Widget Function() nextPage;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    routes();
    animate();
  }

  double logoSize = 1;

  animate() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        logoSize = 1.1;
      });
    });
  }

  routes() async {
    animate();
    Timer(const Duration(seconds: 3), () async {
      String? endDate = await LocalDB.getEndDate;
      DateTime currentDate = DateTime.now();
      if (endDate != null) {
        DateTime expiryDate = DateTime.parse(endDate);
        if (currentDate.isAfter(expiryDate)) {
          {
            await LocalDB.clearLocalDB();
          }
        }
      }

      String? token = await LocalDB.getBearerToken;
      if (token == null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Welcome(
                      yearlySubscriptionId: widget.yearlySubscriptionId,
                      monthlySubscriptionId: widget.monthlySubscriptionId,
                      appName:  widget.appName,
                      nextPage: () => widget.nextPage(),
                    )));
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => widget.nextPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width * 1,
      color: AppColor.primaryBlack,
      child: Center(
          child: AnimatedScale(
        scale: logoSize,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.linearToEaseOut,
        child: Image.asset(
          "assets/images/logo.png",
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.height * 0.30,
          fit: BoxFit.cover,
        ),
      )),
    ));
  }
}
