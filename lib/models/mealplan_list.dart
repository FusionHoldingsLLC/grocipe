import 'dart:convert';

import 'package:grocipe/models/grocery_list.dart';
import 'package:grocipe/models/recipe.dart';

class MealPlan {
  final int id;
  final String weekStartDate;
  final String weekEndDate;
  final Map<String, Map<String, List<Meal>>> days;

  MealPlan({
    required this.id,
    required this.weekStartDate,
    required this.weekEndDate,
    required this.days,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, List<Meal>>> parsedDays = {};
    if (json['days'] != null) {
      (json['days'] as Map<String, dynamic>).forEach((key, value) {
        Map<String, List<Meal>> mealsMap = {};
        (value as Map<String, dynamic>).forEach((mealKey, mealValue) {
          List<Meal> meals = [];
          if (mealValue != null) {
            for (var mealJson in mealValue) {
              meals.add(Meal.fromJson(mealJson));
            }
          }
          mealsMap[mealKey] = meals;
        });
        parsedDays[key] = mealsMap;
      });
    }

    return MealPlan(
      id: json['id'] ?? 0,
      weekStartDate: json['week_start_date'] ?? '',
      weekEndDate: json['week_end_date'] ?? '',
      days: parsedDays,
    );
  }

  static List<MealPlan> parseResponse(String jsonResponse) {
    final parsed = json.decode(jsonResponse).cast<Map<String, dynamic>>();
    return parsed.map<MealPlan>((json) => MealPlan.fromJson(json)).toList();
  }
}

class Meal {
  final List<Recipe> recipes;
  final List<Grocery> groceries;
  final bool eatingOut;

  Meal({
    required this.recipes,
    required this.groceries,
    required this.eatingOut,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<Recipe> recipes = [];
    if (json['recipe'] != null) {
      for (var recipeJson in json['recipe']) {
        recipes.add(Recipe.fromJson(recipeJson));
      }
    }

    List<Grocery> groceries = [];
    if (json['grocery'] != null) {
      for (var groceryJson in json['grocery']) {
        groceries.add(Grocery.fromJson(groceryJson));
      }
    }

    return Meal(
      recipes: recipes,
      groceries: groceries,
      eatingOut: json['eating_out'] ?? false,
    );
  }
}
