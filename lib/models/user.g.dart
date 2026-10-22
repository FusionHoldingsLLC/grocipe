// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      accessToken: fields[0] as String,
      tokenType: fields[1] as String,
      refreshToken: fields[2] as String,
      firstName: fields[3] as String,
      lastName: fields[4] as String,
      email: fields[5] as String,
      role: fields[6] as String,
      isVerified: fields[7] as bool,
      subscriptionType: fields[8] as String,
      updatePassword: fields[9] as bool,
      changePassword: fields[10] as bool,
      dateCreated: fields[11] as DateTime,
      dateUpdated: fields[12] as DateTime,
      profilePictureUrl: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.tokenType)
      ..writeByte(2)
      ..write(obj.refreshToken)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.role)
      ..writeByte(7)
      ..write(obj.isVerified)
      ..writeByte(8)
      ..write(obj.subscriptionType)
      ..writeByte(9)
      ..write(obj.updatePassword)
      ..writeByte(10)
      ..write(obj.changePassword)
      ..writeByte(11)
      ..write(obj.dateCreated)
      ..writeByte(12)
      ..write(obj.dateUpdated)
      ..writeByte(13)
      ..write(obj.profilePictureUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
