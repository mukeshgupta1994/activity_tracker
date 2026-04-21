import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';

class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.icon,
    this.backgroundColor = AppColors.colorAccent,
    this.padding = const EdgeInsets.symmetric(
      vertical: AppDimensions.defaultMargin,
      horizontal: AppDimensions.defaultMargin,
    ),
    this.onTap,
  });

  final Icon icon;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        padding: padding,
        child: icon,
      ),
    );
  }
}
