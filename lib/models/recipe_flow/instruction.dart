import 'dart:convert';

class Instruction {
  final int order;
  final int? id;
  final String title;
  final String details;

  Duration? duration;
  Instruction(
      {required this.title,
      required this.details,
      required this.duration,
      this.id,
      required this.order});

  Instruction copyWith({
    String? title,
    String? details,
    Duration? duration,
    int? order,
    int? id,
  }) {
    return Instruction(
      title: title ?? this.title,
      details: details ?? this.details,
      duration: duration ?? this.duration,
      order: order ?? this.order,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'instruction': title,
      'order': order,
      'id': id,
      'duration': duration!.inMinutes,
    };
  }

  factory Instruction.fromMap(Map<String, dynamic> map) {
    return Instruction(
      title: map['title'] as String,
      details: map['details'] as String,
      duration: Duration(minutes: map['duration']),
      order: map['order'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Instruction.fromJson(String source) =>
      Instruction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Instruction(title: $title, details: $details, duration: $duration)';

  @override
  bool operator ==(covariant Instruction other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.details == details &&
        other.duration == duration;
  }

  @override
  int get hashCode => title.hashCode ^ details.hashCode ^ duration.hashCode;
}
