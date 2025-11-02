import 'package:flutter/material.dart';

import 'screens/add_habit_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/stats_screen.dart';

void main() {
  runApp(const HabitPulseApp());
}

class HabitPulseApp extends StatelessWidget {
  const HabitPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/add': (context) => const AddHabitScreen(),
        '/stats': (context) => const StatsScreen(),
      },
    );
  }
}
