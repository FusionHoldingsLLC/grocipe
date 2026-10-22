// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroceryListDataAdapter extends TypeAdapter<GroceryListData> {
  @override
  final int typeId = 13;

  @override
  GroceryListData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroceryListData(
      items: (fields[0] as List).cast<Grocery>(),
    );
  }

  @override
  void write(BinaryWriter writer, GroceryListData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroceryListDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GroceryAdapter extends TypeAdapter<Grocery> {
  @override
  final int typeId = 12;

  @override
  Grocery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Grocery(
      id: fields[0] as int?,
      brandName: fields[1] as String?,
      itemName: fields[2] as String?,
      unit: fields[3] as String?,
      quantity: fields[4] as String?,
      price: fields[5] as String?,
      category: fields[6] as String?,
      subCategory: fields[7] as String?,
      store: fields[8] as String?,
      city: fields[9] as String?,
      imageData: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Grocery obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.brandName)
      ..writeByte(2)
      ..write(obj.itemName)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.subCategory)
      ..writeByte(8)
      ..write(obj.store)
      ..writeByte(9)
      ..write(obj.city)
      ..writeByte(10)
      ..write(obj.imageData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroceryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
