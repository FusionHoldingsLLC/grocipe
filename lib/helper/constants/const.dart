String convertToDateString(DateTime dateTime) {
    DateTime dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return "${dateOnly.year.toString().padLeft(4, '0')}-${dateOnly.month.toString().padLeft(2, '0')}-${dateOnly.day.toString().padLeft(2, '0')}";
  }