import 'package:hive/hive.dart';

class DbClient {
  Box getBox(String boxType) {
    return Hive.box(boxType);
  }

  void saveData({
    required dynamic data,
    required String boxName,
    required String boxkey,
  }) =>
      getBox(boxName).put(boxkey, data);

  dynamic getData({
    required String boxName,
    required String boxkey,
  }) =>
      getBox(boxName).get(boxkey);

  void deleteData({
    required String boxName,
    required String boxkey,
  }) =>
      getBox(boxName).delete(boxkey);

  void clearDataFromBox({
    required String boxName,
  }) =>
      getBox(boxName).clear();
}
