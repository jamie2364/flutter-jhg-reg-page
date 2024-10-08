import 'package:reg_page/src/utils/res/constants.dart';

class Plan {
  final int index;
  final String label;
  final String description;
  final String tiledesc;
  final String price;
  Plan(
    this.index,
    this.label,
    this.description,
    this.tiledesc,
    this.price,
  );

  static List<Plan> getPlans(String monthlyPrice, String yearlyPrice) {
    return [
      Plan(0, Constants.freeWithAds, Constants.freeWithAdsSubtitle,
          'Enjoy app with ads', '0'),
      Plan(
          1,
          Constants.monthlyPlan,
          'Subscribe for $monthlyPrice per month, renewing automatically. You may cancel at any time. Upon cancellation, your subscription will remain active until the end of the current billing period. This subscription grants you unlimited access to all app features and full customer support.',
          '$monthlyPrice per month.',
          monthlyPrice),
      Plan(
          2,
          Constants.annualPlan,
          'Get a free trial for 7 days, after which you will be automatically charged $yearlyPrice. You will then be charged this amount each year, starting from your initial payment. You may cancel your subscription at any time during the trial period, or anytime after. Upon cancellation, your subscription will remain active for one year after your previous payment. For this price, you will receive unlimited and unrestricted access to all features of the app, the ability to report issues within the app, and full customer support.',
          '$yearlyPrice/yr after 1 week free.',
          yearlyPrice),
    ];
  }
}
