import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';


class CutDivider extends StatelessWidget {
  const CutDivider({super.key, this.isShowCut = true});
  final bool isShowCut;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(visible: isShowCut, child: const CutContainer(isLeft: true)),
        Expanded(
          child: Divider(
            height: 2,
            color: AppColors.colorGrey.withOpacity(0.2),
          ),
        ),
        Visibility(visible: isShowCut, child: const CutContainer()),
      ],
    );
  }
}

class CutContainer extends StatelessWidget {
  const CutContainer({super.key, this.isLeft = false});
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 5,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: isLeft
            ? const BorderRadius.only(
                topRight: Radius.circular(
                  AppDimensions.mediumBorderRadius,
                ),
                bottomRight: Radius.circular(
                  AppDimensions.mediumBorderRadius,
                ),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(
                  AppDimensions.mediumBorderRadius,
                ),
                bottomLeft: Radius.circular(
                  AppDimensions.mediumBorderRadius,
                ),
              ),
      ),
    );
  }
}
