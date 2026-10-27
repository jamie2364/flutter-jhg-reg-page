import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/src/utils/res/constants.dart';

/// Plan "More Info" sheet. Uses the suite's canonical frosted-glass dialog
/// ([JHGFrostedDialog] + [showJHGBlurDialog]) so it matches every other dialog
/// across the apps — translucent blurred panel, coral glow, close (X) and a
/// pinned "Done" button. The body scrolls internally when the feature list is
/// long, so nothing is ever clipped.
void showPlanInfoDialog(
    BuildContext context, String? price, List<String> featuresList,
    {String? label, String? desc}) {
  final list = label.toString().contains('Free Plan')
      ? ['Limited use of app', 'Enjoy free features with ads']
      : featuresList;

  final body = desc ??
      "Get a free trial for 7 days, after which you will be automatically charged $price. You will then be charged this amount each year, starting from your initial payment. You may cancel your subscription at any time during the trial period, or anytime after. Upon cancellation, your subscription will remain active for one year after your previous payment. For this price, you will receive unlimited and unrestricted access to all features the app, the ability to report issues within the app, and full customer support.";

  showJHGBlurDialog(
    context: context,
    builder: (ctx) => JHGFrostedDialog(
      title: label ?? "Annual Subscription",
      onClose: () => Navigator.of(ctx).pop(),
      primaryLabel: Constants.done,
      onPrimary: () => Navigator.of(ctx).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          JHGDialogText(body),
          const SizedBox(height: 22),
          ...list.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    LucideIcons.circleCheck300,
                    color: JHGColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: JHGColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: Constants.kFontFamilySS3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
