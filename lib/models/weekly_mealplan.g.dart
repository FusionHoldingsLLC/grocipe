// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_mealplan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyMealPlanAdapter extends TypeAdapter<WeeklyMealPlan> {
  @override
  final int typeId = 11;

  @override
  WeeklyMealPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklyMealPlan(
      id: fields[0] as int?,
      weekStartDate: fields[1] as String?,
      weekEndDate: fields[2] as String?,
      days: (fields[3] as Map?)?.cast<String, DayMeals>(),
    );
  }

  @override
  void write(BinaryWriter writer, WeeklyMealPlan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.weekStartDate)
      ..writeByte(2)
      ..write(obj.weekEndDate)
      ..writeByte(3)
      ..write(obj.days);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyMealPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayMealsAdapter extends TypeAdapter<DayMeals> {
  @override
  final int typeId = 10;

  @override
  DayMeals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayMeals(
      breakfast: (fields[0] as List?)?.cast<ReqMeal>(),
      lunch: (fields[1] as List?)?.cast<ReqMeal>(),
      dinner: (fields[2] as List?)?.cast<ReqMeal>(),
      snacks: (fields[3] as List?)?.cast<ReqMeal>(),
    );
  }

  @override
  void write(BinaryWriter writer, DayMeals obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.breakfast)
      ..writeByte(1)
      ..write(obj.lunch)
      ..writeByte(2)
      ..write(obj.dinner)
      ..writeByte(3)
      ..write(obj.snacks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayMealsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReqMealAdapter extends TypeAdapter<ReqMeal> {
  @override
  final int typeId = 9;

  @override
  ReqMeal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReqMeal(
      recipeId: (fields[0] as List?)?.cast<int>(),
      groceryId: (fields[1] as List?)?.cast<int>(),
      eatingOut: fields[2] as bool?,
      recipes: (fields[3] as List?)?.cast<Recipe>(),
      groceries: (fields[4] as List?)?.cast<Grocery>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReqMeal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.recipeId)
      ..writeByte(1)
      ..write(obj.groceryId)
      ..writeByte(2)
      ..write(obj.eatingOut)
      ..writeByte(3)
      ..write(obj.recipes)
      ..writeByte(4)
      ..write(obj.groceries);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReqMealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
