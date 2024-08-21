// import 'package:flutter/material.dart';
// import 'package:flutter_jhg_elements/jhg_elements.dart';
// import 'package:get/get.dart';
// import 'package:reg_page/src/auth/controllers/user_controller.dart';

// class LoginScreen extends GetView<UserController> {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.sizeOf(context).height;
//     return Scaffold(
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.only(
//           bottom: 50,
//           top: 25,
//           left: kBodyHrPadding,
//           right: kBodyHrPadding,
//         ),
//         child: JHGPrimaryBtn(
//           label: 'Login',
//           onPressed: () => controller.loginUser(),
//         ),
//       ),
//       body: JHGBody(
//         bodyAppBar: const JHGAppBar(
//           centerWidget: Text('Login'),
//         ),
//         body: SizedBox(
//           height: double.infinity,
//           width: double.infinity,
//           child: Form(
//             key: controller.loginFormKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // Text(
//                   //   'Register',
//                   //   style: JHGTextStyles.largeTextStyle,
//                   // ),
//                   SizedBox(height: height * .28),
//                   // const Spacer(),
//                   JHGTextFormField(
//                     label: 'User Name',
//                     controller: controller.userNameC,
//                     spacing: const EdgeInsets.only(bottom: 20),
//                   ),

//                   JHGTextFormField(
//                     label: 'Password',
//                     isPasswordField: true,
//                     controller: controller.passC,
//                     validator: (String? val) {
//                       return null;
//                     },
//                     spacing: const EdgeInsets.only(bottom: 20),
//                   ),

//                   // const Spacer(),
//                   // SizedBox(height: height * .2),

//                   SizedBox(
//                     height: height * .03,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
