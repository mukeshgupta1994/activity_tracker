// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:activity_tracker/res/app_colors.dart';
// import 'package:activity_tracker/res/app_dimension.dart';
// import 'package:activity_tracker/utils/app_utils.dart';

// typedef DateChangedCallback = Function(DateTime time);

// class KTextFormField extends StatefulWidget {
//   const KTextFormField(
//       {super.key,
//       this.hintText = "",
//       this.hintTextStyle,
//       this.controller,
//       this.padding,
//       this.multiline = false,
//       this.minimumLines = 1,
//       this.maxlength,
//       this.isPasswordField = false,
//       this.isCalenderField = false,
//       this.isNumber = false,
//       this.isEnabled = true,
//       this.isReadOnly = false,
//       this.background,
//       this.focusNode,
//       this.validator,
//       this.onChanged,
//       this.textCapitalization = TextCapitalization.none,
//       this.textInputAction,
//       this.radius = 0,
//       this.onDateTimeSelected,
//       this.initialDateTime,
//       this.maxTime,
//       this.minTime,
//       this.minuteInterval,
//       this.onTap,
//       this.textStyle,
//       this.inputFormatters,
//       this.maximumLines,
//       this.lebel});

//   final String hintText;
//   final TextStyle? hintTextStyle;
//   final TextStyle? textStyle;
//   final TextEditingController? controller;
//   final bool multiline;
//   final int minimumLines;
//   final int? maximumLines;
//   final bool isPasswordField;
//   final bool isCalenderField;
//   final bool isNumber;
//   final bool isEnabled;
//   final bool isReadOnly;
//   final int? maxlength;
//   final Color? background;
//   final FocusNode? focusNode;
//   final double? padding;
//   final DateChangedCallback? onDateTimeSelected;
//   final FormFieldValidator? validator;
//   final ValueChanged<String>? onChanged;
//   final TextCapitalization textCapitalization;
//   final TextInputAction? textInputAction;
//   final double radius;
//   final DateTime? initialDateTime;
//   final DateTime? minTime;
//   final DateTime? maxTime;
//   final int? minuteInterval;
//   final GestureTapCallback? onTap;
//   final List<TextInputFormatter>? inputFormatters;
//   final String? lebel;

//   @override
//   State<KTextFormField> createState() => _KTextFormFieldState();
// }

// class _KTextFormFieldState extends State<KTextFormField> {
//   bool isVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         if (widget.lebel != null)
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               widget.lebel ?? '',
//               style: context.textTheme.labelMedium,
//             ),
//           ),
//         Container(
//           decoration: BoxDecoration(
//               color: widget.background ?? context.theme.highlightColor,
//               borderRadius: BorderRadius.circular(widget.radius)),

//           //  height: 30,
//           child: TextFormField(
//             onTap: () async {
//               if (widget.isCalenderField) {
//                 DateTime? selectedDate = await selectDateAndTime(context,
//                     widget.initialDateTime, widget.minTime, widget.maxTime);
//                 if (selectedDate != null) {
//                   if (widget.onDateTimeSelected != null) {
//                     widget.onDateTimeSelected!(selectedDate);
//                   }
//                   widget.controller?.text =
//                       DateFormat('dd/MM/yyyy  hh:mm aa').format(selectedDate);
//                 }
//               } else {
//                 if (widget.onTap != null) {
//                   widget.onTap!();
//                 }
//               }
//             },
//             enabled: widget.isEnabled,
//             readOnly: widget.isReadOnly,
//             keyboardType: widget.isNumber
//                 ? const TextInputType.numberWithOptions(
//                     signed: true, decimal: true)
//                 : null,
//             maxLines: widget.multiline ? widget.maximumLines : 1,
//             minLines: widget.multiline ? widget.minimumLines : 1,
//             obscureText: widget.isPasswordField ? !isVisible : false,
//             controller: widget.controller,
//             validator: widget.validator,
//             focusNode: widget.focusNode,
//             onChanged: widget.onChanged,
//             style: widget.textStyle ?? context.textTheme.titleMedium,
//             textCapitalization: widget.textCapitalization,
//             textInputAction: widget.textInputAction,
//             inputFormatters: widget.isNumber
//                 ? widget.inputFormatters ??
//                     [
//                       LengthLimitingTextInputFormatter(widget.maxlength),
//                       FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                     ]
//                 : widget.inputFormatters,
//             decoration: InputDecoration(
//               hintText: widget.hintText,
//               isDense: true,
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: widget.padding ?? 10,
//                 vertical: widget.padding ?? 10,
//               ),
//               hintStyle: widget.hintTextStyle ?? context.textTheme.bodyLarge,
//               border: InputBorder.none,
//               suffixIcon: widget.isPasswordField
//                   ? GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isVisible = !isVisible;
//                         });
//                       },
//                       child: isVisible
//                           ? Assets.icons.visibilityOn.image()
//                           : Assets.icons.visibilityOff.image(),
//                     )
//                   : null,
//               suffixIconConstraints: const BoxConstraints(
//                 maxHeight: 10,
//                 minWidth: 10,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// Future<DateTime?> selectDateAndTime(BuildContext context,
//     DateTime? initialDateTime, DateTime? minTime, maxTime) async {
//   DateTime? selectedDate;

//   final DateTime? pickedDate = await showDatePicker(
//     context: context,
//     initialDate: initialDateTime ?? DateTime.now(),
//     firstDate: minTime ?? DateTime(1900),
//     lastDate: maxTime ?? DateTime(2101),
//   );
//   if (pickedDate != null) {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay(
//           hour: initialDateTime?.hour ?? 0,
//           minute: initialDateTime?.minute ?? 0),
//     );
//     if (pickedTime != null) {
//       selectedDate = DateTime(
//         pickedDate.year,
//         pickedDate.month,
//         pickedDate.day,
//         pickedTime.hour,
//         pickedTime.minute,
//       );
//     }
//   }
//   return selectedDate;
// }
