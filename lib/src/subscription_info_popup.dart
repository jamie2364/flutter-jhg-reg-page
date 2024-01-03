import 'package:flutter/material.dart';
import 'colors.dart';

void showWeeklySaveInfoDialog(BuildContext context, String? price) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(top: 100.0), // Adjust the top padding as needed
        child: AlertDialog(
          title: Text(
            "Annual Subscription Info",
            style: TextStyle(
              color: AppColor.secondaryWhite,
              fontSize: 22, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Adjust the font weight as needed
            ),
          ),
          content: Text(
            "Get a free trial for 7 days, after which you will be automatically charged $price. You may cancel at any time during the trial period, or anytime after. Upon cancellation, your subscription will remain active for one year after your previous payment.",
            style: TextStyle(
              color: AppColor.secondaryWhite,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: AppColor.primaryBlack,
          actions: <Widget>[
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(
                  color: AppColor.primaryRed, // Set the text color here
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    },
  );
}
