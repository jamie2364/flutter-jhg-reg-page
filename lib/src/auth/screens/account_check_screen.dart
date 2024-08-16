import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:get/get.dart';
import 'package:reg_page/src/auth/controllers/user_controller.dart';
import 'package:reg_page/src/utils/utils.dart';

class AccountCheckScreen extends StatefulWidget {
  const AccountCheckScreen({super.key});

  @override
  State<AccountCheckScreen> createState() => _AccountCheckScreenState();
}

class _AccountCheckScreenState extends State<AccountCheckScreen> {
  late UserController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.find<UserController>()..checkUserAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JHGBody(
          padding: Utils.customPadding(context),
          body: Obx(
            () => controller.tryAgain.value
                ? Center(
                    child: JHGPrimaryBtn(
                      label: 'Try Again',
                      onPressed: () {
                        controller.checkUserAccount();
                      },
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Please wait',
                        style: JHGTextStyles.smlabelStyle,
                      ),
                      Text(
                        'We are checking your account on evolo',
                        style: JHGTextStyles.btnLabelStyle.copyWith(
                            color: JHGColors.greyText,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()),
                    ],
                  ),
          )),
    );
  }
}