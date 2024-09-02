import 'package:reg_page/src/utils/res/constants.dart';

class Plan {
  final int index;
  final String label;
  final String description;
  final String price;
  Plan(this.index, this.label, this.description, this.price);

  static List<Plan> getPlans(String monthlyPrice, String yearlyPrice) {
    return [
      Plan(0, Constants.freeWithAds, Constants.freeWithAdsSubtitle, '0'),
      Plan(
          1,
          Constants.monthlyPlan,
          '$monthlyPrice ${Constants.perMonth}, renews automatically',
          monthlyPrice),
      Plan(
          2,
          Constants.annualPlan,
          '${Constants.oneWeekFree}$yearlyPrice ${Constants.perYear}',
          yearlyPrice),
    ];
  }
}
