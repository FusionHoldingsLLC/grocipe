import 'package:grocipe/models/health.dart';
import 'package:grocipe/models/ingredient.dart';
import 'package:grocipe/models/instruction.dart';
import 'package:grocipe/models/nutrition.dart';
import 'package:grocipe/models/meal_type.dart';
import 'package:grocipe/models/recipe_image.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';

part 'recipe.g.dart';

@HiveType(typeId: 8)
class Recipe extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? diet;

  @HiveField(3)
  String? author;

  @HiveField(4)
  String? cuisine;

  @HiveField(5)
  String? note;

  @HiveField(6)
  int prepTime;

  @HiveField(7)
  int cookTime;

  @HiveField(8)
  int totalTime;

  @HiveField(9)
  int servings;

  @HiveField(10)
  String? category;

  @HiveField(11)
  double? ratings;

  @HiveField(12)
  String? videoUrl;

  @HiveField(13)
  String? url;

  @HiveField(14)
  String? creationMethod;

  @HiveField(15)
  bool? isPublic;

  @HiveField(16)
  double? healthRatings;

  @HiveField(17)
  List<MealType> mealTypes;

  @HiveField(18)
  List<Ingredient>? ingredients;

  @HiveField(19)
  List<Instruction2> instructions;

  @HiveField(20)
  List<NutritionalFact> nutritionalFacts;

  @HiveField(21)
  List<HealthReport> healthReports;

  @HiveField(22)
  List<RecipeImage> recipeImages;

  @HiveField(23)
  String dateUpdated;

  @HiveField(24)
  int? originalRecipeId;

  @HiveField(25)
  DateTime? cacheTimestamp; // Add this field for cache timestamp

  Recipe({
    required this.id,
    required this.name,
    required this.diet,
    required this.author,
    required this.cuisine,
    this.note,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.servings,
    this.category,
    this.ratings,
    required this.videoUrl,
    required this.url,
    required this.creationMethod,
    this.isPublic,
    this.healthRatings,
    required this.mealTypes,
    this.ingredients,
    required this.instructions,
    required this.nutritionalFacts,
    required this.healthReports,
    required this.recipeImages,
    required this.dateUpdated,
    this.originalRecipeId,
    this.cacheTimestamp,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        name: json['name'],
        diet: json['diet'] ?? "",
        author: json['author'] ?? "",
        cuisine: json['cuisine'],
        note: json['note'],
        prepTime: json['prep_time'] ?? 0,
        cookTime: json['cook_time'] ?? 0,
        totalTime: json['total_time'] ?? 0,
        servings: json['servings'] ?? 0,
        category: json['category'],
        ratings: json['ratings'],
        videoUrl: json['video_url'],
        url: json['url'],
        creationMethod: json['creation_method'],
        isPublic: json['is_public'],
        healthRatings: json['health_ratings'],
        mealTypes: List<MealType>.from(
            json['meal_types'].map((x) => MealType.fromJson(x))),
        ingredients: (json['ingredients'] as List?)
            ?.map((x) => Ingredient.fromJson(x))
            .toList(),
        instructions: List<Instruction2>.from(
          json['instructions'].map((x) => Instruction2.fromMap(x)),
        ),
        nutritionalFacts: List<NutritionalFact>.from(
            json['nutritional_facts'].map((x) => NutritionalFact.fromJson(x))),
        healthReports: List<HealthReport>.from(
            json['health_reports'].map((x) => HealthReport.fromJson(x))),
        recipeImages: List<RecipeImage>.from(
            json['recipe_images'].map((x) => RecipeImage.fromJson(x))),
        dateUpdated: json['date_updated'],
        originalRecipeId: json['original_recipe_id'],
        cacheTimestamp: json['cache_timestamp'] != null
            ? DateTime.parse(json['cache_timestamp'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'diet': diet,
        'author': author,
        'cuisine': cuisine,
        'note': note,
        'prep_time': prepTime,
        'cook_time': cookTime,
        'total_time': totalTime,
        'servings': servings,
        'category': category,
        'ratings': ratings,
        'video_url': videoUrl,
        'url': url,
        'creation_method': creationMethod,
        'is_public': isPublic,
        'health_ratings': healthRatings,
        'meal_types': List<dynamic>.from(mealTypes.map((x) => x.toJson())),
        'ingredients': ingredients?.map((x) => x.toJson()).toList(),
        'instructions': List<dynamic>.from(instructions.map((x) => x.toJson())),
        'nutritional_facts':
            List<dynamic>.from(nutritionalFacts.map((x) => x.toJson())),
        'health_reports':
            List<dynamic>.from(healthReports.map((x) => x.toJson())),
        'recipe_images':
            List<dynamic>.from(recipeImages.map((x) => x.toJson())),
        'date_updated': dateUpdated,
        'original_recipe_id': originalRecipeId,
        'cache_timestamp': cacheTimestamp?.toIso8601String(),
      };

  Recipe copyWith({
    int? id,
    String? name,
    String? diet,
    String? author,
    String? cuisine,
    String? note,
    int? prepTime,
    int? cookTime,
    int? totalTime,
    int? servings,
    String? category,
    double? ratings,
    String? videoUrl,
    String? url,
    String? creationMethod,
    bool? isPublic,
    double? healthRatings,
    List<MealType>? mealTypes,
    List<Ingredient>? ingredients,
    List<Instruction2>? instructions,
    List<NutritionalFact>? nutritionalFacts,
    List<HealthReport>? healthReports,
    List<RecipeImage>? recipeImages,
    String? dateUpdated,
    int? originalRecipeId,
    DateTime? cacheTimestamp,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      diet: diet ?? this.diet,
      author: author ?? this.author,
      cuisine: cuisine ?? this.cuisine,
      note: note ?? this.note,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      totalTime: totalTime ?? this.totalTime,
      servings: servings ?? this.servings,
      category: category ?? this.category,
      ratings: ratings ?? this.ratings,
      videoUrl: videoUrl ?? this.videoUrl,
      url: url ?? this.url,
      creationMethod: creationMethod ?? this.creationMethod,
      isPublic: isPublic ?? this.isPublic,
      healthRatings: healthRatings ?? this.healthRatings,
      mealTypes: mealTypes ?? this.mealTypes,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      nutritionalFacts: nutritionalFacts ?? this.nutritionalFacts,
      healthReports: healthReports ?? this.healthReports,
      recipeImages: recipeImages ?? this.recipeImages,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      originalRecipeId: originalRecipeId ?? this.originalRecipeId,
      cacheTimestamp: cacheTimestamp ?? this.cacheTimestamp,
    );
  }

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, diet: $diet, author: $author, cuisine: $cuisine, note: $note, prepTime: $prepTime, cookTime: $cookTime, totalTime: $totalTime, servings: $servings, category: $category, ratings: $ratings, videoUrl: $videoUrl, url: $url, creationMethod: $creationMethod, isPublic: $isPublic, healthRatings: $healthRatings, mealTypes: $mealTypes, ingredients: $ingredients, instructions: $instructions, nutritionalFacts: $nutritionalFacts, healthReports: $healthReports, recipeImages: $recipeImages, dateUpdated: $dateUpdated, originalRecipeId: $originalRecipeId, cacheTimestamp: $cacheTimestamp}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Recipe &&
        other.id == id &&
        other.name == name &&
        other.diet == diet &&
        other.author == author &&
        other.cuisine == cuisine &&
        other.note == note &&
        other.prepTime == prepTime &&
        other.cookTime == cookTime &&
        other.totalTime == totalTime &&
        other.servings == servings &&
        other.category == category &&
        other.ratings == ratings &&
        other.videoUrl == videoUrl &&
        other.url == url &&
        other.creationMethod == creationMethod &&
        other.isPublic == isPublic &&
        other.healthRatings == healthRatings &&
        const ListEquality().equals(other.mealTypes, mealTypes) &&
        const ListEquality().equals(other.ingredients, ingredients) &&
        const ListEquality().equals(other.instructions, instructions) &&
        const ListEquality().equals(other.nutritionalFacts, nutritionalFacts) &&
        const ListEquality().equals(other.healthReports, healthReports) &&
        const ListEquality().equals(other.recipeImages, recipeImages) &&
        other.dateUpdated == dateUpdated &&
        other.originalRecipeId == originalRecipeId &&
        other.cacheTimestamp == cacheTimestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        diet.hashCode ^
        author.hashCode ^
        cuisine.hashCode ^
        note.hashCode ^
        prepTime.hashCode ^
        cookTime.hashCode ^
        totalTime.hashCode ^
        servings.hashCode ^
        category.hashCode ^
        ratings.hashCode ^
        videoUrl.hashCode ^
        url.hashCode ^
        creationMethod.hashCode ^
        isPublic.hashCode ^
        healthRatings.hashCode ^
        mealTypes.hashCode ^
        ingredients.hashCode ^
        instructions.hashCode ^
        nutritionalFacts.hashCode ^
        healthReports.hashCode ^
        recipeImages.hashCode ^
        dateUpdated.hashCode ^
        originalRecipeId.hashCode ^
        cacheTimestamp.hashCode;
  }
}
