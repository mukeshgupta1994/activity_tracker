// ignore_for_file: use_build_context_synchronously

import 'package:activity_tracker/components/data_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';

class CustomTimeSelectorWidget extends StatelessWidget {
  const CustomTimeSelectorWidget({
    super.key,
    required this.title,
    required this.time,
    required this.onSelected,
    this.lastDate,
    this.firstDate,
  });
  final String title;
  final DateTime time;
  final void Function(DateTime?)? onSelected;
  final DateTime? lastDate;
  final DateTime? firstDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final pickedTime = await AppUtils.customTimePicker(
          context,
          time: time,
          datePickerMode: CupertinoDatePickerMode.time,
          lastDate: lastDate,
          firstDate: firstDate,
        );
        if (pickedTime == null) return;
        if (onSelected == null) return;
        if (lastDate != null) {
          if (pickedTime.isAfter(lastDate ?? DateTime.now())) {
            AppUtils.showSnackBar(
              context: context,
              message: 'Selected time is invalid....',
              color: AppColors.colorRed,
            );
            return;
          }
        }
        onSelected!.call(pickedTime);
      },
      child: Container(
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
                data: AppUtils.formatDateTimeToTimeString(time),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.colorAccent,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.defaultMargin,
                horizontal: AppDimensions.defaultMargin,
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
