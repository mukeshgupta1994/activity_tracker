import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.textEditingController,
    this.hintText,
    this.maxLength,
    this.validator,
    this.hintStyle,
    this.inputType,
    this.textStyle,
    this.maxLines,
    this.prefixIconData,
    this.borderRadius = AppDimensions.smallBorderRadius,
    this.obscureText = false,
    this.onChanged,
    this.themeColor = AppColors.colorPrimary,
    this.iconColor = AppColors.colorPrimary,
  });
  final TextEditingController? textEditingController;
  final String? hintText;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextInputType? inputType;
  final int? maxLines;
  final IconData? prefixIconData;
  final double borderRadius;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Color themeColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      validator: validator,
      style: textStyle ?? TextStyle(color: themeColor),
      controller: textEditingController,
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          borderSide: BorderSide(
            color: themeColor,
            width: 1.0,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          borderSide: BorderSide(
            color: themeColor,
            width: 2.0,
          ),
        ),
        fillColor: AppColors.colorWhite,
        filled: true,
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: prefixIconData == null
            ? null
            : Icon(
                prefixIconData,
                color: iconColor,
              ),
      ),
    );
  }
}
