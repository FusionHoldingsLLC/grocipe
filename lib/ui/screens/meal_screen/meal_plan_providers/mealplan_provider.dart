// ignore_for_file: unused_catch_clause

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/local_storage/weeks_mealplan_adapter.dart';
import 'package:grocipe/models/meal_plan_menu.dart';
import 'package:grocipe/models/mealplan_list.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/services/meal_service.dart';
import 'package:hive_flutter/adapters.dart';

class MealplanProvider extends StateNotifier<AppState<MealPlanMenu>> {
  final Ref ref;
  Box<MealPlanMenu>? _mealPlanBox;
  MealplanProvider(this.ref) : super(InitialAppState()) {
    _initializeBox();
  }

  MealplanService get service => ref.read(mealPlanService);

  MealPlanHiveService get weekMealplanStorage =>
      ref.read(weeklyMealplanStorageService);

  HiveFunction get hiveFunction => ref.read(localStorageService);

  Future<void> _initializeBox() async {
    try {
      _mealPlanBox = await Hive.openBox<MealPlanMenu>('mealPlanBox');
      print('Box initialized successfully');
    } catch (e) {
      print('Error initializing box: $e');
    }
  }

  Future createMealplan(String startDate, String endDate) async {
    var data = {
      "week_start_date": startDate,
      "week_end_date": endDate,
      "days": []
    };

    try {
      state = LoadingAppState();
      final res = await service.createMealplan(data);
      print(res);
      for (var menu in res) {
        if (menu.weekStartDate != null) {
          print(
              'Inserting meal plan for week starting on ${menu.weekStartDate}');
          try {
            await _mealPlanBox?.put(menu.weekStartDate!, menu);
          } catch (e) {
            print('Error inserting meal plan: $e');
          }
        } else {
          print('Skipping meal plan with null weekStartDate');
        }
      }
      state = SuccessAppState(res.first);
      return res;
    } on Exception catch (e) {
      return null;
    }
  }

  Future<MealPlanMenu?> getStoredMealPlan(String startDate) async {
    try {
      final mealPlanMenu = _mealPlanBox?.get(startDate);
      state = SuccessAppState(mealPlanMenu ?? MealPlanMenu());
      return mealPlanMenu;
    } catch (e) {
      print('Error retrieving stored meal plan: $e');
      return null;
    }
  }

  bool get hasData => state is ListAppState<MealPlan>;
}

final mealplanProvider =
    StateNotifierProvider<MealplanProvider, AppState<MealPlanMenu>>(
        (ref) => MealplanProvider(ref));
