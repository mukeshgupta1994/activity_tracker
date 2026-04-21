import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 1)
class UserData {
  @HiveField(0)
  final String? userID;

  @HiveField(1)
  String? userName;

  @HiveField(2)
  String? mobileNo;

  @HiveField(3)
  String? emailId;

  @HiveField(4)
  String? officeCode;

  @HiveField(5)
  String? designation;

  UserData({
    this.userID,
    this.userName,
    this.mobileNo,
    this.emailId,
    this.officeCode,
    this.designation,
  });
}
