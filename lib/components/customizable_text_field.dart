import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';


class CustomizableTextField extends StatefulWidget {
  const CustomizableTextField({
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
    this.inputformatters,
    this.altHintText,
    this.isRequiredField = false,
    this.readOnly = false,
    this.enabled,
    this.autovalidateMode,
    this.contentPadding,
    this.isDense,
    this.onChanged,
    this.isHintOnly = false,
    this.prefixIconSize,
    this.suffixIcon,
    this.hasCounterText = false,
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
  final List<TextInputFormatter>? inputformatters;
  final String? altHintText;
  final bool isRequiredField;
  final bool readOnly;
  final bool? enabled;
  final AutovalidateMode? autovalidateMode;
  final EdgeInsetsGeometry? contentPadding;
  final bool? isDense;
  final void Function(String)? onChanged;
  final bool isHintOnly;
  final double? prefixIconSize;
  final Widget? suffixIcon;
  final bool hasCounterText;

  @override
  State<CustomizableTextField> createState() => _CustomizableTextFieldState();
}

class _CustomizableTextFieldState extends State<CustomizableTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      keyboardType: widget.inputType,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      readOnly: widget.readOnly,
      style: widget.textStyle ??
          const TextStyle(
            color: AppColors.colorPrimary,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
      controller: widget.textEditingController,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      inputFormatters: widget.inputformatters,
      decoration: InputDecoration(
        isDense: widget.isDense,
        counterText: widget.hasCounterText ? null : '',
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 10.0,
            ),
        label: widget.isHintOnly ? null : _labelPrimary(),
        hintText: widget.isHintOnly ? widget.hintText : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.colorGrey,
            width: 1.0,
          ),
        ),
        counterStyle: const TextStyle(
          color: AppColors.colorGrey,
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.colorPrimary,
            width: 2.0,
          ),
        ),
        errorStyle: const TextStyle(
          fontSize: 10.0,
          fontStyle: FontStyle.italic,
        ),
        fillColor: AppColors.colorWhite,
        filled: true,
        prefixIcon: widget.prefixIconData == null
            ? null
            : Icon(
                widget.prefixIconData,
                color: AppColors.colorPrimary,
                size: widget.prefixIconSize,
              ),
        suffixIcon: widget.suffixIcon,
      ),
      onChanged: (value) {
        _isTextEmpty = value.trim().isEmpty;
        setState(() {});
        widget.onChanged?.call(value);
      },
    );
  }

  Widget _labelPrimary() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: AppColors.colorGrey,
          fontSize: 12.0,
        ),
        children: [
          TextSpan(
            text: widget.hintText,
            style: const TextStyle(
              color: AppColors.colorGrey,
              fontSize: 12.0,
            ),
          ),
          TextSpan(
            text: _isTextEmpty
                ? widget.altHintText == null
                    ? ''
                    : _isFocused
                        ? ''
                        : ' ${widget.altHintText}'
                : '',
            style: const TextStyle(
              color: AppColors.colorGrey,
            ),
          ),
          TextSpan(
            text: widget.isRequiredField ? ' *' : '',
            style: const TextStyle(
              color: AppColors.colorRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
