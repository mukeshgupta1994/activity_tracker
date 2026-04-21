import 'package:activity_tracker/components/action_button.dart';
import 'package:activity_tracker/components/data_section.dart';
import 'package:activity_tracker/components/icon_action_button.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:flutter/material.dart';

class CommonDataSelector extends StatelessWidget {
  const CommonDataSelector({
    super.key,
    required this.data,
    required this.title,
    this.onTap,
    this.isIcon = false,
    this.buttonText = 'Change',
  });
  final String title;
  final String data;
  final VoidCallback? onTap;
  final bool isIcon;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      /* margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.mediumMargin,
      ), */
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.mediumMargin,
        horizontal: AppDimensions.mediumMargin,
      ),
      decoration: BoxDecoration(
        color: AppColors.colorYellow,
        borderRadius: BorderRadius.circular(
          AppDimensions.smallBorderRadius,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: DataSection(
              title: title,
              data: data,
              iconData: Icons.timelapse,
            ),
          ),
          !isIcon
              ? ActionButton(
                  text: buttonText,
                  onTap: onTap,
                )
              : IconActionButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                  ),
                  onTap: onTap),
        ],
      ),
    );
  }
}
