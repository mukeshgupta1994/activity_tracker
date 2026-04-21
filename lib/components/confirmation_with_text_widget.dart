import 'package:activity_tracker/components/confirmation_button.dart';
import 'package:activity_tracker/components/customizable_text_field.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:flutter/material.dart';

class ConfirmationWithTextWidget extends StatefulWidget {
  const ConfirmationWithTextWidget({
    super.key,
    required this.title,
    required this.message,
    required this.confirmButtonText,
    required this.cancelButtonText,
    this.isStrictValidate = false,
    this.textEditingController,
    this.hintText = 'Remarks',
  });
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final bool isStrictValidate;
  final TextEditingController? textEditingController;
  final String hintText;

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<ConfirmationWithTextWidget> createState() =>
      _ConfirmationWithTextWidgetState();
}

class _ConfirmationWithTextWidgetState
    extends State<ConfirmationWithTextWidget> {
  @override
  void initState() {
    super.initState();
    widget.textEditingController?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: ConfirmationWithTextWidget._formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.bigMargin,
              AppDimensions.defaultMargin,
              AppDimensions.bigMargin,
              AppDimensions.bigMargin,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.colorBlack,
                        fontWeight: FontWeight.w900,
                        fontSize: 17.0,
                      ),
                ),
                const SizedBox(
                  height: AppDimensions.mediumMargin,
                ),
                Text(
                  widget.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.colorBlack,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: AppDimensions.bigMargin,
                ),
                CustomizableTextField(
                  textEditingController: widget.textEditingController,
                  maxLines: 2,
                  textStyle: const TextStyle(color: AppColors.colorBlack),
                  hintText: widget.hintText,
                  borderRadius: AppDimensions.smallBorderRadius,
                  validator: (value) {
                    final String text = value ?? '';
                    if (widget.isStrictValidate) {
                      if (text.isEmpty) {
                        return '*${widget.hintText} Mandatory';
                      }
                    }
                    if (text.isNotEmpty && text.length < 3) {
                      return 'Text length too short';
                    }
                    return null;
                  },
                ),
                AppUtils.verticalSpacer(height: AppDimensions.bigMargin),
                Row(
                  children: [
                    Expanded(
                      child: ConfirmationButton(
                        buttonText: widget.cancelButtonText,
                        buttonColor: AppColors.colorPrimary,
                        onTap: () => Navigator.pop(context, false),
                      ),
                    ),
                    AppUtils.horizontalSpacer(
                      width: AppDimensions.mediumMargin,
                    ),
                    Expanded(
                      child: ConfirmationButton(
                        buttonText: widget.confirmButtonText,
                        buttonColor: AppColors.colorPrimary,
                        isFilled: true,
                        onTap: () {
                          if (!ConfirmationWithTextWidget._formKey.currentState!
                              .validate()) return;
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
