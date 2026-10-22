import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/models/weekly_mealplan.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MealPlanHiveService {
  static MealPlanHiveService get _instance => MealPlanHiveService._();
  factory MealPlanHiveService() => _instance;
  static MealPlanHiveService get instance => _instance;
  MealPlanHiveService._();

  static late Box _mealPlanBox;

  static Future init(Box mealPlanBox) async {
    // Hive.registerAdapter(WeeklyMealPlanAdapter());
    // Hive.registerAdapter(DayMealsAdapter());
    // Hive.registerAdapter(ReqMealAdapter());
    // Hive.registerAdapter(MealPlanMenuAdapter());

    _mealPlanBox = mealPlanBox;
  }

  Future<void> insertMealPlan(WeeklyMealPlan mealPlan) async {
    if (mealPlan.weekStartDate != null) {
      await _mealPlanBox.put("${mealPlan.weekStartDate}req", mealPlan);
    } else {
      throw ArgumentError("weekStartDate cannot be null");
    }
  }

  Future<WeeklyMealPlan?> getMealPlan(String weekStartDate) async {
    return await _mealPlanBox.get("${weekStartDate}req") as WeeklyMealPlan?;
  }

  static Future<void> deleteMealPlan(String weekStartDate) async {
    await _mealPlanBox.delete("${weekStartDate}req");
  }

  bool mealPlanExists(String weekStartDate) {
    return _mealPlanBox.containsKey("${weekStartDate}req");
  }

  Future<void> updateWeeklyMealPlan(
      String weekStartDate, WeeklyMealPlan updatedMealPlan) async {
    if (mealPlanExists("${weekStartDate}req")) {
      await _mealPlanBox.put("${weekStartDate}req", updatedMealPlan);
    } else {
      throw ArgumentError("Meal plan for the given startDate does not exist");
    }
  }
}

final weeklyMealplanStorageService =
    Provider<MealPlanHiveService>((ref) => MealPlanHiveService());
