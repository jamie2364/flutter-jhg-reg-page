// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/colors.dart';
import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/subscription_model.dart';

class UserSession {
  String url;
  String token;
  int userId;
  String userName;
  UserSession({
    required this.url,
    required this.token,
    required this.userId,
    required this.userName,
  });
}

class SplashScreen extends StatefulWidget {
  const SplashScreen(
      {super.key,
      required this.yearlySubscriptionId,
      required this.monthlySubscriptionId,
      required this.appName,
      required this.appVersion,
      required this.featuresList,
      required this.nextPage});

  final String yearlySubscriptionId;
  final String monthlySubscriptionId;
  final String appName;
  final String appVersion;
  final List<String> featuresList;
  final Widget Function() nextPage;
  static UserSession session =
      UserSession(url: 'jhg', token: '', userId: -1, userName: '');

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
      bool isFreePlan = await LocalDB.getIsFreePlan();
      // print('is Free Plan $isFreePlan');
      if (isFreePlan) {
        print('This user is on free Plan');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => widget.nextPage()));
        return;
      }
      String? token = await LocalDB.getBearerToken;
      int? userId = await LocalDB.getUserId;
      final url = await LocalDB.getBaseurl;
      final uName = await LocalDB.getUserName;
      SplashScreen.session = UserSession(
          url: url != null
              ? url.contains('evolo')
                  ? 'evolo'
                  : 'jhg'
              : 'jhg',
          token: token ?? '',
          userId: userId ?? -1,
          userName: uName ?? '');
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
                      featuresList: widget.featuresList,
                      nextPage: () => widget.nextPage(),
                    )));
      } else {
        // ignore: use_build_context_synchronously
        loaderDialog(context);
        final productId = await LocalDB.getproductIds;
        final baseUrl = await LocalDB.getBaseurl;
        //  if (widget.appName == "JHG Course Hub") {
        Response? response = await repo.getRequest(
            baseUrl == Constant.evoloUrl
                ? Constant.subscriptionUrlEvolo
                : Constant.subscriptionUrl,
            {
              "product_ids": productId,
            });
        //  print("response is ${response?.data}");
        if (response == null) {
          if (await LocalDB.isLoginTimeExpired) {
            elseFunction();
          } else {
            successFunction();
          }
        } else {
          subscriptionModel = SubscriptionModel.fromJson(response.data);
          setState(() {});

          final isActive = isSubscriptionActive(response.data,
              isCourseHubApp: widget.appName == "JHG Course Hub");
          if (isActive) {
            successFunction();
          } else {
            elseFunction();
          }
        }

        // } else {
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

  bool isSubscriptionActive(Map<String, dynamic>? json,
      {bool isCourseHubApp = false}) {
    if (json == null) return false;
    for (var entry in json.entries) {
      if ((isCourseHubApp) &&
          (entry.key == 'course_hub') &&
          (entry.value == "active")) {
        return true;
      } else if (entry.value == "active") {
        return true;
      }
    }

    return false;
  }

  successFunction() async {
    await LocalDB.storeSubscriptionPurchase(true);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widget.nextPage()));
  }

  elseFunction() async {
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
                  featuresList: widget.featuresList,
                  nextPage: () => widget.nextPage(),
                )));
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
