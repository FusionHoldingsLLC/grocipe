import 'package:grocipe/models/grocery_list.dart';
import 'package:hive/hive.dart';

part 'meal_plan_menu.g.dart';

@HiveType(typeId: 16)
class MealPlanMenu {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? weekStartDate;

  @HiveField(2)
  String? weekEndDate;

  @HiveField(3)
  Map<String, DayMealsData>? days;

  MealPlanMenu({
    this.id,
    this.weekStartDate,
    this.weekEndDate,
    this.days,
  });

  factory MealPlanMenu.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? daysJson = json['days'];
    Map<String, DayMealsData>? days;
    if (daysJson != null) {
      days = {};
      daysJson.forEach((key, value) {
        days![key] = DayMealsData.fromJson(value);
      });
    }

    return MealPlanMenu(
      id: json['id'],
      weekStartDate: json['week_start_date'],
      weekEndDate: json['week_end_date'],
      days: days,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic>? daysJson;
    if (days != null) {
      daysJson = {};
      days!.forEach((key, value) {
        daysJson![key] = value.toJson();
      });
    }

    return {
      'id': id,
      'week_start_date': weekStartDate,
      'week_end_date': weekEndDate,
      'days': daysJson,
    };
  }
}

@HiveType(typeId: 15)
class DayMealsData {
  @HiveField(0)
  List<Meal>? breakfast;

  @HiveField(1)
  List<Meal>? lunch;

  @HiveField(2)
  List<Meal>? dinner;

  @HiveField(3)
  List<Meal>? others;

  DayMealsData({
    this.breakfast,
    this.lunch,
    this.dinner,
    this.others,
  });

  factory DayMealsData.fromJson(Map<String, dynamic> json) {
    List<Meal>? breakfast = (json['breakfast'] as List?)
        ?.map((item) => Meal.fromJson(item))
        .toList();
    List<Meal>? lunch =
        (json['lunch'] as List?)?.map((item) => Meal.fromJson(item)).toList();
    List<Meal>? dinner =
        (json['dinner'] as List?)?.map((item) => Meal.fromJson(item)).toList();
    List<Meal>? others =
        (json['others'] as List?)?.map((item) => Meal.fromJson(item)).toList();

    return DayMealsData(
      breakfast: breakfast,
      lunch: lunch,
      dinner: dinner,
      others: others,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast?.map((meal) => meal.toJson()).toList(),
      'lunch': lunch?.map((meal) => meal.toJson()).toList(),
      'dinner': dinner?.map((meal) => meal.toJson()).toList(),
      'others': others?.map((meal) => meal.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 14)
class Meal {
  @HiveField(0)
  List<MealplanRecipe>? recipe;

  @HiveField(1)
  List<Grocery>? grocery;

  @HiveField(2)
  bool? eatingOut;

  Meal({
    this.recipe,
    this.grocery,
    this.eatingOut,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<MealplanRecipe>? recipe = (json['recipe'] as List?)
        ?.map((item) => MealplanRecipe.fromJson(item))
        .toList();
    List<Grocery>? grocery = (json['grocery'] as List?)
        ?.map((item) => Grocery.fromJson(item))
        .toList();
    bool? eatingOut = json['eating_out'];

    return Meal(
      recipe: recipe,
      grocery: grocery,
      eatingOut: eatingOut,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipe': recipe?.map((recipe) => recipe.toJson()).toList(),
      'grocery': grocery?.map((item) => item.toJson()).toList(),
      'eating_out': eatingOut,
    };
  }
}

@HiveType(typeId: 23)
class MealplanRecipe {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  List<MealPlanIngredients>? ingredients;

  @HiveField(3)
  List<MealPlanNutritionalFacts>? nutritionalFacts;

  MealplanRecipe({this.id, this.name, this.ingredients, this.nutritionalFacts});

  MealplanRecipe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['ingredients'] != null) {
      ingredients = <MealPlanIngredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(MealPlanIngredients.fromJson(v));
      });
    }
    if (json['nutritional_facts'] != null) {
      nutritionalFacts = <MealPlanNutritionalFacts>[];
      json['nutritional_facts'].forEach((v) {
        nutritionalFacts!.add(MealPlanNutritionalFacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (ingredients != null) {
      data['ingredients'] = ingredients!.map((v) => v.toJson()).toList();
    }
    if (nutritionalFacts != null) {
      data['nutritional_facts'] =
          nutritionalFacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 22)
class MealPlanIngredients {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? ingredientId;

  @HiveField(2)
  MealPlanIngredient? ingredient;

  @HiveField(3)
  String? detail;

  MealPlanIngredients(
      {this.id, this.ingredientId, this.ingredient, this.detail});

  MealPlanIngredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ingredientId = json['ingredient_id'];
    ingredient = json['ingredient'] != null
        ? MealPlanIngredient.fromJson(json['ingredient'])
        : null;
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ingredient_id'] = ingredientId;
    if (ingredient != null) {
      data['ingredient'] = ingredient!.toJson();
    }
    data['detail'] = detail;
    return data;
  }
}

@HiveType(typeId: 21)
class MealPlanIngredient {
  @HiveField(0)
  String? name;

  @HiveField(1)
  int? groceryId;

  @HiveField(2)
  String? createdMode;

  MealPlanIngredient({this.name, this.groceryId, this.createdMode});

  MealPlanIngredient.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    groceryId = json['grocery_id'];
    createdMode = json['created_mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['grocery_id'] = groceryId;
    data['created_mode'] = createdMode;
    return data;
  }
}

@HiveType(typeId: 20)
class MealPlanNutritionalFacts {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? value;

  @HiveField(2)
  int? id;

  MealPlanNutritionalFacts({this.name, this.value, this.id});

  MealPlanNutritionalFacts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    data['id'] = id;
    return data;
  }
}
