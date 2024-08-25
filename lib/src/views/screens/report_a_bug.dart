import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/repositories/repo.dart';

import '../../utils/res/colors.dart';
import '../../utils/res/constant.dart';

class BugReportPage extends StatefulWidget {
  const BugReportPage({
    super.key,
    required this.device,
    required this.appName,
    this.isLogout,
    this.yearlySubscriptionId,
    this.monthlySubscriptionId,
    this.appVersion,
    this.featuresList,
    this.nextPage,
  });

  final String device;

  final String appName;
  final bool? isLogout;
  final String? yearlySubscriptionId;
  final String? monthlySubscriptionId;
  final String? appVersion;
  final List<String>? featuresList;
  final Widget Function()? nextPage;

  @override
  // ignore: library_private_types_in_public_api
  _BugReportPageState createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  bool _isChecked = false;
  TextEditingController issueController = TextEditingController();

  Future<void> submitBugReport(String name, String email, String issue,
      String device, String application) async {
    try {
      loaderDialog(context);
      final Map<String, dynamic> requestData = {
        'name': name,
        'email': email,
        'issue': issue,
        'device': device,
        'application': application,
      };

      final response = await Repo().postBug(requestData);
      print('Response : $response');

      if (response != null) {
        Navigator.pop(context);

        setState(() {
          issueController.clear();
          _isChecked = false;
        });
        showToast(
            context: context,
            message: "Your message has been succesfully delivered",
            isError: false);
        // Successful API call
        // You can handle the response here if needed
      } else {
        Navigator.pop(context);
        // Handle error cases
        print('Error: $response');
      }
    } catch (e) {
      Navigator.pop(context);
      // Debug log for errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.primaryBlack,
      appBar: AppBar(
        title: null,
        backgroundColor: AppColor.primaryBlack,
        iconTheme: IconThemeData(
          color: AppColor.primaryWhite,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColor.primaryBlack,
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          alignment: kIsWeb ? Alignment.center : Alignment.topLeft,
          padding: EdgeInsets.symmetric(horizontal: width * 0.060),
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            width: kIsWeb
                ? MediaQuery.sizeOf(context).width * 0.40
                : MediaQuery.sizeOf(context).width,
            color: AppColor.primaryBlack,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: height * 0.060,
                ),
                Text(
                  'Report an Issue', // Changed headline
                  style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryRed,
                      fontFamily: Constant.kFontFamilySS3),
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
                        'Spotted a bug or issue in the app? Please let us know so we can get it sorted immediately.',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontFamily: Constant.kFontFamilySS3),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      SizedBox(
                        height: height * 0.15,
                        child: TextField(
                          controller: issueController,
                          minLines: 3,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Describe your issue',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          // onChanged: (value) {
                          //   setState(() {
                          //     _issueDescription = value;
                          //   });
                          // },
                        ),
                      ),
                      SizedBox(
                        height: height * 0.020,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Transform.scale(
                            scale: 1.1,
                            child: Checkbox.adaptive(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: _isChecked,
                              activeColor: AppColor.primaryRed,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'I understand this page is only related to technical issues of ${widget.appName}',
                              //Need to extract YourAppName from the current app name
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: Constant.kFontFamilySS3),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.040,
                      ),
                      GestureDetector(
                        onTap: _isChecked
                            ? () async {
                                final userName = await LocalDB.getUserName;
                                final userEmail = await LocalDB.getUserEmail;
                                final name = userName ??
                                    "user"; //insert the user's name here, taken from the logged in info of the user
                                final email = userEmail ??
                                    "email"; //insert the user's email here, taken from the logged in info of the user
                                final issue = issueController.text;
                                final device = widget
                                    .device; ////insert the user's device here, if possible
                                final application = widget
                                    .appName; //insert the appName variable here
                                submitBugReport(
                                    name, email, issue, device, application);
                              }
                            : null,
                        child: Container(
                          width: double.infinity,
                          height: height * 0.065,
                          decoration: BoxDecoration(
                              color: _isChecked
                                  ? AppColor.primaryRed
                                  : AppColor.greyPrimary,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: const Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: Constant.kFontFamilySS3),
                            ),
                          ),
                        ),
                      ),
                      widget.isLogout == true
                          ? Center(
                              child: InkWell(
                                onTap: () async {
                                  await LocalDB.clearLocalDB();
                                  //ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Welcome(
                                      yearlySubscriptionId:
                                          widget.yearlySubscriptionId!,
                                      monthlySubscriptionId:
                                          widget.monthlySubscriptionId!,
                                      appVersion: widget.appVersion!,
                                      appName: widget.appName,
                                      featuresList:
                                          widget.featuresList ?? List.empty(),
                                      nextPage: () => widget.nextPage!(),
                                    );
                                  }), (route) => false);
                                },
                                child: Container(
                                  height: height * 0.07,
                                  width: width * 0.8,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColor.primaryRed,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(
                                        color: AppColor.primaryWhite,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: Constant.kFontFamilySS3),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
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
}
