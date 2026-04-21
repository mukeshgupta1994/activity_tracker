import 'package:activity_tracker/components/action_button.dart';
import 'package:activity_tracker/components/data_section.dart';
import 'package:activity_tracker/components/icon_action_button.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:flutter/material.dart';

class CommonDateSelector extends StatelessWidget {
  const CommonDateSelector({
    super.key,
    required this.date,
    required this.title,
    this.onSelected,
    this.firstDate,
    this.lastDate,
    this.isIcon = false,
    this.selectableDayPredicate,
  });
  final String title;
  final DateTime date;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime?)? onSelected;
  final bool isIcon;
  final bool Function(DateTime)? selectableDayPredicate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final pickedDate = await AppUtils.customDatePicker(
          context,
          time: date,
          firstDate: firstDate ?? DateTime(1994),
          lastDate: lastDate ?? DateTime(2101),
          selectableDayPredicate: selectableDayPredicate,
        );

        // Extra validation - agar picked date selectable nahi hai to ignore karo
        if (pickedDate != null && selectableDayPredicate != null) {
          if (!selectableDayPredicate!(pickedDate)) {
            // Show warning
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('This date is not available'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        }

        if (onSelected != null) {
          onSelected!.call(pickedDate);
        }
      },
      child: Container(
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
                data:"",
                // displayFormattedDate(date.toString()),
                iconData: Icons.timelapse,
              ),
            ),
            !isIcon
                ? const ActionButton(
                    text: 'Change',
                  )
                : const IconActionButton(
                    icon: Icon(
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
