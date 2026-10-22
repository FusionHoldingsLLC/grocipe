// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 8;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      id: fields[0] as int,
      name: fields[1] as String,
      diet: fields[2] as String?,
      author: fields[3] as String?,
      cuisine: fields[4] as String?,
      note: fields[5] as String?,
      prepTime: fields[6] as int,
      cookTime: fields[7] as int,
      totalTime: fields[8] as int,
      servings: fields[9] as int,
      category: fields[10] as String?,
      ratings: fields[11] as double?,
      videoUrl: fields[12] as String?,
      url: fields[13] as String?,
      creationMethod: fields[14] as String?,
      isPublic: fields[15] as bool?,
      healthRatings: fields[16] as double?,
      mealTypes: (fields[17] as List).cast<MealType>(),
      ingredients: (fields[18] as List?)?.cast<Ingredient>(),
      instructions: (fields[19] as List).cast<Instruction2>(),
      nutritionalFacts: (fields[20] as List).cast<NutritionalFact>(),
      healthReports: (fields[21] as List).cast<HealthReport>(),
      recipeImages: (fields[22] as List).cast<RecipeImage>(),
      dateUpdated: fields[23] as String,
      originalRecipeId: fields[24] as int?,
      cacheTimestamp: fields[25] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.diet)
      ..writeByte(3)
      ..write(obj.author)
      ..writeByte(4)
      ..write(obj.cuisine)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.prepTime)
      ..writeByte(7)
      ..write(obj.cookTime)
      ..writeByte(8)
      ..write(obj.totalTime)
      ..writeByte(9)
      ..write(obj.servings)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.ratings)
      ..writeByte(12)
      ..write(obj.videoUrl)
      ..writeByte(13)
      ..write(obj.url)
      ..writeByte(14)
      ..write(obj.creationMethod)
      ..writeByte(15)
      ..write(obj.isPublic)
      ..writeByte(16)
      ..write(obj.healthRatings)
      ..writeByte(17)
      ..write(obj.mealTypes)
      ..writeByte(18)
      ..write(obj.ingredients)
      ..writeByte(19)
      ..write(obj.instructions)
      ..writeByte(20)
      ..write(obj.nutritionalFacts)
      ..writeByte(21)
      ..write(obj.healthReports)
      ..writeByte(22)
      ..write(obj.recipeImages)
      ..writeByte(23)
      ..write(obj.dateUpdated)
      ..writeByte(24)
      ..write(obj.originalRecipeId)
      ..writeByte(25)
      ..write(obj.cacheTimestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
