import 'package:activity_tracker/components/customizable_text_field.dart';
import 'package:activity_tracker/components/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';

class DataSectionEditable extends StatefulWidget {
  const DataSectionEditable({
    super.key,
    required this.title,
    required this.data,
    this.iconData,
    this.isIconRequired = true,
    this.titleColor = AppColors.colorGrey,
    this.dataColor,
    this.dataMaxLines,
    this.isDataSelectable = false,
    this.onEditComplete,
  });

  final String title;
  final String data;
  final IconData? iconData;
  final bool isIconRequired;
  final Color titleColor;
  final Color? dataColor;
  final int? dataMaxLines;
  final bool isDataSelectable;
  final void Function(String)? onEditComplete;

  @override
  State<DataSectionEditable> createState() => _DataSectionEditableState();
}

class _DataSectionEditableState extends State<DataSectionEditable> {
  late String _data;
  @override
  void initState() {
    super.initState();
    _data = widget.data;
    widget.onEditComplete?.call(_data);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final editedData = await _onEditTap(context, title: widget.title);
        if (editedData != null) {
          widget.onEditComplete?.call(editedData);
          _data = editedData;
          setState(() {});
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.colorYellow,
          borderRadius: BorderRadius.circular(
            AppDimensions.smallBorderRadius,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.mediumMargin,
          horizontal: AppDimensions.mediumMargin,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.isIconRequired,
              child: Row(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 2.0),
                      Icon(
                        widget.iconData ?? Icons.arrow_circle_right_outlined,
                        size: 12.0,
                        color: widget.titleColor,
                      ),
                    ],
                  ),
                  AppUtils.horizontalSpacer(width: AppDimensions.smallMargin),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: widget.titleColor,
                        textBaseline: TextBaseline.alphabetic),
                  ),
                  widget.isDataSelectable
                      ? SelectableText(
                          widget.data,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.dataColor,
                          ),
                          maxLines: widget.dataMaxLines,
                        )
                      : Text(
                          _data,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.dataColor,
                          ),
                          maxLines: widget.dataMaxLines,
                        ),
                ],
              ),
            ),
            Icon(
              Icons.edit_outlined,
              color: AppColors.colorBlack,
              size: 25,
            )
          ],
        ),
      ),
    );
  }

  Future<String?> _onEditTap(BuildContext context,
      {required String title}) async {
    return await AppUtils.showClosableDialog<String?>(
      context,
      child: EditAlertWidget(data: _data, title: title),
    );
  }
}

class EditAlertWidget extends StatefulWidget {
  const EditAlertWidget({
    super.key,
    required this.data,
    required this.title,
    this.isInputTypeFexible = false,
  });

  final String data;
  final String? title;
  final bool isInputTypeFexible;
  static final _formKey = GlobalKey<FormState>();

  @override
  State<EditAlertWidget> createState() => _EditAlertWidgetState();
}

class _EditAlertWidgetState extends State<EditAlertWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: EditAlertWidget._formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? 'Edit Data',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            AppUtils.verticalSpacer(height: AppDimensions.bigMargin),
            CustomizableTextField(
              textEditingController: _controller,
              hintText: 'Enter ${widget.title}',
              inputType: widget.isInputTypeFexible
                  ? TextInputType.text
                  : AppUtils.identifyStringType(widget.data) == String
                      ? TextInputType.text
                      : TextInputType.number,
              inputformatters: widget.isInputTypeFexible
                  ? null
                  : AppUtils.identifyStringType(widget.data) == String
                      ? []
                      : [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter valid ${widget.title}';
                }
                if (value.length > 4000) {
                  return '${widget.title} cannot be greater than 4000 characters';
                }
                return null;
              },
            ),
            AppUtils.verticalSpacer(height: AppDimensions.bigMargin),
            LoadingButton(
              buttonText: 'Update',
              padding: AppDimensions.smallMargin,
              borderRadius: AppDimensions.smallBorderRadius,
              onTap: () {
                if (!EditAlertWidget._formKey.currentState!.validate()) return;
                Navigator.pop(context, _controller.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
