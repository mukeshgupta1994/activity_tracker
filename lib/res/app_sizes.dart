import 'package:flutter/material.dart';

class AppSizes {
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 40.0;
  static const double spaceXXXL = 60.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 30.0;
  static const double radiusFull = 999.0;

  static List<BoxShadow> shadowLow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];

  static List<BoxShadow> shadowMedium(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static const double fontXS = 12.0;
  static const double fontS = 14.0;
  static const double fontM = 16.0;
  static const double fontL = 20.0;
  static const double fontXL = 26.0;
  static const double fontXXL = 32.0;
}

extension AppSpacingExtension on num {
  Widget get vSpace => SizedBox(height: toDouble());
  Widget get hSpace => SizedBox(width: toDouble());
}
