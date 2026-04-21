import 'package:activity_tracker/res/app_dimension.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= AppDimensions.mobileWidth) return mobile;
        if (constraints.maxWidth > AppDimensions.mobileWidth &&
            constraints.maxWidth <= AppDimensions.tabletWidth) {
          return tablet;
        }
        return desktop;
      },
    );
  }
}
