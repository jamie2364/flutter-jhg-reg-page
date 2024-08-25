import 'package:flutter/material.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constant.dart';
import 'package:reg_page/src/models/platform_model.dart';

class PlatformSelectionWidget extends StatelessWidget {
  final PlatformModel model;
  final String selectedPlatform;
  final Function(PlatformModel) onTap;

  const PlatformSelectionWidget(
      {super.key,
      required this.model,
      required this.selectedPlatform,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onTap(model),
      child: Container(
        height: height * 0.06,
        width: width * 0.85,
        margin: EdgeInsets.only(top: height * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedPlatform == model.platform
                ? AppColor.primaryRed
                : AppColor.primaryWhite,
            width: 1.5,
          ),
          color: AppColor.primaryBlack,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.050,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.platform,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColor.greySecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: Constant.kFontFamilySS3),
                  ),
                  Container(
                    height: height * 0.027,
                    width: height * 0.027,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedPlatform == model.platform
                          ? AppColor.primaryRed
                          : AppColor.primaryBlack,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedPlatform == model.platform
                            ? AppColor.primaryRed
                            : AppColor.primaryWhite,
                        width: 1.8,
                      ),
                    ),
                    child: Icon(
                      Icons.done,
                      color: AppColor.primaryBlack,
                      size: width * 0.04,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
