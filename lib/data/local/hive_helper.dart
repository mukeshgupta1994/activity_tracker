import 'package:activity_tracker/data/local/db/themedata/db_box_key.dart';
import 'package:activity_tracker/data/local/db/themedata/db_boxes.dart';
import 'package:activity_tracker/data/local/db/themedata/db_client.dart';
import 'package:activity_tracker/models/user_data/user_data.dart';

class HiveHelper {
  static UserData? get userData => DbClient().getData(
        boxName: DataBoxes.userBox,
        boxkey: DataBoxKey.userDataKey,
      ) as UserData?;

  static String get userId => userData?.userID ?? '';
  //'10009717';
  //userData?.userID ?? ''; //'10010620'
  static String get userName => userData?.userName ?? '';
  static String get mobileNo => userData?.mobileNo ?? '';
  static String get emailID => userData?.emailId ?? '';
  static String get officeCode => userData?.officeCode ?? '';
  static bool get isLoggedIn =>
      userData?.userID != null && userData?.userName != null;
}
