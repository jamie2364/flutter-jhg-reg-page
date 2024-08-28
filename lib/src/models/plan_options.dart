import 'package:reg_page/src/utils/res/constant.dart';

class Plan {
  final int index;
  final String label;
  final String description;
  final String price;
  Plan(this.index, this.label, this.description, this.price);

  static List<Plan> getPlans(String monthlyPrice, String yearlyPrice) {
    return [
      Plan(0, Constant.freeWithAds, Constant.freeWithAdsSubtitle, '0'),
      Plan(
          1,
          Constant.monthlyPlan,
          '$monthlyPrice ${Constant.perMonth}, renews automatically',
          monthlyPrice),
      Plan(
          2,
          Constant.annualPlan,
          '${Constant.oneWeekFree}$yearlyPrice ${Constant.perYear}',
          yearlyPrice),
    ];
  }
}
