import 'package:hive/hive.dart';

part 'meal_type.g.dart';

@HiveType(typeId: 3)
class MealType extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  MealType({
    required this.id,
    required this.name,
  });

  factory MealType.fromJson(Map<String, dynamic> json) => MealType(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
