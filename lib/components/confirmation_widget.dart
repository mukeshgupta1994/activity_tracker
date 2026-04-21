import 'package:activity_tracker/components/confirmation_button.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:flutter/material.dart';
class ConfirmationWidget extends StatelessWidget {
  const ConfirmationWidget({
    super.key,
    required this.title,
    required this.message,
    required this.confirmButtonText,
    required this.cancelButtonText,
    this.isConfirmationPrimary = false,
  });
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final bool isConfirmationPrimary;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.bigMargin,
            AppDimensions.defaultMargin,
            AppDimensions.bigMargin,
            AppDimensions.bigMargin,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.colorBlack,
                      fontWeight: FontWeight.w900,
                      fontSize: 17.0,
                    ),
              ),
              const SizedBox(
                height: AppDimensions.bigMargin,
              ),
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.colorBlack,
                      fontSize: 15.0,
                    ),
              ),
              AppUtils.verticalSpacer(height: AppDimensions.bigMargin),
              Row(
                children: [
                  Expanded(
                    child: ConfirmationButton(
                      buttonText: cancelButtonText,
                      buttonColor: AppColors.colorPrimaryGradientEnd,
                      isFilled: isConfirmationPrimary ? false : true,
                      onTap: () => Navigator.pop(context, false),
                    ),
                  ),
                  AppUtils.horizontalSpacer(
                    width: AppDimensions.mediumMargin,
                  ),
                  Expanded(
                    child: ConfirmationButton(
                      buttonText: confirmButtonText,
                      buttonColor: AppColors.colorPrimaryGradientEnd,
                      onTap: () => Navigator.pop(context, true),
                      isFilled: isConfirmationPrimary ? true : false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
