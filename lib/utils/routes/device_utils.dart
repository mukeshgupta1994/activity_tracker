import 'package:activity_tracker/res/app_dimension.dart';
import 'package:flutter/material.dart';

class DeviceUtils {
  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static Size getScreenSize(BuildContext context) =>
      MediaQuery.of(context).size;

  static double getScaledSize(BuildContext context, double scale) =>
      scale *
      (MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.height);

  static double getScaledWidth(BuildContext context, double scale) =>
      scale * MediaQuery.of(context).size.width;

  static double getScaledHeight(BuildContext context, double scale) =>
      scale * MediaQuery.of(context).size.height;

  static DeviceType getDeviceType(BuildContext context) {
    final constraints = MediaQuery.of(context).size.width;
    if (constraints <= AppDimensions.mobileWidth) {
      return DeviceType.mobile;
    }
    if (constraints > AppDimensions.mobileWidth &&
        constraints <= AppDimensions.tabletWidth) {
      return DeviceType.tablet;
    }

    return DeviceType.desktop;
  }
}

enum DeviceType { mobile, tablet, desktop }
