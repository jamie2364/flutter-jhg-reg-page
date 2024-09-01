import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/user/user_controller.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/utils/url/urls.dart';

class AccountCheckScreen extends StatefulWidget {
  const AccountCheckScreen({super.key});

  @override
  State<AccountCheckScreen> createState() => _AccountCheckScreenState();
}

class _AccountCheckScreenState extends State<AccountCheckScreen> {
  late UserController controller;
  bool tryAgain = false;

  @override
  void initState() {
    super.initState();
    controller = getIt<UserController>();
    _checkUserAccount();
  }

  Future<void> _checkUserAccount() async {
    await controller.checkUserAccount(context);
    setState(() {
      tryAgain = controller.tryAgain;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JHGBody(
        padding: Utils.customPadding(context),
        body: tryAgain
            ? Center(
                child: JHGPrimaryBtn(
                  label: Constants.tryAgain,
                  onPressed: () {
                    tryAgain = false;
                    setState(() {});
                    _checkUserAccount();
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    Constants.pleaseWait,
                    style: JHGTextStyles.smlabelStyle,
                  ),
                  Text(
                    '${Constants.weAreChecking} ${Urls.base.isEqual(Urls.evoloUrl) ? Constants.evolo : Constants.musictools}',
                    style: JHGTextStyles.btnLabelStyle.copyWith(
                      color: JHGColors.greyText,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
      ),
    );
  }
}
