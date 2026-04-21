import 'package:activity_tracker/res/app_colors.dart';
import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  const Dot({
    super.key,
    this.radius = 8,
    this.color = AppColors.colorPrimary,
  });

  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
