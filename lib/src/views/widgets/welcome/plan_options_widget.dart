import 'package:flutter/material.dart';
import 'package:reg_page/reg_page.dart';
import 'package:reg_page/src/controllers/splash/splash_controller.dart';
import 'package:reg_page/src/models/plan_options.dart';
import 'package:reg_page/src/utils/dialogs/subscription_info_popup.dart';
import 'package:reg_page/src/utils/res/colors.dart';
import 'package:reg_page/src/utils/res/constants.dart';
import 'package:reg_page/src/utils/utils.dart';

class PlanOptionsWidget extends StatefulWidget {
  final Function(int) onPlanSelect;
  final List<Plan> plans;
  final int selectedPlan;

  const PlanOptionsWidget({
    Key? key,
    required this.onPlanSelect,
    required this.selectedPlan,
    required this.plans,
  }) : super(key: key);

  @override
  State<PlanOptionsWidget> createState() => _PlanOptionsWidgetState();
}

class _PlanOptionsWidgetState extends State<PlanOptionsWidget> {
  late int selectedPlan;

  @override
  void initState() {
    super.initState();
    selectedPlan = widget.selectedPlan;
  }

  void onPlanSelect(int planIndex) {
    setState(() {
      selectedPlan = planIndex;
    });
    widget.onPlanSelect(planIndex);
  }

  @override
  Widget build(BuildContext context) {
    final height = Utils.height(context);
    return Column(
      children: List.generate(
        widget.plans.length,
        (index) {
          final e = widget.plans[index];
          return PlanOption(
            label: e.label,
            description: e.description,
            selectedPlan: selectedPlan,
            planIndex: e.index,
            onPlanSelect: onPlanSelect,
            yearlyPrice: e.price,
            featuresList: getIt<SplashController>().featuresList,
            bottomSpace: index != 2
                ? height > 650
                    ? height * 0.02
                    : height * 0.01
                : 0,
          );
        },
      ),
    );
  }
}

class PlanOption extends StatelessWidget {
  final String label;
  final String description;
  final int selectedPlan;
  final int planIndex;
  final Function(int) onPlanSelect;
  final String yearlyPrice;
  final List<String> featuresList;
  final double bottomSpace;
  const PlanOption({
    super.key,
    required this.label,
    this.bottomSpace = 0,
    required this.description,
    required this.selectedPlan,
    required this.planIndex,
    required this.onPlanSelect,
    required this.yearlyPrice,
    required this.featuresList,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => onPlanSelect(planIndex),
      child: Container(
        height: selectedPlan == planIndex
            ? height > 640
                ? height * 0.13
                : height > 470
                    ? height * 0.18
                    : height > 410
                        ? height * 0.20
                        : height * 0.25
            : height > 440
                ? height * 0.06
                : height * 0.07,
        width: width * 0.85,
        margin: EdgeInsets.only(bottom: bottomSpace),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedPlan == planIndex
                ? AppColor.primaryRed
                : AppColor.primaryWhite,
            width: 1.5,
          ),
          color: AppColor.primaryBlack,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.050),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.primaryWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: Constants.kFontFamilySS3,
                    ),
                  ),
                  Container(
                    height: height * 0.027,
                    width: height * 0.027,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedPlan == planIndex
                          ? AppColor.primaryRed
                          : AppColor.primaryBlack,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedPlan == planIndex
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
                  ),
                ],
              ),
              if (selectedPlan == planIndex)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColor.secondaryWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: Constants.kFontFamilySS3,
                      ),
                    ),
                    Divider(color: AppColor.secondaryWhite),
                    GestureDetector(
                      onTap: () {
                        showWeeklySaveInfoDialog(
                          context,
                          yearlyPrice,
                          featuresList,
                          label: label,
                          desc: description,
                        );
                      },
                      child: Text(
                        Constants.weeklySave,
                        style: TextStyle(
                          color: AppColor.primaryRed,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: Constants.kFontFamilySS3,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
