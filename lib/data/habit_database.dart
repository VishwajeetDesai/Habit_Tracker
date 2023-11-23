import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box('Habit_Database');

class HabitDatabase {
  List readData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      return [];
    } else {
      return _myBox.get(todaysDateFormatted());
    }
  }

  void updateData(List newHabitList) {
    _myBox.put(todaysDateFormatted(), newHabitList);
  }

  void updatePercentage(String newPercentage) {
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", newPercentage);
  }

  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  String getPercentage(String yyyymmdd) {
    return _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0";
  }
}
