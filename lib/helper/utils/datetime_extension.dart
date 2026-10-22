import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExt on DateTime? {
  int get secondsSinceEpoch {
    if (this == null) return 0;
    return (this!.millisecondsSinceEpoch / 1000).round();
  }

  // 5 Jul, 2021
  String get dateReadable {
    if (this == null) return '';
    return DateFormat('dd MMM, yyyy').format(this!);
  }

  DateTime? get dateOnly {
    if (this == null) return null;
    return DateTime(this!.year, this!.month, this!.day);
  }

  bool get isToday {
    if (this == null) return false;
    final now = DateTime.now();
    return now.dateReadable == this!.dateReadable;
  }

  String get mmmdyyyy {
    if (this == null) return '';
    return DateFormat('MMM d, yyyy').format(this!);
  }

  // 5 July, 2021
  String get dateReadableFull {
    if (this == null) return '';
    return DateFormat('dd MMMM, yyyy').format(this!);
  }

  // 5 July, 2021 2:42 PM
  String get dateReadableFullWithTime {
    if (this == null) return '';
    return DateFormat('dd MMMM, yyyy').add_jm().format(this!);
  }

  // 02:31 PM Aug 19, 2023
  String get readableTimeDateYear {
    if (this == null) return '';
    return DateFormat('hh:mm a MMM d, yyyy').format(this!);
  }

  //10/12/2022
  String get toSlashSeparated {
    if (this == null) return '';
    return DateFormat('dd/MM/yyyy').format(this!);
  }

  //2022-03-21
  String get toDashSeparatedYearFirst {
    if (this == null) return '';
    return DateFormat('yyyy-MM-dd').format(this!);
  }

  //10/12/2022, 10:30 AM
  String get dateWithTime {
    if (this == null) return '';
    return DateFormat('dd/MM/yyyy,').add_jm().format(this!);
  }

  //10:30 AM
  String get onlyTime {
    if (this == null) return '';
    return DateFormat.jm().format(this!);
  }

  bool isSameDay(DateTime other) {
    if (this == null) return false;
    return this!.year == other.year &&
        this!.month == other.month &&
        this!.day == other.day;
  }
}

extension TimeOfDayExt on TimeOfDay? {
  String get to24hoursTime {
    if (this == null) return '';
    DateTime tempDate = DateFormat.Hm().parse("${this!.hour}:${this!.minute}");
    var dateFormat = DateFormat.Hm();
    return dateFormat.format(tempDate);
  }

  String get to12hoursTime {
    if (this == null) return '';
    DateTime tempDate = DateFormat.Hm().parse("${this!.hour}:${this!.minute}");
    var dateFormat = DateFormat.jm();
    return dateFormat.format(tempDate);
  }
}
