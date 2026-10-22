import 'package:grocipe/models/grocery_list.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:hive/hive.dart';

part 'weekly_mealplan.g.dart';

@HiveType(typeId: 11)
class WeeklyMealPlan {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? weekStartDate;

  @HiveField(2)
  String? weekEndDate;

  @HiveField(3)
  Map<String, DayMeals>? days;

  WeeklyMealPlan({
    this.id,
    this.weekStartDate,
    this.weekEndDate,
    this.days,
  });

  factory WeeklyMealPlan.fromJson(Map<String, dynamic> json) {
    return WeeklyMealPlan(
      id: json['id'] as int?,
      weekStartDate: json['week_start_date'] as String?,
      weekEndDate: json['week_end_date'] as String?,
      days: (json['days'][0] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, DayMeals.fromJson(value))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'week_start_date': weekStartDate,
      'week_end_date': weekEndDate,
      'days': [
        days?.map((key, value) => MapEntry(key, value.toJson())),
      ],
    };
  }

  void updateMeal(String day, String mealType, ReqMeal newMeal) {
    days ??= {day: DayMeals(breakfast: [], lunch: [], dinner: [], snacks: [])};
    days![day] ??= DayMeals();

    switch (mealType) {
      case 'breakfast':
        days![day]!.breakfast = [newMeal];
        break;
      case 'lunch':
        days![day]!.lunch = [newMeal];
        break;
      case 'dinner':
        days![day]!.dinner = [newMeal];
        break;
      case 'snacks':
        days![day]!.snacks = [newMeal];
        break;
    }
  }
}

@HiveType(typeId: 10)
class DayMeals {
  @HiveField(0)
  List<ReqMeal>? breakfast;

  @HiveField(1)
  List<ReqMeal>? lunch;

  @HiveField(2)
  List<ReqMeal>? dinner;

  @HiveField(3)
  List<ReqMeal>? snacks;

  DayMeals({
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snacks,
  });

  factory DayMeals.fromJson(Map<String, dynamic> json) {
    return DayMeals(
      breakfast: (json['breakfast'] as List?)
          ?.map((meal) => ReqMeal.fromJson(meal))
          .toList(),
      lunch: (json['lunch'] as List?)
          ?.map((meal) => ReqMeal.fromJson(meal))
          .toList(),
      dinner: (json['dinner'] as List?)
          ?.map((meal) => ReqMeal.fromJson(meal))
          .toList(),
      snacks: (json['snacks'] as List?)
          ?.map((meal) => ReqMeal.fromJson(meal))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast?.map((meal) => meal.toJson()).toList(),
      'lunch': lunch?.map((meal) => meal.toJson()).toList(),
      'dinner': dinner?.map((meal) => meal.toJson()).toList(),
      'snacks': snacks?.map((meal) => meal.toJson()).toList(),
    };
  }
}

// @HiveType(typeId: 9)
// class ReqMeal {
//   @HiveField(0)
//   List<int>? recipeId;

//   @HiveField(1)
//   List<int>? groceryId;

//   @HiveField(2)
//   bool? eatingOut;

//   ReqMeal({
//     this.recipeId,
//     this.groceryId,
//     this.eatingOut,
//   });

//   factory ReqMeal.fromJson(Map<String, dynamic> json) {
//     return ReqMeal(
//       recipeId: (json['recipe_id'] as List?)?.map((e) => e as int).toList(),
//       groceryId: (json['grocery_id'] as List?)?.map((e) => e as int).toList(),
//       eatingOut: json['eating_out'] as bool?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'recipe_id': recipeId,
//       'grocery_id': groceryId,
//       'eating_out': eatingOut,
//     };
//   }
// }
@HiveType(typeId: 9)
class ReqMeal {
  @HiveField(0)
  List<int>? recipeId;

  @HiveField(1)
  List<int>? groceryId;

  @HiveField(2)
  bool? eatingOut;

  @HiveField(3)
  List<Recipe>? recipes;

  @HiveField(4)
  List<Grocery>? groceries;

  ReqMeal({
    this.recipeId,
    this.groceryId,
    this.eatingOut,
    this.recipes,
    this.groceries,
  });

  factory ReqMeal.fromJson(Map<String, dynamic> json) {
    return ReqMeal(
      recipeId: (json['recipe_id'] as List?)?.map((e) => e as int).toList(),
      groceryId: (json['grocery_id'] as List?)?.map((e) => e as int).toList(),
      eatingOut: json['eating_out'] as bool?,

      recipes: (json['recipe'] as List<dynamic>?)
          ?.map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList(),

      // recipes: (json['recipe'] as List?)
      //     ?.map((e) => Recipe.fromJson(e as Map<String, dynamic>))
      //     .toList(),
      // groceries: (json['grocery'] as List?)
      //     ?.map((e) => Grocery.fromJson(e as Map<String, dynamic>))
      //     .toList(),

      groceries: (json['grocery'] as List<dynamic>?)
          ?.map((e) => Grocery.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipe_id': recipeId,
      'grocery_id': groceryId,
      'eating_out': eatingOut,
      'recipe': recipes?.map((e) => e.toJson()).toList(),
      'grocery': groceries?.map((e) => e.toJson()).toList(),
    };
  }
}

// import 'package:grocipe/core/models/grocery_list.dart';
// import 'package:grocipe/core/models/recipe.dart';
// import 'package:hive/hive.dart';

// part 'weekly_mealplan.g.dart';

// @HiveType(typeId: 11)
// class WeeklyMealPlan {
//   @HiveField(0)
//   int? id;

//   @HiveField(1)
//   String? weekStartDate;

//   @HiveField(2)
//   String? weekEndDate;

//   @HiveField(3)
//   Map<String, DayMeals>? days;

//   WeeklyMealPlan({
//     this.id,
//     this.weekStartDate,
//     this.weekEndDate,
//     this.days,
//   });

//   factory WeeklyMealPlan.fromJson(Map<String, dynamic> json) {
//     var daysData = json['days'];
//     Map<String, DayMeals>? parsedDays;

//     if (daysData is List) {
//       parsedDays = {};
//       for (var dayEntry in daysData) {
//         dayEntry.forEach((key, value) {
//           parsedDays![key] = DayMeals.fromJson(value);
//         });
//       }
//     } else if (daysData is Map) {
//       parsedDays = (daysData as Map<String, dynamic>).map(
//         (key, value) => MapEntry(key, DayMeals.fromJson(value)),
//       );
//     }

//     return WeeklyMealPlan(
//       id: json['id'] as int?,
//       weekStartDate: json['week_start_date'] as String?,
//       weekEndDate: json['week_end_date'] as String?,
//       days: parsedDays,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'week_start_date': weekStartDate,
//       'week_end_date': weekEndDate,
//       'days': days?.map((key, value) => MapEntry(key, value.toJson())),
//     };
//   }

//   void updateMeal(String day, String mealType, ReqMeal newMeal) {
//     days ??= {day: DayMeals(breakfast: [], lunch: [], dinner: [], snacks: [])};
//     days![day] ??= DayMeals();

//     switch (mealType) {
//       case 'breakfast':
//         days![day]!.breakfast = [newMeal];
//         break;
//       case 'lunch':
//         days![day]!.lunch = [newMeal];
//         break;
//       case 'dinner':
//         days![day]!.dinner = [newMeal];
//         break;
//       case 'snacks':
//         days![day]!.snacks = [newMeal];
//         break;
//     }
//   }
// }

// @HiveType(typeId: 10)
// class DayMeals {
//   @HiveField(0)
//   List<ReqMeal>? breakfast;

//   @HiveField(1)
//   List<ReqMeal>? lunch;

//   @HiveField(2)
//   List<ReqMeal>? dinner;

//   @HiveField(3)
//   List<ReqMeal>? snacks;

//   DayMeals({
//     this.breakfast,
//     this.lunch,
//     this.dinner,
//     this.snacks,
//   });

//   factory DayMeals.fromJson(Map<String, dynamic> json) {
//     return DayMeals(
//       breakfast: (json['breakfast'] as List?)
//           ?.map((meal) => ReqMeal.fromJson(meal))
//           .toList(),
//       lunch: (json['lunch'] as List?)
//           ?.map((meal) => ReqMeal.fromJson(meal))
//           .toList(),
//       dinner: (json['dinner'] as List?)
//           ?.map((meal) => ReqMeal.fromJson(meal))
//           .toList(),
//       snacks: (json['snacks'] as List?)
//           ?.map((meal) => ReqMeal.fromJson(meal))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'breakfast': breakfast?.map((meal) => meal.toJson()).toList(),
//       'lunch': lunch?.map((meal) => meal.toJson()).toList(),
//       'dinner': dinner?.map((meal) => meal.toJson()).toList(),
//       'snacks': snacks?.map((meal) => meal.toJson()).toList(),
//     };
//   }
// }

// @HiveType(typeId: 9)
// class ReqMeal {
//   @HiveField(0)
//   List<int>? recipeId;

//   @HiveField(1)
//   List<int>? groceryId;

//   @HiveField(2)
//   bool? eatingOut;

//   @HiveField(3)
//   List<Recipe>? recipes;

//   @HiveField(4)
//   List<Grocery>? groceries;

//   ReqMeal({
//     this.recipeId,
//     this.groceryId,
//     this.eatingOut,
//     this.recipes,
//     this.groceries,
//   });

//   factory ReqMeal.fromJson(Map<String, dynamic> json) {
//     return ReqMeal(
//       recipeId: (json['recipe_id'] as List?)?.map((e) => e as int).toList(),
//       groceryId: (json['grocery_id'] as List?)?.map((e) => e as int).toList(),
//       eatingOut: json['eating_out'] as bool?,
//       recipes: (json['recipe'] as List<dynamic>?)
//           ?.map((e) => Recipe.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       groceries: (json['grocery'] as List<dynamic>?)
//           ?.map((e) => Grocery.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'recipe_id': recipeId,
//       'grocery_id': groceryId,
//       'eating_out': eatingOut,
//       'recipe': recipes?.map((e) => e.toJson()).toList(),
//       'grocery': groceries?.map((e) => e.toJson()).toList(),
//     };
//   }
// }
