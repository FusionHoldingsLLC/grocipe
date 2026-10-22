// ignore_for_file: unused_catch_clause, avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/local_storage/meal_plan_menu_adapter.dart';
import 'package:grocipe/models/meal_plan_menu.dart';
import 'package:grocipe/models/mealplan_list.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/services/meal_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MealplanMenuProvider extends StateNotifier<AppState<MealPlanMenu>> {
  final Ref ref;
  Box<MealPlanMenu>? _mealPlanBox;

  MealplanMenuProvider(this.ref) : super(InitialAppState()) {
    _ensureBoxIsReady();
  }

  MealplanService get service => ref.read(mealPlanService);

  MealPlanMenuHiveService get mealplanMenuStorage =>
      ref.read(mealplanMenuStorageService);

  Future<void> _ensureBoxIsReady() async {
    if (_mealPlanBox == null || !_mealPlanBox!.isOpen) {
      await _initializeBox();
    }
  }

  Future<void> _initializeBox() async {
    try {
      if (Hive.isBoxOpen('mealPlanBox')) {
        _mealPlanBox = Hive.box('mealPlanBox');
        print('Box already open');
      } else {
        _mealPlanBox = await Hive.openBox<MealPlanMenu>('mealPlanBox');
        print('Box initialized successfully');
      }
    } catch (e) {
      print('Error initializing box: $e');
    }
  }

  Future<MealPlanMenu?> getStoredMealPlan(String startDate) async {
    await _ensureBoxIsReady();
    try {
      final mealPlanMenu = _mealPlanBox?.get(startDate);
      state = SuccessAppState(mealPlanMenu ?? MealPlanMenu());
      return mealPlanMenu;
    } catch (e) {
      print('Error retrieving stored meal plan: $e');
      return null;
    }
  }

  Future<List<MealPlanMenu?>?> getMealPlanFromApi(
      Map<String, dynamic> data) async {
    final startDate = data["start_date"];
    final endDate = data["end_date"];

    // state = LoadingAppState();
    final cachedMealPlan = await getStoredMealPlan(startDate);
    if (cachedMealPlan != null) {
      state = SuccessAppState(cachedMealPlan);
      return [cachedMealPlan];
    } else {
      state = SuccessAppState(MealPlanMenu());
    }

    try {
      state = LoadingAppState();
      final mealPlanMenu = await service.getMealplanWithDate(data);
      print('API response: $mealPlanMenu');

      for (var menu in mealPlanMenu) {
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

      final boxLength = _mealPlanBox?.length;
      print('Length of the Box after insertion: $boxLength');

      state = SuccessAppState(mealPlanMenu.first);
      print('Meal plans fetched successfully');
      return mealPlanMenu;
    } on Exception catch (e) {
      print('Error fetching meal plans: $e');

      var newDate = {
        "week_start_date": startDate,
        "week_end_date": endDate,
        "days": []
      };
      final mealPlanMenu = await service.createMealplan(newDate);
      print('Create Meal Plan API response: $mealPlanMenu');

      for (var menu in mealPlanMenu) {
        if (menu.weekStartDate != null) {
          print(
              'Inserting meal plan for week starting on ${menu.weekStartDate}');
          try {
            await _mealPlanBox?.put(menu.weekStartDate!, menu);
            state = SuccessAppState(mealPlanMenu.first);
          } catch (e) {
            print('Error inserting meal plan: $e');
            state = FailureAppState('Failed to retrieve meal plans');
          }
        } else {
          print('Skipping meal plan with null weekStartDate');
        }
      }
      state = SuccessAppState(cachedMealPlan ?? MealPlanMenu());

      return cachedMealPlan != null ? [cachedMealPlan] : [];
    } finally {
      state = SuccessAppState(cachedMealPlan ?? MealPlanMenu());
    }
  }

  Future<void> nextWeek(DateTime currentWeekStart) async {
    // Sunday - Saturday
    int now = DateTime.now().weekday;
    // SET NEXT WEEK START AND STOP DATE
    final nextWeekStart = currentWeekStart.add(Duration(days: now % 7));
    final nextWeekEnd = nextWeekStart.add(const Duration(days: 6));
    // FORMART THE DATE TO REMOVE TIME IN IT
    String formattedStartDate = nextWeekStart.toIso8601String().split('T')[0];
    String formattedEndDate = nextWeekEnd.toIso8601String().split('T')[0];
    // MAKE API CALL
    await getMealPlanFromApi({
      'start_date': formattedStartDate,
      'end_date': formattedEndDate,
    });
  }

  Future<void> previousWeek(DateTime currentWeekStart) async {
    int now = DateTime.now().weekday;
    // SET PREVIOUS WEEK START AND STOP DATE
    final previousWeekStart =
        currentWeekStart.subtract(Duration(days: now % 7));
    final previousWeekEnd = previousWeekStart.add(const Duration(days: 6));
    // FORMART THE DATE TO REMOVE TIME IN IT
    String formattedStartDate =
        previousWeekStart.toIso8601String().split('T')[0];
    String formattedEndDate = previousWeekEnd.toIso8601String().split('T')[0];

    await getMealPlanFromApi({
      'start_date': formattedStartDate,
      'end_date': formattedEndDate,
    });
  }

  /// Update meal plan and cache the changes
  Future updateMeal(Map<String, dynamic> data) async {
    try {
      if (!hasData) state = LoadingAppState();
      final res = await service.updateMealplan(data);

      if (res.weekStartDate != null) {
        await _mealPlanBox?.put(res.weekStartDate!, res);
      }
      state = SuccessAppState(res);
      return res;
    } on Exception catch (e) {
      print("Error updating meal plan: $e");
      state = SuccessAppState(MealPlanMenu());
    }
  }

  bool get hasData => state is ListAppState<MealPlan>;
}

final mealplanMenuProvider =
    StateNotifierProvider<MealplanMenuProvider, AppState<MealPlanMenu>>(
        (ref) => MealplanMenuProvider(ref));
