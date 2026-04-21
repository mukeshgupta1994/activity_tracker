import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.text,
    this.borderRadius = AppDimensions.smallBorderRadius,
    this.padding = const EdgeInsets.symmetric(
      vertical: AppDimensions.mediumMargin,
      horizontal: AppDimensions.bigMargin,
    ),
    this.color = AppColors.colorAccent,
    this.textStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.onTap,
  });
  final String text;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color color;
  final TextStyle textStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.colorGrey,
              blurRadius: 1.0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: padding,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
