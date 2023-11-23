import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';

import '../datetime/date_time.dart';

class HabitTrackerStateProvider extends ChangeNotifier {
  List<Habit> allHabit = [];
  Map<DateTime, int> heatMapDataset = {};

  HabitDatabase db = HabitDatabase();

  void initialize() {
    List habitList = db.readData();
    for (int i = 0; i < habitList.length; i++) {
      Habit habit = Habit(habitName: habitList[i][0], checked: habitList[i][1]);
      allHabit.add(habit);
    }
    calculateHabitPercentage();
    loadHeatMap();
  }

  void addHabit(Habit newHabit) {
    allHabit.add(newHabit);
    db.updateData(getList());
    calculateHabitPercentage();
    loadHeatMap();
    notifyListeners();
  }

  void updateHabitCheckStatus(Habit currentHabit) {
    Habit changedHabit = Habit(
        habitName: currentHabit.habitName, checked: !currentHabit.checked);
    allHabit.remove(currentHabit);
    allHabit.add(changedHabit);
    db.updateData(getList());
    calculateHabitPercentage();
    loadHeatMap();
    notifyListeners();
  }

  void updateHabitName(Habit currentHabit, String newHabitName) {
    Habit changedHabit =
        Habit(habitName: newHabitName, checked: currentHabit.checked);
    allHabit.remove(currentHabit);
    allHabit.add(changedHabit);
    db.updateData(getList());

    notifyListeners();
  }

  void deleteHabit(Habit habit) {
    allHabit.remove(habit);
    db.updateData(getList());
    calculateHabitPercentage();
    loadHeatMap();
    notifyListeners();
  }

  void calculateHabitPercentage() {
    int countComplete = 0;
    for (int i = 0; i < allHabit.length; i++) {
      if (allHabit[i].checked == true) {
        countComplete++;
      }
    }
    String percent = allHabit.isEmpty
        ? '0.0'
        : (countComplete / allHabit.length).toStringAsFixed(1);
    db.updatePercentage(percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(db.getStartDate());

    int daysInBetween = DateTime.now().difference(startDate).inDays;
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        db.getPercentage(yyyymmdd),
      );

      // split the datetime up like below so it doesn't worry about hours/mins/secs etc.

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataset.addEntries(percentForEachDay.entries);
      // print(heatMapDataset);
    }
  }

  String get startDate {
    return db.getStartDate();
  }

  List getList() {
    List formattedList = [];
    for (int i = 0; i < allHabit.length; i++) {
      formattedList.add([allHabit[i].habitName, allHabit[i].checked]);
    }
    return formattedList;
  }
}
