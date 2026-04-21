import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';

class CustomTabSeperated extends StatefulWidget {
  const CustomTabSeperated({
    super.key,
    required this.list,
    this.onSelected,
    this.fillColor = AppColors.colorAccent,
    this.textColor = AppColors.colorBlack,
    this.selectedItemCount = 0,
    this.isLoading = false,
  });

  final List<String> list;
  final Function(String)? onSelected;
  final Color fillColor;
  final Color textColor;
  final int selectedItemCount;
  final bool isLoading;

  @override
  State<CustomTabSeperated> createState() => _CustomTabSeperatedState();
}

class _CustomTabSeperatedState extends State<CustomTabSeperated> {
  String _selectedTab = '';
  @override
  void initState() {
    super.initState();
    _selectedTab = widget.list.elementAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widget.list
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(left: AppDimensions.mediumMargin),
              child: GestureDetector(
                onTap: () {
                  _selectedTab = e;
                  setState(() {});
                  widget.onSelected!(e);
                },
                child: Container(
                  decoration: _selectedTab != e
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.smallBorderRadius,
                          ),
                          border: Border.all(color: AppColors.colorGrey),
                        )
                      : BoxDecoration(
                          color: widget.fillColor,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.smallBorderRadius,
                          ),
                        ),
                  padding: EdgeInsets.only(
                    left: AppDimensions.bigMargin,
                    right: _selectedTab == e &&
                            AppUtils.convertToNonNullableBool(
                                widget.selectedItemCount > 0)
                        ? AppDimensions.mediumMargin
                        : AppDimensions.bigMargin,
                    top: AppDimensions.mediumMargin,
                    bottom: AppDimensions.mediumMargin,
                  ),
                  child: Row(
                    children: [
                      Text(
                        e,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight:
                                  _selectedTab != e ? null : FontWeight.w700,
                              color:
                                  _selectedTab != e ? null : widget.textColor,
                              fontSize: 10.0,
                            ),
                      ),
                      Visibility(
                        visible: widget.selectedItemCount > 0 &&
                            _selectedTab == e &&
                            !widget.isLoading,
                        child: Row(
                          children: [
                            AppUtils.horizontalSpacer(
                                width: AppDimensions.smallMargin),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 3.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: AppColors.colorRed,
                              ),
                              child: Text(
                                widget.selectedItemCount > 99
                                    ? '99+'
                                    : widget.selectedItemCount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.colorWhite,
                                      fontSize: 8.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _selectedTab == e && widget.isLoading,
                        child: Row(
                          children: [
                            AppUtils.horizontalSpacer(
                                width: AppDimensions.smallMargin),
                            SizedBox(
                              height: 10.0,
                              width: 10.0,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: AppColors.colorWhite,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
