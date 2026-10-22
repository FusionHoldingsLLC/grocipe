// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Instruction2Adapter extends TypeAdapter<Instruction2> {
  @override
  final int typeId = 2;

  @override
  Instruction2 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Instruction2(
      instruction: fields[1] as String,
      id: fields[2] as int,
      duration: fields[3] as int?,
      order: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Instruction2 obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.order)
      ..writeByte(1)
      ..write(obj.instruction)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Instruction2Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
