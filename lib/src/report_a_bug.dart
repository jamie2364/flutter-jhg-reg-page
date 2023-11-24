import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BugReportPage(),
    );
  }
}

class BugReportPage extends StatefulWidget {
  @override
  _BugReportPageState createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  bool _isChecked = false;
  String _issueDescription = '';

  final dio = Dio();
  final reportBugURL =
      'https://www.jamieharrisonguitar.com/wp-json/custom/v1/report';

  Future<void> submitBugReport(String name, String email, String issue,
      String device, String application) async {
    try {
      final Map<String, dynamic> requestData = {
        'name': name,
        'email': email,
        'issue': issue,
        'device': device,
        'application': application,
      };

      final Response response = await dio.post(
        reportBugURL,
        data: requestData,
      );

      if (response.statusCode == 200) {
        // Successful API call
        // You can handle the response here if needed
      } else {
        // Handle error cases
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Debug log for errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        backgroundColor: AppColor.primaryBlack,
        iconTheme: IconThemeData(
          color: AppColor.primaryWhite,
        ),
      ),
      body: Center(
        child: Container(
          color: AppColor.primaryBlack,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Report a Bug',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryRed,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 28.0),
                Text(
                  'Spotted a bug or issue in the app? Please let us know so we can get it sorted immediately.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 32.0),
                Container(
                  height: 200.0,
                  child: TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Describe your issue',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _issueDescription = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  child: Row(
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
                          'I understand this page is only related to technical issues of YourAppName',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isChecked
                      ? () {
                          final name =
                              'test'; //insert the users name here, taken from the logged in info of the user
                          final email =
                              'test@test.com'; //insert the users email here, taken from the logged in info of the user
                          final issue = _issueDescription;
                          final device =
                              'test'; ////insert the users device here, if possible
                          final application =
                              'jhg_app'; //insert the appName variable here

                          submitBugReport(
                              name, email, issue, device, application);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    primary:
                        _isChecked ? AppColor.primaryRed : AppColor.greyPrimary,
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
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
        ),
      ),
    );
  }
}
