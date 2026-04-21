import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.buttonText,
    this.onTap,
    this.isLoading = false,
    this.buttonColor = AppColors.colorPrimary,
    this.borderRadius = AppDimensions.bigBorderRadius,
    this.padding = AppDimensions.bigMargin,
    this.textColor = AppColors.colorWhite,
    this.iconData = Icons.chevron_right,
    this.elevation = 0.0,
  });
  final String buttonText;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color buttonColor;
  final double borderRadius;
  final double padding;
  final Color textColor;
  final IconData iconData;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: WidgetStatePropertyAll(elevation),
        backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      onPressed: onTap,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: isLoading
            ? Center(
                child: SpinKitThreeBounce(
                  color: AppColors.colorWhite,
                  size: AppDimensions.defaultSize,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: AppDimensions.smallMargin,
                  ),
                  Icon(
                    iconData,
                    color: textColor,
                    size: AppDimensions.smallSize + 5,
                  ),
                ],
              ),
      ),
    );
  }
}
