import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/colors.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/subscription_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen(
      {super.key,
      required this.yearlySubscriptionId,
      required this.monthlySubscriptionId,
      required this.appName,
      required this.appVersion,
      required this.nextPage});

  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
  final String appName;
  final String appVersion;
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

  ApiRepo repo = ApiRepo();
  LoginModel loginModel = LoginModel();
  SubscriptionModel subscriptionModel = SubscriptionModel();
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
                      appName: widget.appName,
                      appVersion: widget.appVersion,
                      nextPage: () => widget.nextPage(),
                    )));
      } else {
        // ignore: use_build_context_synchronously
        loaderDialog(context);
        // if (widget.appName == "JHG Course Hub") {
        Response response = await repo.getRequest(Constant.subscriptionUrl, {});
        // print("response is ${response.data}");
        subscriptionModel = SubscriptionModel.fromJson(response.data);
        setState(() {});
        if (subscriptionModel.allAccessPass == "active" ||
            subscriptionModel.softwareSuite == "active") {
          if (widget.appName == "JHG Course Hub") {
            if (subscriptionModel.courseHub == "active") {
              print("object active courseHub");
              await LocalDB.storeSubscriptionPurchase(true);
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => widget.nextPage()));
            } else { print("object active courseHub");
              await LocalDB.clearLocalDB();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Welcome(
                            yearlySubscriptionId: widget.yearlySubscriptionId,
                            monthlySubscriptionId: widget.monthlySubscriptionId,
                            appName: widget.appName,
                            appVersion: widget.appVersion,
                            nextPage: () => widget.nextPage(),
                          )));
            }
          } else {
            await LocalDB.storeSubscriptionPurchase(true);
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => widget.nextPage()));
          }
          // ignore: use_build_context_synchronously
        } else {
          await LocalDB.clearLocalDB();
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Welcome(
                        yearlySubscriptionId: widget.yearlySubscriptionId,
                        monthlySubscriptionId: widget.monthlySubscriptionId,
                        appName: widget.appName,
                        appVersion: widget.appVersion,
                        nextPage: () => widget.nextPage(),
                      )));
        }
        // }
        // else {
        //   // ignore: use_build_context_synchronously
        //   Navigator.pushReplacement(context,
        //       MaterialPageRoute(builder: (context) => widget.nextPage()));
        // }

        // ignore: use_build_context_synchronously
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => widget.nextPage()));
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
          "assets/images/jhg_logo.png",
          package: 'reg_page',
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.height * 0.30,
          fit: BoxFit.cover,
        ),
      )),
    ));
  }
}
