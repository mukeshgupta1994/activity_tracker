// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 1;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      userID: fields[0] as String?,
      userName: fields[1] as String?,
      mobileNo: fields[2] as String?,
      emailId: fields[3] as String?,
      officeCode: fields[4] as String?,
      designation: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userID)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.mobileNo)
      ..writeByte(3)
      ..write(obj.emailId)
      ..writeByte(4)
      ..write(obj.officeCode)
      ..writeByte(5)
      ..write(obj.designation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
