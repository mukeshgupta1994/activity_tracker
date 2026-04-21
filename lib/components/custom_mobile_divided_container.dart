import 'package:activity_tracker/components/cut_divider.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:flutter/material.dart';

class CustomMobileDividedContainer extends StatelessWidget {
  const CustomMobileDividedContainer({
    super.key,
    this.children = const [],
  });
  final List<Widget> children;

  Column get _divider => Column(
        children: [
          AppUtils.verticalSpacer(),
          const CutDivider(),
          AppUtils.verticalSpacer(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
        borderRadius: BorderRadius.circular(
          AppDimensions.smallBorderRadius,
        ),
      ),
      child: Column(
        children: _buildWidgetsWithDividers(children),
      ),
    );
  }

  List<Widget> _buildWidgetsWithDividers(List<Widget> children) {
    if (children.isEmpty) return [];
    List<Widget> widgetsWithDividers = [];

    widgetsWithDividers
        .add(AppUtils.verticalSpacer(height: AppDimensions.bigMargin));

    for (int i = 0; i < children.length; i++) {
      widgetsWithDividers.add(
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumMargin,
          ),
          child: children[i],
        ),
      );
      if (i < children.length - 1) {
        widgetsWithDividers.add(_divider);
      }
    }

    widgetsWithDividers
        .add(AppUtils.verticalSpacer(height: AppDimensions.bigMargin));

    return widgetsWithDividers;
  }
}
