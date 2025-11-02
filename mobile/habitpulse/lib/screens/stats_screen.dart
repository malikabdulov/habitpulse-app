import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/habit.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  List<BarChartGroupData> _buildChartData(List<Habit> habits) {
    final completedCount = habits.where((habit) => habit.completedToday).length;
    final pendingCount = habits.length - completedCount;

    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(toY: completedCount.toDouble(), color: Colors.green, width: 22),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: pendingCount.toDouble(), color: Colors.orange, width: 22),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final habits = ModalRoute.of(context)?.settings.arguments as List<Habit>? ?? [];
    final maxY = math.max(habits.length.toDouble(), 1.0);
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Snapshot')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'This week',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text('Completed'),
                              );
                            case 1:
                              return const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text('Pending'),
                              );
                            default:
                              return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                  barGroups: _buildChartData(habits),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
