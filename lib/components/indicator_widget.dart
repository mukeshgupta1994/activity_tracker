import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({
    super.key,
    required this.text,
    this.color = AppColors.colorGreen,
    this.fontSize = 10.0,
    this.borderThickness = 1.0,
    this.isFilled = false,
  });

  final String text;
  final Color color;
  final double? fontSize;
  final double borderThickness;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.verySmallMargin,
        horizontal: AppDimensions.mediumMargin,
      ),
      decoration: BoxDecoration(
        color: isFilled ? color : color.withOpacity(0.1),
        border: Border.all(
          color: color,
          width: borderThickness,
        ),
        borderRadius: BorderRadius.circular(
          AppDimensions.verySmallBorderRadius,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isFilled ? AppColors.colorWhite : color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
