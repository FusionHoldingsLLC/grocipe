import 'package:hive/hive.dart';

part 'nutrition.g.dart';

@HiveType(typeId: 4)
class NutritionalFact extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String value;

  @HiveField(2)
  int id;

  NutritionalFact({
    required this.name,
    required this.value,
    required this.id,
  });

  factory NutritionalFact.fromJson(Map<String, dynamic> json) =>
      NutritionalFact(
        name: json['name'],
        value: json['value'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
        'id': id,
      };
}
