// import 'package:activity_tracker/data/local/db/themedata/db_box_key.dart';
// import 'package:activity_tracker/data/local/db/themedata/db_boxes.dart';
// import 'package:activity_tracker/data/local/db/themedata/db_client.dart';

// class ThemePreferences {
//   final DbClient dbClient;

//   ThemePreferences(this.dbClient);

//   Future<void> setTheme(bool isDarkMode) async {
//     dbClient.saveData(
//       data: isDarkMode,
//       boxName: DataBoxes.themeDataBox,
//       boxkey: DataBoxKey.themeDataKey,
//     );
//   }

//   Future<bool> getTheme() async {
//     final theme = dbClient.getData(
//       boxName: DataBoxes.themeDataBox,
//       boxkey: DataBoxKey.themeDataKey,
//     );
//     return theme ?? false;
//   }
// }
