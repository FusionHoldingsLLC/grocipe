import 'package:hive/hive.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 6)
class Ingredient extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int ingredientId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String? detail;

  @HiveField(4)
  int? groceryId;

  Ingredient({
    required this.id,
    required this.ingredientId,
    required this.name,
    this.detail,
    this.groceryId,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json['id'],
        ingredientId: json['ingredient_id'],
        name: json['ingredient']['name'],
        groceryId: json['ingredient']['grocery_id'],
        detail: json['detail'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ingredient_id': ingredientId,
        'name': name,
        'grocery_id': groceryId,
        'detail': detail,
      };

  Map<String, dynamic> toApiJson() => {
        'id': id,
        'ingredient_id': ingredientId,
        "ingredient": {
          'name': name,
          "grocery_id": groceryId,
          "created_mode": "manual"
        },
        'detail': detail,
      };
}
