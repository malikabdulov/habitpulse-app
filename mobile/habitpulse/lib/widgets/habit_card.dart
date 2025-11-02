import 'package:flutter/material.dart';

import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({super.key, required this.habit, this.onToggle, this.onDelete, this.onTap});

  final Habit habit;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (habit.description != null && habit.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          habit.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        habit.completedToday ? 'Completed today' : 'Pending today',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: habit.completedToday ? Colors.green : Colors.orange,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      habit.completedToday ? Icons.check_box : Icons.check_box_outline_blank,
                    ),
                    onPressed: onToggle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
