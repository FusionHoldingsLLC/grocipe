import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/models/meal_plan_menu.dart';
import 'package:grocipe/models/weekly_mealplan.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MealPlanMenuHiveService {
  static MealPlanMenuHiveService get _instance => MealPlanMenuHiveService._();
  factory MealPlanMenuHiveService() => _instance;
  static MealPlanMenuHiveService get instance => _instance;
  MealPlanMenuHiveService._();

  static late Box _mealPlanBox;

  static Future init(Box mealPlanBox) async {
    Hive.registerAdapter(WeeklyMealPlanAdapter());
    Hive.registerAdapter(DayMealsAdapter());
    Hive.registerAdapter(ReqMealAdapter());

    _mealPlanBox = mealPlanBox;
    _mealPlanBox = await Hive.openBox<MealPlanMenu>('mealPlanMenuBox');
  }

  Future<void> insertMealPlan(MealPlanMenu mealPlan) async {
    try {
      if (mealPlan.weekStartDate != null) {
        await _mealPlanBox.put(mealPlan.weekStartDate, mealPlan);
      } else {
        throw ArgumentError("weekStartDate cannot be null");
      }
    } catch (e) {
      print('Error inserting meal plan: $e');
    }
  }

  Future<MealPlanMenu?> getMealPlan(String weekStartDate) async {
    return await _mealPlanBox.get(weekStartDate) as MealPlanMenu?;
  }

  static Future<void> deleteMealPlan(String weekStartDate) async {
    await _mealPlanBox.delete(weekStartDate);
  }

  bool mealPlanExists(String weekStartDate) {
    return _mealPlanBox.containsKey(weekStartDate);
  }

  Future<void> updateWeeklyMealPlan(
      String weekStartDate, MealPlanMenu updatedMealPlan) async {
    if (mealPlanExists(weekStartDate)) {
      await _mealPlanBox.put(weekStartDate, updatedMealPlan);
    } else {
      insertMealPlan(updatedMealPlan);
      // throw ArgumentError("Meal plan for the given startDate does not exist");
    }
  }
}

final mealplanMenuStorageService =
    Provider<MealPlanMenuHiveService>((ref) => MealPlanMenuHiveService());
