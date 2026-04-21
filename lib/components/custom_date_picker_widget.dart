import 'package:activity_tracker/components/confirmation_button.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDatePickerWidget extends StatefulWidget {
  const CustomDatePickerWidget({
    super.key,
    required this.dateTime,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
  });

  final DateTime dateTime;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime)? selectableDayPredicate;

  @override
  State<CustomDatePickerWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.bigMargin,
        vertical: AppDimensions.bigMargin,
      ),
      child: Column(
        children: [
          const Text(
            'Select Date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          AppUtils.verticalSpacer(),
          TableCalendar(
            availableGestures: AvailableGestures.horizontalSwipe,
            weekendDays: const [
              DateTime.sunday,
            ],
            startingDayOfWeek: StartingDayOfWeek.monday,
            focusedDay: _selectedDay,
            firstDay: widget.firstDate ?? DateTime.utc(2010, 10, 16),
            lastDay: widget.lastDate ?? DateTime.utc(2030, 10, 16),
            enabledDayPredicate: widget.selectableDayPredicate,
            onDaySelected: (selectedDay, focusedDay) {
              if (widget.selectableDayPredicate != null &&
                  !widget.selectableDayPredicate!(selectedDay)) {
                return; // Don't allow selection
              }
              _selectedDay = selectedDay;
              setState(() {});
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: const TextStyle(
                fontSize: 15,
                color: AppColors.colorPrimary,
                fontWeight: FontWeight.bold,
              ),
              headerMargin: const EdgeInsets.all(5),
              leftChevronIcon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorPrimary),
                  color: AppColors.colorAccent,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.chevron_left,
                    color: AppColors.colorPrimary,
                    size: 20,
                  ),
                ),
              ),
              rightChevronIcon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorPrimary),
                  color: AppColors.colorAccent,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.chevron_right,
                    color: AppColors.colorPrimary,
                    size: 20,
                  ),
                ),
              ),
              titleCentered: true,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            headerVisible: true,
            calendarFormat: CalendarFormat.month,
            onPageChanged: (focusedDay) {},
            daysOfWeekHeight: 20.0,
            currentDay: _selectedDay,
            calendarStyle: CalendarStyle(
              disabledTextStyle: TextStyle(
                color: Colors.grey.shade400,
              ),
            ),
          ),
          AppUtils.verticalSpacer(height: AppDimensions.bigMargin),
          Row(
            children: [
              Expanded(
                child: ConfirmationButton(
                  buttonText: 'Cancel',
                  buttonColor: AppColors.colorPrimaryGradientEnd,
                  onTap: () => Navigator.pop(context, null),
                ),
              ),
              AppUtils.horizontalSpacer(),
              Expanded(
                child: ConfirmationButton(
                  buttonText: 'Ok',
                  buttonColor: AppColors.colorPrimaryGradientEnd,
                  onTap: () => Navigator.pop(
                    context,
                    _selectedDay,
                  ),
                  isFilled: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
