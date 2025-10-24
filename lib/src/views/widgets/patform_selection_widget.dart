import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/src/models/platform_model.dart';
import 'package:reg_page/src/utils/res/constants.dart';

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
        width: width > 768 ? 500 : width * 0.85,
        margin: EdgeInsets.only(top: height * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedPlatform == model.platform
                ? JHGColors.primary
                : JHGColors.white,
            width: 1.5,
          ),
          color: JHGColors.primaryBlack,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
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
                        color: JHGColors.greySecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: Constants.kFontFamilySS3),
                  ),
                  Container(
                    height: height * 0.027,
                    width: height * 0.027,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedPlatform == model.platform
                          ? JHGColors.primary
                          : JHGColors.primaryBlack,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedPlatform == model.platform
                            ? JHGColors.primary
                            : JHGColors.white,
                        width: 1.8,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        LucideIcons.squareCheckBig300,
                        color: JHGColors.primaryBlack,
                        size: height * 0.02,
                      ),
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
