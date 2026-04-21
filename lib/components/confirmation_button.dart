// confirmation_button.dart
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:flutter/material.dart';

class ConfirmationButton extends StatelessWidget {
  const ConfirmationButton({
    super.key,
    required this.buttonText,
    required this.buttonColor,
    this.isFilled = false,
    this.onTap,
    this.textColor = AppColors.colorWhite,
    this.isLoading = false,
    this.progressValue = 0.0,
  });

  final String buttonText;
  final Color buttonColor;
  final bool isFilled;
  final VoidCallback? onTap;
  final Color textColor;
  final bool isLoading;
  final double progressValue;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isLoading
        ? AppColors.colorPrimary
        : (isFilled ? buttonColor : AppColors.colorWhite);

    final Color effectiveTextColor = isFilled ? textColor : buttonColor;

    return InkWell(
      onTap: isLoading ? onTap : onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.smallBorderRadius),
          border: Border.all(
            color: buttonColor,
          ),
          color: backgroundColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isLoading)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 104, 138, 196),
                      borderRadius: BorderRadius.circular(
                          AppDimensions.smallBorderRadius),
                    ),
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(
                          AppDimensions.smallBorderRadius),
                      value: progressValue,
                      color: isLoading
                          ? const Color.fromARGB(255, 186, 209, 234)
                          : Colors.white,
                      backgroundColor: AppColors.colorPrimary,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.mediumMargin),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: effectiveTextColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
