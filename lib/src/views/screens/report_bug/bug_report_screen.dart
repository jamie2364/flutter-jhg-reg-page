// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/report_bug/bug_report_controller.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/utils/res/constants.dart';

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({
    super.key,
  });

  @override
  BugReportScreenState createState() => BugReportScreenState();
}

class BugReportScreenState extends State<BugReportScreen> {
  late TextEditingController descCntrlr;
  late BugReportController controller;
  @override
  void initState() {
    descCntrlr = TextEditingController();
    controller = BugReportController();
    controller.getDeviceInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: JHGColors.primaryBlack,
      appBar: AppBar(
        title: null,
        backgroundColor: JHGColors.primaryBlack,
        iconTheme: const IconThemeData(
          color: JHGColors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: JHGColors.primaryBlack,
          height: Utils.height(context),
          width: Utils.width(context),
          alignment: kIsWeb ? Alignment.center : Alignment.topLeft,
          padding: EdgeInsets.symmetric(horizontal: width * 0.060),
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            width: kIsWeb
                ? MediaQuery.sizeOf(context).width * 0.40
                : MediaQuery.sizeOf(context).width,
            color: JHGColors.primaryBlack,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: height * 0.060,
                ),
                const Text(
                  Constants.reportAnIssue,
                  style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: JHGColors.primary,
                      fontFamily: Constants.kFontFamilySS3),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: height * 0.050,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: height * 0.025,
                      ),
                      const Text(
                        Constants.spottedABugOr,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontFamily: Constants.kFontFamilySS3),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      JHGTextFormField(
                        maxLines: 3,
                        controller: descCntrlr,
                        label: Constants.describeYourIssue,
                      ),
                      SizedBox(
                        height: height * 0.020,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Transform.scale(
                            scale: 1.1,
                            child: ListenableBuilder(
                                listenable: controller.isChecked,
                                builder: (context, _) {
                                  return Checkbox.adaptive(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: controller.isChecked.value,
                                    activeColor: JHGColors.primary,
                                    onChanged: (value) {
                                      controller.isChecked.value = value!;
                                    },
                                  );
                                }),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              '${Constants.iUnderstandThisPage} ${getIt<SplashController>().appName}',
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: Constants.kFontFamilySS3),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.040,
                      ),
                      ListenableBuilder(
                        listenable: controller.isChecked,
                        builder: (context, _) => JHGPrimaryBtn(
                          onPressed: controller.isChecked.value
                              ? () async {
                                  controller
                                      .submitBugReport(descCntrlr.text)
                                      .then(
                                    (value) {
                                      if (value) {
                                        descCntrlr.clear();
                                      }
                                    },
                                  );
                                }
                              : null,
                          label: Constants.submit,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    descCntrlr.dispose();
    super.dispose();
  }
}
