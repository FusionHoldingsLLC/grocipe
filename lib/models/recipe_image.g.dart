// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeImageAdapter extends TypeAdapter<RecipeImage> {
  @override
  final int typeId = 5;

  @override
  RecipeImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeImage(
      imageData: fields[0] as String,
      id: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeImage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.imageData)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
