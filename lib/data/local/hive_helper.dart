// import 'package:activity_tracker/data/local/db/themedata/db_box_key.dart';
// import 'package:activity_tracker/data/local/db/themedata/db_boxes.dart';
// import 'package:activity_tracker/data/local/db/themedata/db_client.dart';
// import 'package:activity_tracker/models/user_data/user_data.dart';

// class HiveHelper {
//   static UserData? get userData => DbClient().getData(
//         boxName: DataBoxes.userBox,
//         boxkey: DataBoxKey.userDataKey,
//       ) as UserData?;

//   static String get userId => userData?.userID ?? '';
//   //'10009717';
//   //userData?.userID ?? ''; //'10010620'
//   static String get userName => userData?.userName ?? '';
//   static String get mobileNo => userData?.mobileNo ?? '';
//   static String get emailID => userData?.emailId ?? '';
//   static String get officeCode => userData?.officeCode ?? '';
//   static bool get isLoggedIn =>
//       userData?.userID != null && userData?.userName != null;
// }
import 'package:activity_tracker/data/local/db/themedata/db_box_key.dart';
import 'package:activity_tracker/data/local/db/themedata/db_boxes.dart';
import 'package:activity_tracker/data/local/db/themedata/db_client.dart';
import 'package:activity_tracker/models/user_data/user_data.dart';
import 'package:hive/hive.dart';

class HiveHelper {
  // ✅ In-memory cache — Hive se baar baar read nahi karna padega
  static UserData? _cachedUser;

  // Pehle cache check karo, phir Hive
  static UserData? get userData {
    if (_cachedUser != null) return _cachedUser;
    try {
      final data = DbClient().getData(
        boxName: DataBoxes.userBox,
        boxkey: DataBoxKey.userDataKey,
      );
      if (data != null) {
        _cachedUser = data as UserData;
      }
      return _cachedUser;
    } catch (_) {
      return null;
    }
  }

  // Login ke baad yeh call karo — data save + cache dono update hoga
  static void saveUserData(UserData user) {
    _cachedUser = user;
    try {
      DbClient().saveData(
        data: user,
        boxName: DataBoxes.userBox,
        boxkey: DataBoxKey.userDataKey,
      );
    } catch (_) {}
  }

  static String get userId => userData?.userID ?? '';
  static String get userName => userData?.userName ?? '';
  static String get mobileNo => userData?.mobileNo ?? '';
  static String get emailID => userData?.emailId ?? '';
  static String get officeCode => userData?.officeCode ?? '';

  // ✅ Cache se padhega — null kabhi nahi aayega mid-session
  static bool get isLoggedIn {
    final id = userData?.userID;
    return id != null && id.trim().isNotEmpty;
  }

  // Logout pe cache + Hive dono clear karo
  static Future<void> clearUserData() async {
    _cachedUser = null;
    try {
      final box = Hive.box(DataBoxes.userBox);
      await box.delete(DataBoxKey.userDataKey);
    } catch (_) {}
  }
}