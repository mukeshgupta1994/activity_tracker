import 'package:activity_tracker/components/data_section.dart';
import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/app_utils.dart';

class DynamicDataSectionRowEditable extends StatelessWidget {
  final List<Map<String, String>> dataList;
  final double verticalSpacing;

  const DynamicDataSectionRowEditable({
    required this.dataList,
    this.verticalSpacing = AppDimensions.defaultMargin,
    super.key,
  });

  @override

  /// Builds a widget that displays the given data in a column format,
  /// where each row contains grouped data items. Each data item is
  /// displayed using the [DataSection] widget. A vertical spacer is
  /// added between rows, except for the last row, with spacing
  /// defined by [verticalSpacing].
  ///
  /// Filters out empty data items before displaying them.
  ///
  /// Returns a [Column] widget containing the structured data.
  Widget build(BuildContext context) {
    final filteredData = _getFilteredData(dataList);

    return Column(
      children: [
        for (var i = 0; i < filteredData.length; i++) ...[
          Row(
            children: filteredData[i].map((dataItem) {
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: DataSection(
                        title: dataItem['title']!,
                        data: dataItem['data']!,
                      ),
                    ),
                    AppUtils.horizontalSpacer(),
                  ],
                ),
              );
            }).toList(),
          ),
          if (i != filteredData.length - 1)
            AppUtils.verticalSpacer(height: verticalSpacing),
        ],
      ],
    );
  }

  /// Filter out empty data items from the given [dataList] and group
  /// the remaining items into rows of 2 items each.
  ///
  /// This is used to layout the data items in a grid pattern.
  ///
  List<List<Map<String, String>>> _getFilteredData(
      List<Map<String, String>> dataList) {
    final List<Map<String, String>> validData = [];
    for (var item in dataList) {
      if (item['data'] != null && item['data']!.isNotEmpty) {
        validData.add(item);
      }
    }

    return _groupIntoRows(validData, 2);
  }

  /// Given a list of data items, group them into rows where each row has
  /// [itemsPerRow] number of items.
  ///
  /// If the list length is not a multiple of [itemsPerRow], the last row
  /// may have fewer items.
  ///
  /// This is used to layout the data items in a grid pattern.
  List<List<Map<String, String>>> _groupIntoRows(
      List<Map<String, String>> dataList, int itemsPerRow) {
    final List<List<Map<String, String>>> rows = [];
    for (int i = 0; i < dataList.length; i += itemsPerRow) {
      rows.add(dataList.sublist(
          i,
          i + itemsPerRow > dataList.length
              ? dataList.length
              : i + itemsPerRow));
    }
    return rows;
  }
}
