import 'package:grocipe/models/meal_plan_menu.dart';

Map<String, dynamic> constructBackendData(MealPlanMenu mealPlan) {
  Map<String, dynamic> data = {
    'id': mealPlan.id,
    'week_start_date': mealPlan.weekStartDate,
    'week_end_date': mealPlan.weekEndDate,
    'days': []
  };

  mealPlan.days?.forEach((day, dayMealsData) {
    Map<String, dynamic> dayMap = {day.toLowerCase(): {}};

    if (dayMealsData.breakfast != null) {
      dayMap[day.toLowerCase()]['breakfast'] =
          dayMealsData.breakfast!.map((meal) {
        return {
          'recipe_id': meal.recipe?.map((recipe) => recipe.id).toList(),
          'grocery_id': meal.grocery?.map((grocery) => grocery.id).toList(),
          'eating_out': meal.eatingOut
        };
      }).toList();
    }

    if (dayMealsData.lunch != null) {
      dayMap[day.toLowerCase()]['lunch'] = dayMealsData.lunch!.map((meal) {
        return {
          'recipe_id': meal.recipe?.map((recipe) => recipe.id).toList(),
          'grocery_id': meal.grocery?.map((grocery) => grocery.id).toList(),
          'eating_out': meal.eatingOut
        };
      }).toList();
    }

    if (dayMealsData.dinner != null) {
      dayMap[day.toLowerCase()]['dinner'] = dayMealsData.dinner!.map((meal) {
        return {
          'recipe_id': meal.recipe?.map((recipe) => recipe.id).toList(),
          'grocery_id': meal.grocery?.map((grocery) => grocery.id).toList(),
          'eating_out': meal.eatingOut
        };
      }).toList();
    }

    if (dayMealsData.others != null) {
      dayMap[day.toLowerCase()]['others'] = dayMealsData.others!.map((meal) {
        return {
          'recipe_id': meal.recipe?.map((recipe) => recipe.id).toList(),
          'grocery_id': meal.grocery?.map((grocery) => grocery.id).toList(),
          'eating_out': meal.eatingOut
        };
      }).toList();
    }

    data['days'].add(dayMap);
  });

  return data;
}

Map<String, dynamic> updateMealPlanData(
    {required Map<String, dynamic> plan,
    required String day,
    required String meal,
    required List<int> recipeIds,
    required List<int> groceryIds}) {
  day = day.toLowerCase();
  meal = meal.toLowerCase();

  Map<String, dynamic> newMealData = {
    "recipe_id": recipeIds,
    "grocery_id": groceryIds,
    "eating_out": true
  };

  for (var dayPlan in plan["days"]) {
    if (dayPlan.containsKey(day)) {
      dayPlan[day][meal] = [newMealData];
      break;
    }
  }

  return plan;
}
