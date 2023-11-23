import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/monthly_summary.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/components/my_alert_box.dart';
import 'package:habit_tracker/controller/habit_tracker_state_provider.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  HabitDatabase db = HabitDatabase();

  @override
  void initState() {
    Provider.of<HabitTrackerStateProvider>(context, listen: false).initialize();
    super.initState();
  }

  bool habitCompleted = false;

  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: saveNewHabit,
          onCancel: cancelDialog,
          hintText: 'Enter Habit Name',
        );
      },
    );
  }

  void saveNewHabit() {
    Provider.of<HabitTrackerStateProvider>(context, listen: false).addHabit(
      Habit(
        habitName: _newHabitNameController.text,
        checked: false,
      ),
    );

    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void cancelDialog() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    final provider =
        Provider.of<HabitTrackerStateProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialog,
          hintText: provider.allHabit[index].habitName,
        );
      },
    );
  }

  void saveExistingHabit(int index) {
    final provider =
        Provider.of<HabitTrackerStateProvider>(context, listen: false);

    provider.updateHabitName(
        provider.allHabit[index], _newHabitNameController.text);
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitTrackerStateProvider>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: MyFloatingActionButton(
          onPressed: () => createNewHabit(),
        ),
        body: ListView(
          children: [
            MonthlySummary(
              startDate: value.startDate,
              datasets: value.heatMapDataset,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.allHabit.length,
              itemBuilder: (context, index) {
                return HabitTile(
                  habitName: value.allHabit[index].habitName,
                  habitCompleted: value.allHabit[index].checked,
                  onChanged: (change) =>
                      value.updateHabitCheckStatus(value.allHabit[index]),
                  settingsTapped: (context) => openHabitSettings(index),
                  deleteTapped: (context) =>
                      value.deleteHabit(value.allHabit[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
