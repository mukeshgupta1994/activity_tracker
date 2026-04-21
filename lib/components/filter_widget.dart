import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    super.key,
    this.count,
    this.onTap,
  });

  final int? count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return count == null
        ? _filterWidgetBody(onTap, count)
        : Badge.count(
            count: count ?? 0,
            child: _filterWidgetBody(onTap, count),
          );
  }

  InkWell _filterWidgetBody(VoidCallback? onTap, int? count) => InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0),
            borderRadius: BorderRadius.circular(
              AppDimensions.smallBorderRadius,
            ),
            color: count == null ? null : AppColors.colorAccent,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.defaultMargin,
              vertical: AppDimensions.smallMargin),
          child: Row(
            children: [
              Text(
                'Filter',
                style: const TextStyle(fontSize: 15.0),
              ),
              AppUtils.horizontalSpacer(width: AppDimensions.smallMargin),
              Icon(Icons.filter_list, size: 18.0),
            ],
          ),
        ),
      );
}
