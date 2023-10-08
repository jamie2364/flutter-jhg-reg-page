import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/colors.dart';
import 'package:reg_page/src/constant.dart';
class SplashScreen extends StatefulWidget {

    const SplashScreen({super.key,
    required this.yearlySubscriptionId,
    required this.monthlySubscriptionId,
    required this.nextPage});

    final String  yearlySubscriptionId;
    final String  monthlySubscriptionId;
    final Widget Function() nextPage;


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    routes();
  }

  routes()async{

    Timer(const Duration(seconds: 3),()
    async {
      String? endDate = await LocalDB.getEndDate;
      DateTime currentDate = DateTime.now();

      // if (endDate != null) {
      //   DateTime expiryDate = DateTime.parse(endDate);
      //   if (currentDate.isAfter(expiryDate)) {
      //     {
      //       await LocalDB.clearLocalDB();
      //     }
      //   }
      // }
      //
      // String? token = await LocalDB.getBearerToken;
      // if (token == null) {
      //   // ignore: use_build_context_synchronously
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (context) =>
      //       Welcome(
      //         yearlySubscriptionId:  widget.yearlySubscriptionId,
      //         monthlySubscriptionId: widget.monthlySubscriptionId,
      //         nextPage: () => widget.nextPage(),)));
      // } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => widget.nextPage()));
      //}
    });
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          color:AppColor.primaryBlack,
          child: Center(
            child: Text(
              Constant.jamieHarrison,
              style: TextStyle(
                color:AppColor.primaryWhite,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
    );
  }
}
