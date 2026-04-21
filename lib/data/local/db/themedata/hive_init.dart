import 'package:activity_tracker/data/local/db/themedata/db_boxes.dart';
import 'package:activity_tracker/models/user_data/user_data.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> hiveInit() async {
  await Hive.initFlutter();
  //Hive.registerAdapter(UserDetailsAdapter());
  Hive.registerAdapter(UserDataAdapter());
  await Hive.openBox(DataBoxes.userBox);
}
