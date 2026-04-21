import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:readmore/readmore.dart';

class DataSection extends StatelessWidget {
  const DataSection({
    super.key,
    required this.title,
    required this.data,
    this.iconData,
    this.isIconRequired = true,
    this.titleColor = AppColors.colorGrey,
    this.dataColor,
    this.dataMaxLines,
    this.isDataSelectable = false,
  });

  final String title;
  final String data;
  final IconData? iconData;
  final bool isIconRequired;
  final Color titleColor;
  final Color? dataColor;
  final int? dataMaxLines;
  final bool isDataSelectable;

  @override
  Widget build(BuildContext context) {
    if (data.trim().isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isIconRequired,
          child: Row(
            children: [
              Column(
                children: [
                  const SizedBox(height: 2.0),
                  Icon(
                    iconData ?? Icons.arrow_circle_right_outlined,
                    size: 12.0,
                    color: titleColor,
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
                title,
                style: TextStyle(
                    fontSize: 12.0,
                    color: titleColor,
                    textBaseline: TextBaseline.alphabetic),
              ),
              isDataSelectable
                  ? SelectableText(
                      data,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: dataColor,
                      ),
                      maxLines: dataMaxLines,
                    )
                  : ReadMoreText(
                      data,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: dataColor,
                      ),
                      trimMode: TrimMode.Line,
                      trimLines: dataMaxLines ?? 3,
                      colorClickableText: AppColors.colorPrimary,
                      trimCollapsedText: 'View more',
                      trimExpandedText: '  View less',
                      moreStyle: const TextStyle(
                        fontSize: 10.0,
                        color: AppColors.colorGreen,
                      ),
                      lessStyle: const TextStyle(
                        fontSize: 10.0,
                        color: AppColors.colorGreen,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
