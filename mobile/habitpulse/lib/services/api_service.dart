import 'package:dio/dio.dart';

import '../models/habit.dart';

class ApiService {
  ApiService({Dio? client}) : _client = client ?? Dio();

  final Dio _client;
  static const String _baseUrl = String.fromEnvironment(
    'HABITPULSE_API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  Future<List<Habit>> fetchHabits() async {
    final response = await _client.get('$_baseUrl/habits');
    final data = response.data as List<dynamic>;
    return data.map((json) => Habit.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Habit> createHabit(Habit habit) async {
    final response = await _client.post('$_baseUrl/habits', data: habit.toJson());
    return Habit.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Habit> updateHabit(Habit habit) async {
    if (habit.id == null) {
      throw ArgumentError('Habit id is required for update');
    }
    final response = await _client.put('$_baseUrl/habits/${habit.id}', data: habit.toJson());
    return Habit.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteHabit(int id) async {
    await _client.delete('$_baseUrl/habits/$id');
  }
}
