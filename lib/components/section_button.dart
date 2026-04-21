import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:flutter/material.dart';

class SectionButton extends StatelessWidget {
  const SectionButton({
    super.key,
    required this.text,
    required this.iconData,
    this.buttonColor = AppColors.colorAccent,
    this.isLeftSide = true,
    this.textColor,
    this.iconColor,
    this.isInverse = false,
    this.onTap,
  });

  final String text;
  final IconData iconData;
  final Color buttonColor;
  final bool isLeftSide;
  final Color? textColor;
  final Color? iconColor;
  final bool isInverse;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppDimensions.mediumMargin,
        left: isLeftSide ? AppDimensions.mediumMargin : 0,
        right: isLeftSide ? 0 : AppDimensions.mediumMargin,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.mediumMargin,
            horizontal: AppDimensions.defaultMargin,
          ),
          decoration: BoxDecoration(
            color: isInverse ? null : buttonColor,
            borderRadius: BorderRadius.circular(
              AppDimensions.smallBorderRadius,
            ),
            border: Border.all(
              color: buttonColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isInverse ? buttonColor : textColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppUtils.horizontalSpacer(width: AppDimensions.smallMargin),
              Icon(
                iconData,
                size: 12.0,
                color: isInverse ? buttonColor : iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
