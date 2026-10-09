import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:reg_page/src/utils/navigate/nav.dart';
import 'package:reg_page/src/utils/res/constants.dart';

/// Suite toast. A slim, dark rounded pill with a small status-coloured icon —
/// NOT the old full-width bright-green/red bar. Success reads as a quiet
/// confirmation (green check); errors use the coral accent. Keeps the old
/// signature so every caller is unaffected.
showToast(
    {BuildContext? context, required String message, bool isError = false}) {
  context = context ?? Nav.key.currentState!.context;
  final width = MediaQuery.of(context).size.width;
  final accent = isError ? JHGColors.primary : JHGColors.primaryGreen;

  final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    padding: EdgeInsets.zero,
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.horizontal,
    content: Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width < 520 ? width : 460),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: const Color(0xFF242424),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isError
                      ? Icons.error_outline_rounded
                      : Icons.check_rounded,
                  color: accent,
                  size: 17,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: JHGColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: Constants.kFontFamilySS3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ));
}

showErrorToast(String message) => showToast(
    context: Nav.key.currentState!.context, message: message, isError: true);
