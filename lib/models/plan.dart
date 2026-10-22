import 'package:grocipe/models/meal_plan_menu.dart';

class Plan {
  final String day;
  final String meal;
  final DateTime startDate;
  final DateTime endDate;
  final bool dateIsRegistered;

  Plan(
      {required this.day,
      required this.meal,
      required this.startDate,
      required this.endDate,
      this.dateIsRegistered = false});

  Map<String, dynamic> toJson() => {
        'day': day,
        'meal': meal,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'dateIsRegistered': dateIsRegistered,
      };

  // Factory constructor to create a Plan object from JSON
  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      day: json['day'],
      meal: json['meal'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      dateIsRegistered: json['dateIsRegistered'] ?? false,
    );
  }
}

class PlanExtras {
  final Plan plan;
  final MealPlanMenu mealPlanMenu;

  PlanExtras({
    required this.plan,
    required this.mealPlanMenu,
  });

  factory PlanExtras.fromJson(Map<String, dynamic> json) {
    return PlanExtras(
      plan: Plan.fromJson(json['plan']),
      mealPlanMenu: MealPlanMenu.fromJson(json['mealPlanMenu']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan': plan.toJson(),
      'mealPlanMenu': mealPlanMenu.toJson(),
    };
  }
}
