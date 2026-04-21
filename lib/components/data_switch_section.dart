import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';

class DataSwitchSection extends StatelessWidget {
  const DataSwitchSection({
    super.key,
    required this.title,
    required this.value,
    this.iconData,
    this.isIconRequired = true,
    this.titleColor = AppColors.colorBlack,
    this.dataColor,
    this.onChanged,
  });

  final String title;
  final bool value;
  final IconData? iconData;
  final bool isIconRequired;
  final Color titleColor;
  final Color? dataColor;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isIconRequired,
          child: Row(
            children: [
              Column(
                children: [
                  const SizedBox(height: 2.0),
                  Icon(
                    iconData ?? Icons.arrow_circle_right_outlined,
                    size: 12.0,
                    color: titleColor,
                  ),
                ],
              ),
              AppUtils.horizontalSpacer(width: AppDimensions.smallMargin),
            ],
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.0,
              color: titleColor,
              textBaseline: TextBaseline.alphabetic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          height: 33,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
