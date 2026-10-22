import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/models/meal_plan_menu.dart';
import 'package:grocipe/models/mealplan_list.dart';
import 'package:grocipe/models/weekly_mealplan.dart';
import 'package:grocipe/api/network.dart';
import 'package:grocipe/api/api_urls.dart';

class MealplanService {
  final Ref ref;

  MealplanService(this.ref);

  Network get network => ref.read(networkProvider);

  Future<List<MealPlanMenu>> createMealplan(Map<String, dynamic> data) async {
    final res = await network.call(
      UrlConfig.createMealplan,
      RequestMethod.post,
      data: jsonEncode(data),
      showLog: true,
    );

    List<dynamic> jsonList = jsonDecode(jsonEncode(res.data));
    List<MealPlanMenu> mealPlan =
        jsonList.map((json) => MealPlanMenu.fromJson(json)).toList();
    return mealPlan;
  }

  Future createMealplanAI(Map<String, dynamic> data) async {
    final res = await network.call(
      UrlConfig.createMealplanAI,
      RequestMethod.post,
      data: data,
      showLog: true,
    );
    List<MealPlan> response = MealPlan.parseResponse(res.data);
    return response;
  }

  // Future<WeeklyMealPlan> updateMealplan(Map<String, dynamic> data) async {
  //   final res = await network.call(
  //     UrlConfig.updateMealplan,
  //     RequestMethod.patch,
  //     data: data,
  //     showLog: true,
  //   );
  //   // List<MealPlan> response = MealPlan.parseResponse(res.data);
  //   WeeklyMeMealPlan response = WeeklyMealPlan.fromJson(res.data);
  //   return response;
  // }
  Future<MealPlanMenu> updateMealplan(Map<String, dynamic> data) async {
    final res = await network.call(
      UrlConfig.updateMealplan,
      RequestMethod.patch,
      data: data,
      showLog: true,
    );
    // List<MealPlan> response = MealPlan.parseResponse(res.data);
    MealPlanMenu response = MealPlanMenu.fromJson(res.data);
    return response;
  }

  Future<List<MealPlanMenu>> getMealplanWithDate(
      Map<String, dynamic> data) async {
    final res = await network.call(
      UrlConfig.getMealplanDates,
      RequestMethod.get,
      queryParams: data,
      showLog: true,
    );

    // MealPlanMenu response = MealPlanMenu.fromJson(res.data);

    List<dynamic> jsonList = jsonDecode(jsonEncode(res.data));
    List<MealPlanMenu> mealPlan =
        jsonList.map((json) => MealPlanMenu.fromJson(json)).toList();
    return mealPlan;
    // return response;
  }

  Future<MealPlan> retrieveMealplan(Map<String, dynamic> data) async {
    final res = await network.call(
      UrlConfig.retrieveMealplan,
      RequestMethod.get,
      data: data,
      showLog: true,
    );
    var response = MealPlan.fromJson(res.data);
    return response;
  }

  Future<MealPlan> deleteMealplan(Map<String, dynamic> data) async {
    final res = await network.call(
      UrlConfig.deleteMealplan,
      RequestMethod.delete,
      data: data,
      showLog: true,
    );
    var response = MealPlan.fromJson(res.data);
    return response;
  }
}

final mealPlanService =
    Provider<MealplanService>((ref) => MealplanService(ref));
