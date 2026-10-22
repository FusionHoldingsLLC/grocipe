import 'dart:convert';

class Nutrition {
  final String name;
  final String value;
  final int? id;
  Nutrition({required this.name, required this.value, this.id});

  Nutrition copyWith({
    String? name,
    String? value,
  }) {
    return Nutrition(
        name: name ?? this.name, value: value ?? this.value, id: id ?? id);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'value': value,
      'id': id,
    };
  }

  factory Nutrition.fromMap(Map<String, dynamic> map) {
    return Nutrition(
      name: map['name'] as String,
      value: map['value'] as String,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Nutrition.fromJson(String source) =>
      Nutrition.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Nutrition(name: $name, value: $value)';

  @override
  bool operator ==(covariant Nutrition other) {
    if (identical(this, other)) return true;

    return other.name == name && other.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
