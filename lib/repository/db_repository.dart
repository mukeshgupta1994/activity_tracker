import 'package:activity_tracker/data/local/db/themedata/db_box_key.dart';
import 'package:activity_tracker/data/local/db/themedata/db_boxes.dart';
import 'package:activity_tracker/data/local/db/themedata/db_client.dart';
import 'package:activity_tracker/models/user_data/user_data.dart';
import 'package:hive/hive.dart';

class DbRepository {
  final DbClient dbClient;

  DbRepository(this.dbClient);

  Box getBox(String boxType) => dbClient.getBox(boxType);

  void saveUserData({
    required UserData? userData,
  }) =>
      dbClient.saveData(
        boxName: DataBoxes.userBox,
        boxkey: DataBoxKey.userDataKey,
        data: userData,
      );

  UserData? get userData => dbClient.getData(
        boxName: DataBoxes.userBox,
        boxkey: DataBoxKey.userDataKey,
      ) as UserData?;

  void clearAllData() {
    dbClient.clearDataFromBox(
      boxName: DataBoxes.userBox,
    );
  }
}
