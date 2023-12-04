import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:reg_page/reg_page.dart';
import 'constant.dart';
import 'colors.dart';

class BugReportPage extends StatefulWidget {
  const BugReportPage(
      {super.key,
        required this.device,
        required this.appName,});

  final String device ;
  final String appName;
  //
  @override
  _BugReportPageState createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  bool _isChecked = false;
  TextEditingController issueController = TextEditingController();



  Future<void> submitBugReport(String name, String email, String issue,
      String device, String application) async {

    final token = await LocalDB.getBearerToken; 

    final dio = Dio(BaseOptions(headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",}));

    try {
      loaderDialog(context);
      final Map<String, dynamic> requestData = {
        'name': name,
        'email': email,
        'issue': issue,
        'device': device,
        'application': application,
      };

      final Response response = await dio.post(
        Constant.reportBugUrl,
        data: requestData,
      );

      print('Response : $response');

      if (response.statusCode == 200) {
        Navigator.pop(context);

        setState(() {
          issueController.clear();
          _isChecked = false;
        });
        showToast(context: context, message: "Your message has been succesfully delivered", isError: false);
        // Successful API call
        // You can handle the response here if needed
      } else {
        Navigator.pop(context);
        // Handle error cases
        print('Error: ${response.statusCode}');
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
      appBar: AppBar(
        title: null,
        backgroundColor: AppColor.primaryBlack,
        iconTheme: IconThemeData(
          color: AppColor.primaryWhite,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: AppColor.primaryBlack,
          child: Padding(
            padding:
            EdgeInsets.symmetric(
                horizontal: width*0.060
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: height*0.060,),
                Text(
                  'Report an Issue', // Changed headline
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryRed,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: height*0.050,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: height*0.025,),
                      const Text(
                        'Spotted a bug or issue in the app? Please let us know so we can get it sorted immediately.',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: height*0.025,),
                      Container(
                        height:
                        height*0.15,
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
                      SizedBox(height: height*0.020,),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _isChecked,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                           Flexible(
                            child: Text(
                              'I understand this page is only related to technical issues of ${widget.appName}', //Need to extract YourAppName from the current app name
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height*0.040,),
                      ElevatedButton(
                        onPressed: _isChecked
                            ? () async {

                             final userName = await  LocalDB.getUserName;
                             final userEmail = await  LocalDB.getUserEmail;
                                final name = userName ?? "user"; //insert the user's name here, taken from the logged in info of the user
                                final email = userEmail ?? "email"; //insert the user's email here, taken from the logged in info of the user
                                final issue = issueController.text;
                                final device = widget.device; ////insert the user's device here, if possible
                                final application = widget.appName; //insert the appName variable here
                                submitBugReport(
                                    name, email, issue, device, application);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          primary: _isChecked
                              ? AppColor.primaryRed
                              : AppColor.greyPrimary,
                          padding: EdgeInsets.symmetric(
                            vertical:height*0.020,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
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
}
