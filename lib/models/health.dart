import 'package:hive/hive.dart';

part 'health.g.dart';

@HiveType(typeId: 7)
class HealthReport extends HiveObject {
  @HiveField(0)
  String note;

  @HiveField(1)
  int id;

  HealthReport({
    required this.note,
    required this.id,
  });

  factory HealthReport.fromJson(Map<String, dynamic> json) => HealthReport(
        note: json['note'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'note': note,
        'id': id,
      };
}
