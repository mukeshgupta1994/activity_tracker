import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/routes/device_utils.dart';
import 'package:flutter/material.dart';


class ClosableDialogWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onCloseTap;
  final bool showClosed;

  const ClosableDialogWidget({
    super.key,
    required this.child,
    this.onCloseTap,
    this.showClosed = true,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      width: DeviceUtils.getDeviceType(context) == DeviceType.mobile
          ? null
          : DeviceUtils.getScaledSize(context, 0.6),
      margin: EdgeInsets.only(left: 10.0, right: 0.0),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 13.0, right: 8.0),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.bigMargin,
              vertical: AppDimensions.bigMargin,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
            child: child,
          ),
          if (showClosed)
            Positioned(
              right: 0.0,
              child: GestureDetector(
                onTap: onCloseTap ?? () => Navigator.of(context).pop(),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: AppColors.colorAccent,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.smallBorderRadius)),
                      child: Center(
                          child: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 18,
                      ))),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
