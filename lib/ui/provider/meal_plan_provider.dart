import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MealPlanProvider extends ChangeNotifier {
  late DateTime startDate;
  late DateTime endDate;

  void init() {
    setWeek(DateTime.now());
  }

  void setWeek(DateTime date) {
    int currentDay = date.weekday;
    startDate = date
        .subtract(Duration(days: currentDay - 1)); // Assuming Sunday is day 1
    endDate = startDate.add(Duration(days: 6));
    notifyListeners();
  }

  void nextWeek() {
    setWeek(startDate.add(Duration(days: 7)));
  }

  void previousWeek() {
    setWeek(startDate.subtract(Duration(days: 7)));
  }
}
