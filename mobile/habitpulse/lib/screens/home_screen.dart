import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../services/api_service.dart';
import '../widgets/habit_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  Future<List<Habit>>? _habitsFuture;
  String? _username;
  bool _initialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialised) {
      _username = ModalRoute.of(context)?.settings.arguments as String?;
      _loadHabits();
      _initialised = true;
    }
  }

  Future<void> _loadHabits() async {
    setState(() {
      _habitsFuture = _apiService.fetchHabits();
    });
  }

  void _navigateToAddHabit([Habit? habit]) async {
    final result = await Navigator.of(context).pushNamed('/add', arguments: habit);
    if (result == true) {
      await _loadHabits();
    }
  }

  Future<void> _toggleCompletion(Habit habit) async {
    final updatedHabit = habit.copyWith(completedToday: !habit.completedToday);
    await _apiService.updateHabit(updatedHabit);
    await _loadHabits();
  }

  Future<void> _deleteHabit(Habit habit) async {
    if (habit.id == null) return;
    await _apiService.deleteHabit(habit.id!);
    await _loadHabits();
  }

  void _openStats(List<Habit> habits) {
    Navigator.of(context).pushNamed('/stats', arguments: habits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${_username ?? ''}'.trim()),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: () async {
              final habits = await (_habitsFuture ?? Future.value(<Habit>[]));
              if (context.mounted) {
                _openStats(habits);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Habit>>(
        future: _habitsFuture,
        builder: (context, snapshot) {
          if (_habitsFuture == null || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load habits: ${snapshot.error}'));
          }
          final habits = snapshot.data ?? [];
          if (habits.isEmpty) {
            return const Center(child: Text('No habits yet. Tap + to add one.'));
          }
          return RefreshIndicator(
            onRefresh: _loadHabits,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final habit = habits[index];
                return HabitCard(
                  habit: habit,
                  onToggle: () => _toggleCompletion(habit),
                  onDelete: () => _deleteHabit(habit),
                  onTap: () => _navigateToAddHabit(habit),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: habits.length,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddHabit(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
