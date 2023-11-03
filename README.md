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

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
