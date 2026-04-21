import 'package:activity_tracker/components/confirmation_button.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';

class CustomDateOrTimePickerWidget extends StatefulWidget {
  const CustomDateOrTimePickerWidget({
    super.key,
    required this.dateTime,
    this.datePickerMode = CupertinoDatePickerMode.date,
    this.firstDate,
    this.lastDate,
  });

  final DateTime dateTime;
  final CupertinoDatePickerMode datePickerMode;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<CustomDateOrTimePickerWidget> createState() =>
      _CustomDateOrTimePickerWidgetState();
}

class _CustomDateOrTimePickerWidgetState
    extends State<CustomDateOrTimePickerWidget> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.bigMargin,
        vertical: AppDimensions.bigMargin,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select ${widget.datePickerMode == CupertinoDatePickerMode.time ? 'Time' : 'Date'}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          AppUtils.verticalSpacer(),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              onDateTimeChanged: (value) {
                _selectedDateTime = value;
              },
              mode: widget.datePickerMode,
              use24hFormat: false,
              initialDateTime: widget.dateTime,
              dateOrder: DatePickerDateOrder.ymd,
              showDayOfWeek:
                  widget.datePickerMode == CupertinoDatePickerMode.date,
              minimumDate: widget.firstDate,
              maximumDate: widget.lastDate,
            ),
          ),
          AppUtils.verticalSpacer(),
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
                  onTap: () => Navigator.pop(context, _selectedDateTime),
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
