// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_menu.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealPlanMenuAdapter extends TypeAdapter<MealPlanMenu> {
  @override
  final int typeId = 16;

  @override
  MealPlanMenu read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPlanMenu(
      id: fields[0] as int?,
      weekStartDate: fields[1] as String?,
      weekEndDate: fields[2] as String?,
      days: (fields[3] as Map?)?.cast<String, DayMealsData>(),
    );
  }

  @override
  void write(BinaryWriter writer, MealPlanMenu obj) {
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
      other is MealPlanMenuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayMealsDataAdapter extends TypeAdapter<DayMealsData> {
  @override
  final int typeId = 15;

  @override
  DayMealsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayMealsData(
      breakfast: (fields[0] as List?)?.cast<Meal>(),
      lunch: (fields[1] as List?)?.cast<Meal>(),
      dinner: (fields[2] as List?)?.cast<Meal>(),
      others: (fields[3] as List?)?.cast<Meal>(),
    );
  }

  @override
  void write(BinaryWriter writer, DayMealsData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.breakfast)
      ..writeByte(1)
      ..write(obj.lunch)
      ..writeByte(2)
      ..write(obj.dinner)
      ..writeByte(3)
      ..write(obj.others);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayMealsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 14;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      recipe: (fields[0] as List?)?.cast<MealplanRecipe>(),
      grocery: (fields[1] as List?)?.cast<Grocery>(),
      eatingOut: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.recipe)
      ..writeByte(1)
      ..write(obj.grocery)
      ..writeByte(2)
      ..write(obj.eatingOut);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealplanRecipeAdapter extends TypeAdapter<MealplanRecipe> {
  @override
  final int typeId = 23;

  @override
  MealplanRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealplanRecipe(
      id: fields[0] as int?,
      name: fields[1] as String?,
      ingredients: (fields[2] as List?)?.cast<MealPlanIngredients>(),
      nutritionalFacts: (fields[3] as List?)?.cast<MealPlanNutritionalFacts>(),
    );
  }

  @override
  void write(BinaryWriter writer, MealplanRecipe obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.nutritionalFacts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealplanRecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealPlanIngredientsAdapter extends TypeAdapter<MealPlanIngredients> {
  @override
  final int typeId = 22;

  @override
  MealPlanIngredients read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPlanIngredients(
      id: fields[0] as int?,
      ingredientId: fields[1] as int?,
      ingredient: fields[2] as MealPlanIngredient?,
      detail: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MealPlanIngredients obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ingredientId)
      ..writeByte(2)
      ..write(obj.ingredient)
      ..writeByte(3)
      ..write(obj.detail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealPlanIngredientsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealPlanIngredientAdapter extends TypeAdapter<MealPlanIngredient> {
  @override
  final int typeId = 21;

  @override
  MealPlanIngredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPlanIngredient(
      name: fields[0] as String?,
      groceryId: fields[1] as int?,
      createdMode: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MealPlanIngredient obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.groceryId)
      ..writeByte(2)
      ..write(obj.createdMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealPlanIngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealPlanNutritionalFactsAdapter
    extends TypeAdapter<MealPlanNutritionalFacts> {
  @override
  final int typeId = 20;

  @override
  MealPlanNutritionalFacts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPlanNutritionalFacts(
      name: fields[0] as String?,
      value: fields[1] as String?,
      id: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MealPlanNutritionalFacts obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealPlanNutritionalFactsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
