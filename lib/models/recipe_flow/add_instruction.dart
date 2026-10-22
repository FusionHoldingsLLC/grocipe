import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:grocipe/models/recipe_flow/ingredient.dart';
import 'package:grocipe/models/recipe_flow/instruction.dart';
import 'package:grocipe/models/recipe_flow/nutrition.dart';

class AddInstructionData {
  List<Ingredient> ingredients;
  List<Instruction> instructions;
  List<Nutrition> nutritions;
  String category;
  Duration prepTime;
  Duration cookTime;

  AddInstructionData({
    required this.ingredients,
    required this.instructions,
    required this.nutritions,
    required this.category,
    required this.prepTime,
    required this.cookTime,
  });

  AddInstructionData copyWith({
    List<Ingredient>? ingredients,
    List<Instruction>? instruction,
    List<Nutrition>? nutritions,
    String? category,
    Duration? prepTime,
    Duration? cookTime,
  }) {
    return AddInstructionData(
      ingredients: ingredients ?? this.ingredients,
      instructions: instruction ?? this.instructions,
      nutritions: nutritions ?? this.nutritions,
      category: category ?? this.category,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ingredients': ingredients.map((x) => x.toMap()).toList(),
      'instructions': instructions.map((x) => x.toMap()).toList(),
      'nutritional_facts': nutritions.map((x) => x.toMap()).toList(),
      'nutritions': nutritions.map((x) => x.toMap()).toList(),
      'category': category,
      'prepTime': prepTime.inMinutes,
      'cookTime': cookTime.inMinutes,
    };
  }

  factory AddInstructionData.fromMap(Map<String, dynamic> map) {
    return AddInstructionData(
      ingredients: List<Ingredient>.from(
        (map['ingredients'] as List).map<Ingredient>(
          (x) => Ingredient.fromMap(x as Map<String, dynamic>),
        ),
      ),
      instructions: List<Instruction>.from(
        (map['instructions'] as List).map<Instruction>(
          (x) => Instruction.fromMap(x as Map<String, dynamic>),
        ),
      ),
      nutritions: List<Nutrition>.from(
        (map['nutritional_facts'] ?? ['nutritions'] as List).map<Nutrition>(
          (x) => Nutrition.fromMap(x as Map<String, dynamic>),
        ),
      ),
      category: map['category'] as String,
      prepTime: Duration(minutes: map['prepTime']),
      cookTime: Duration(minutes: map['cookTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddInstructionData.fromJson(String source) =>
      AddInstructionData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddInstructionData(ingredients: $ingredients, instructions: $instructions, nutritional_facts: $nutritions, category: $category, prepTime: $prepTime, cookTime: $cookTime)';
  }

  @override
  bool operator ==(covariant AddInstructionData other) {
    if (identical(this, other)) return true;

    return listEquals(other.ingredients, ingredients) &&
        listEquals(other.instructions, instructions) &&
        listEquals(other.nutritions, nutritions) &&
        other.category == category &&
        other.prepTime == prepTime &&
        other.cookTime == cookTime;
  }

  @override
  int get hashCode {
    return ingredients.hashCode ^
        instructions.hashCode ^
        nutritions.hashCode ^
        category.hashCode ^
        prepTime.hashCode ^
        cookTime.hashCode;
  }
}
