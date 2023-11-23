import 'package:flutter/material.dart';
import 'package:habit_tracker/controller/habit_tracker_state_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox("Habit_Database");
  runApp(
    ChangeNotifierProvider(
      create: (context) => HabitTrackerStateProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
