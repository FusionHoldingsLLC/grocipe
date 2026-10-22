import 'dart:convert';
import 'package:hive/hive.dart';

part 'instruction.g.dart';

@HiveType(typeId: 2)
class Instruction2 extends HiveObject {
  @HiveField(0)
  final int order;

  @HiveField(1)
  final String instruction;

  @HiveField(2)
  final int id;

  @HiveField(3)
  int? duration;

  Instruction2({
    required this.instruction,
    required this.id,
    required this.duration,
    required this.order,
  });

  Instruction2 copyWith({
    String? instruction,
    int? id,
    int? duration,
    int? order,
  }) {
    return Instruction2(
      instruction: instruction ?? this.instruction,
      id: id ?? this.id,
      duration: duration ?? this.duration,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'instruction': instruction,
      'order': order,
      'duration': duration,
      'id': id,
    };
  }

  factory Instruction2.fromMap(Map<String, dynamic> map) {
    return Instruction2(
      instruction: map['instruction'] as String,
      id: map['id'] as int,
      duration: map['duration'] != null ? map['duration'] as int : null,
      order: map['order'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Instruction2.fromJson(String source) =>
      Instruction2.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Instruction2(instruction: $instruction, id: $id, duration: $duration, order: $order)';

  @override
  bool operator ==(covariant Instruction2 other) {
    if (identical(this, other)) return true;

    return other.instruction == instruction &&
        other.id == id &&
        other.duration == duration &&
        other.order == order;
  }

  @override
  int get hashCode =>
      instruction.hashCode ^ id.hashCode ^ duration.hashCode ^ order.hashCode;
}
