class PlanOptionModel {
  final String label;
  final String description;
  final int planIndex;
  final String yearlyPrice;
  final List<String> featuresList;

  PlanOptionModel({
    required this.label,
    required this.description,
    required this.planIndex,
    required this.yearlyPrice,
    required this.featuresList,
  });
}
