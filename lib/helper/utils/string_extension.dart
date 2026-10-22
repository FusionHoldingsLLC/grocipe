import 'dart:convert';

extension StringExtension on String? {
  String get nullToEmpty => this ?? '';

  String? get emptyToNull => this?.trim() == '' ? null : this;

  String get capitalize {
    if (this == null) return '';
    return this![0].toUpperCase() + this!.substring(1);
  }

  bool get isEmptyOrNull {
    if (this == null) return true;
    if (this!.isEmpty) return true;
    return false;
  }

  String get capitalizeAllFirst {
    if (this == null) return '';
    List<String> words = this!.split(" ");
    return words.map((e) => e.capitalize).join(" ");
  }

  String pluralize([num? number]) {
    if (this == null) return '';
    if ((number ?? 1) > 1) return '${this!}s';
    return this!;
  }

  List<T> parseJsonList<T extends JsonConvertible<T>>(
      T Function(Map<String, dynamic>) fromJsonFactory) {
    if (this == null) {
      return [];
    }

    final parsed = json.decode(this!).cast<Map<String, dynamic>>();
    return parsed.map<T>((json) => fromJsonFactory(json)).toList();
  }

  DateTime? toDateTime() {
    if (this == null || this!.isEmpty) return null;
    try {
      return DateTime.parse(this!);
    } catch (e) {
      return null;
    }
  }
}

abstract class JsonConvertible<T> {
  T fromJson(Map<String, dynamic> json);
}
