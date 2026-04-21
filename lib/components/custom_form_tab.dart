import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:flutter/material.dart';

class CustomFormTab<T> extends StatefulWidget {
  const CustomFormTab({
    super.key,
    required this.list,
    required this.displayList,
    this.onSelected,
    this.fillColor = AppColors.colorPrimary,
    this.textColor = AppColors.colorWhite,
  });

  final List<T> list;
  final List<String> displayList;
  final Function(String)? onSelected;
  final Color fillColor;
  final Color textColor;

  @override
  State<CustomFormTab> createState() => _CustomFormTabState<T>();
}

class _CustomFormTabState<T> extends State<CustomFormTab> {
  late T _selectedTab;
  @override
  void initState() {
    super.initState();
    _selectedTab = widget.list.elementAt(0);
    if (widget.list.isEmpty) return;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return const SizedBox.shrink();
    }
    if (widget.displayList.isEmpty) {
      return const SizedBox.shrink();
    }
    if (widget.list.length != widget.displayList.length) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.list.length,
        (index) {
          final e = widget.list.elementAt(index);
          final displayText = widget.displayList.elementAt(index);
          return GestureDetector(
            onTap: () {
              _selectedTab = e;
              setState(() {});
              widget.onSelected!(e);
            },
            child: Container(
              decoration: BoxDecoration(
                color: _selectedTab != e ? null : widget.fillColor,
                borderRadius: BorderRadius.circular(
                  AppDimensions.smallBorderRadius,
                ),
                border: Border.all(
                  color: AppColors.colorGrey,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.bigMargin,
                vertical: AppDimensions.defaultMargin,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: AppDimensions.smallMargin,
              ),
              child: Text(
                displayText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: _selectedTab != e ? null : FontWeight.w700,
                      color: _selectedTab != e
                          ? AppColors.colorBlack
                          : widget.textColor,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
