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
      
        await LocalDB.storeEndDate(String value);

Get end date of timer,

        await LocalDB.getEndDate(String value);

To get user Name

        await LocalDB.getUserName();  

Clear local db;

        await LocalDB.clearLocalDB();
   
 
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

* Monthly and  yearly subscription is required 
* Add Your subscription is as a string in Constant or String file
     
      static const String androidYearlySubscriptionId = "android-yearly-subscrition";
      static const String androidMonthlySubscriptionId  =  "android-monthly-subscrition";
      static const String iosYearlySubscriptionId = "ios-yearly-subscrition";
      static const String iosMonthlySubscriptionId  =  "ios-monthly-subscrition";
  
* create a dart file in utils and and these methods

      String monthlySubscription(){
        return  Platform.isAndroid ? AppConstant.androidMonthlySubscriptionId  :  AppConstant.iosMonthlySubscriptionId;
        }
        
        String yearlySubscription(){
        return  Platform.isAndroid ? AppConstant.androidYearlySubscriptionId  :  AppConstant.iosYearlySubscriptionId;
        }


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
         yearlySubscriptionId: yearlySubscription(),
         monthlySubscriptionId: monthlySubscription(),
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

1) In the main.dart file like this:

         home:  SplashScreen(
                  yearlySubscriptionId: yearlySubscription(),
                  monthlySubscriptionId: monthlySubscription(),
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
                           yearlySubscriptionId: yearlySubscription(),
                           monthlySubscriptionId: monthlySubscription(),
                           appName: AppConstant.appName,
                           nextPage: () => const HomeScreen(),
                        );
                      }), (route) => false);
                    },

3) In the app_constant.dart file, like this:

static const String appName = 'JHG Rhythm Master';

// Add report and issue page to your app

  * ADD This code at the top of  setting page

      // BACK ICON  WITH REPORT AN ISSUE TEXT BUTTON

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return const HomeScreen();
                        }));
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.whiteSecondary,
                        size: height * 0.030,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BugReportPage(
                              device: deviceName, 
                              appName: AppConstant.appName,),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 4.0), // Add padding to the right
                            child: Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.redPrimary,
                              size: 16,
                            ),
                          ),
                          Text(
                            'Report an Issue',
                            style: TextStyle(
                              color: AppColors.redPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    // BACK ICON  WITH REPORT AN ISSUE TEXT BUTTON
 
    // we have to pass two parameters
    (1) app name  (2) device

            Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => BugReportPage(
            device: deviceName,
            appName: AppConstant.appName,),
            ),
            );
  IF You want to include logout functionalities in reg page you have to pass these parameters
      
         Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => BugReportPage(
            device: deviceName,
            appName: AppConstant.appName,
            isLogout: true,
            yearlySubscriptionId: yearlySubscription(),
            monthlySubscriptionId: monthlySubscription(),
            appVersion: packageInfo.version,
            //Main screen of the app
            nextPage: () =>  GetStartBoarding(),
            ),),);  

   // for app name just pass your app name 

   // for device you have to add package  device_info_plus:  in pubspec.yaml
   // the in setting page you have to add this code and call the function


        String deviceName = 'Unknown';
        DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        Future<void> getDeviceInfo() async {
        if(Platform.isAndroid){
        final device = await deviceInfoPlugin.androidInfo;
        deviceName = "${device.manufacturer} ${device.model}";
        }else if(Platform.isIOS){
        final device = await deviceInfoPlugin.iosInfo;
        deviceName = device.name;
        }
        }

## Additional information




**Reg_Page’s Working Flow**

### **Splash:**

Here we are showing an animation of the JHG logo and on the back of it we are checking the session of the user and whether the user is logged in or not.

If the user is not logged in then the user will be redirected to the Welcome screen.

If the user is logged in then we are checking the status of the user’s subscription by calling the _jwt-check-subscription_ endpoint if the status is active then the user will be moved to the app otherwise the user will be redirected to the Welcome screen. If user is not connected to the internet, we will refer to the last login and if user logged in and had an active subscription less than 7 days ago then user will be allowed in. After 7 days this cache will automatically clear and user must connect to the internet again to login.

### **Welcome:**

At the welcome screen, the user will buy a subscription plan. Or if the user already has a subscription then the user can login. By pressing the login button user will navigate to the select platform screen.

### **Select Platform:**

From this screen, the user will select a platform that will be used as the API’s base URL for the API call made on the next page to check subscription. On this page we will also get Product IDs from the selected platform with the _product_ids_ endpoint by passing _app_name_ as a parameter and saving them locally. This will return the relevant product ids that the current app are part of. For example, if app is ‘Tuner’ then it will return the product id for the tuner subscription, and bundles that contain that app like an all access pass.

Curl Example to get product IDs of the app:

    curl --location 'https://www.musictools.io/wp-json/jhg-apps/v1/product-ids?app_name=practice-routines'

### **Login**

The user will login using credentials i.e. username and password. After successful login, we will check the user’s subscription on the platform they selected on the previous page by using the _jwt-check-subscription_ endpoint. This endpoint requires the _product_ids_ that we got from the previous step to be sent as parameters. In the response, it will return us the subscription status of the app for that user. If the user has a subscription on any of the returned products (ie. the product says ‘active’) then we will navigate the user to the app, otherwise, it will let the user know that there is no active subscription found for them and the user will have to buy a subscription plan first to use the app.

Curl Example to login:

    curl --location --request POST 'https://www.musictools.io/wp-json/jwt-auth/v1/token?username=usmanmujahid&password=usmanmujahid'

Curl Example to check subscription:

    curl --location 'https://www.musictools.io/wp-json/myplugin/v1/jwt-check-subscription?product_ids=2' \ --header 'Authorization: Bearer token'

### **Account Check:**

At this screen, we will try to login the user into the app through the credentials that the user has used on the reg_page to log in. Here we are assuming that the credentials for the subscription platform and the app platform are the same and we are using he same credentials for both calls.  

- If the user name and password match then the user will be moved to the dashboard screen.
- If the user name matches but the password does not match, then the user will be moved to the login screen.
- If the username and password are not matched then the user will be moved to the register screen.

### Following is the graphical representation of flow

![Flow](https://evolo.app/wp-content/uploads/reg_page_flow/flow.png)
