import 'package:activity_tracker/components/confirmation_button.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  const ConfirmationDialogWidget(
      {super.key,
      required this.title,
      required this.message,
      required this.animationController,
      this.confirmButtonText,
      this.cancelButtonText,
      this.icon,
      this.assetName,
      this.color});

  final Icon? icon;
  final String? assetName;
  final String title;
  final String message;
  final Color? color;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final bool hasCancel =
        cancelButtonText != null && cancelButtonText!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.bigMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                if (assetName != null)
                  Positioned(
                    top: -60,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(assetName ?? ''),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.bigMargin,
                    20 + AppDimensions.smallMargin,
                    AppDimensions.bigMargin,
                    AppDimensions.smallMargin,
                  ),
                  child: Column(
                    children: [
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20.0,
                                ),
                      ),
                      const SizedBox(height: AppDimensions.bigMargin),
                      Text(
                        message,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.colorBlack,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      AppUtils.verticalSpacer(
                          height: AppDimensions.veryBigMargin),
                      hasCancel
                          ? Row(
                              children: [
                                Expanded(
                                  child: ConfirmationButton(
                                    buttonText: cancelButtonText!,
                                    buttonColor: AppColors.colorPrimary,
                                    isFilled: true,
                                    onTap: () {
                                      context.pop(false);
                                    },
                                  ),
                                ),
                                AppUtils.horizontalSpacer(
                                    width: AppDimensions.mediumMargin),
                                Expanded(
                                  child: AnimatedBuilder(
                                    animation: animationController,
                                    builder: (context, child) {
                                      return ConfirmationButton(
                                        buttonText: confirmButtonText ?? "",
                                        buttonColor: AppColors.colorPrimary,
                                        isFilled: true,
                                        isLoading: true,
                                        progressValue:
                                            animationController.value,
                                        onTap: () {
                                          context.pop(true);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: AnimatedBuilder(
                                animation: animationController,
                                builder: (context, child) {
                                  return ConfirmationButton(
                                    buttonText: confirmButtonText ?? "OK",
                                    buttonColor: AppColors.colorPrimary,
                                    isFilled: true,
                                    isLoading: true,
                                    progressValue: animationController.value,
                                    onTap: () => Navigator.pop(context, true),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimensions.smallMargin),
              ],
            )
          ],
        ),
      ),
    );
  }
}
