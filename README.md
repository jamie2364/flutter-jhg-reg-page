<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

You can access all registration screen
Splash screen
Welcome screen
Authentication screen

include Local DB, Loader, inApp purchase, Toast


## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

REG PAGE


// add dependency to pubspec.yaml
// path will be the path of the directory

reg_page:
path: /Users/user/Desktop/Development/GitlabRepo/reg_page

// To use reg page library first import reg_page

import 'package:reg_page/reg_page.dart';


//======================================

You can access local db class

Store end date of timer,
LocalDB.storeEndDate(String value);

Get end date of timer,
LocalDB.getEndDate(String value);

To get user Name 
LocalDB.getUserName();  

Clear local db;
LocalDB.clearLocalDB();
   
 
//======================================

Loading
To use loader you can pass just context
loaderDialog(BuildContext context)

//======================================
Toast
// pass context, message , and true or false

showToast(context: context, message: message, isError: isError)


//======================================
Splash screen

To use splash screen just

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return
MaterialApp(
title: 'YOUR APP NAME ',
theme: ThemeData(
colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
useMaterial3: true,
),
// Use splash screen like this
// pass  monthly and yearly id
// pass your hame screen as a function
home:  SplashScreen(
yearlySubscriptionId: “id of the yearly plan”,
monthlySubscriptionId: “id of the monthly plan”,
nextPage: ()=> const HomeScreen(),),
);
//);
}
}

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

ADDING THE APP NAME 

In the Reg Page, there are several places that use the name of the app as a variable. Therefore we need to define the app name in each app. 

appVersion: To get the app you have to install a package "package_info_plus: latest version"

1: Instance of the package  

PackageInfo packageInfo = PackageInfo(
appName: '',
packageName: '',
version: '',
buildNumber: '',
buildSignature: '',
installerStore: '',
);

// Get value form the package
2: Future<void> _initPackageInfo() async {
final info = await PackageInfo.fromPlatform();
setState(() {
packageInfo = info;
});
}
 
3: packageInfo.version


appName: We need to also define the apps name in three places (Please note that this will not be the same in every app and you may need to adjust based on how you have structured your app)

1)        In the main.dart file like this:

 home:  SplashScreen(
          yearlySubscriptionId: AppConstant.yearlySubscriptionId,
          monthlySubscriptionId: AppConstant.monthlySubscriptionId,
          appName: AppConstant.appName,
          appVersion: packageInfo.version ,
          nextPage: ()=> const HomeScreen(),),

2) In the setting_screen.dart file, like this: 

                    onPressed: () async {
                      await LocalDB.clearLocalDB();
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return Welcome(
                          yearlySubscriptionId:
                              AppConstant.yearlySubscriptionId,
                          monthlySubscriptionId:
                              AppConstant.monthlySubscriptionId,
                          appName: AppConstant.appName,
                          nextPage: () => const HomeScreen(),
                        );
                      }), (route) => false);
                    },

3) In the app_constant.dart file, like this:

static const String appName = 'JHG Rhythm Master';





## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.



