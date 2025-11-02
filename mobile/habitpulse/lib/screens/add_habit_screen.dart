import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../services/api_service.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _completedToday = false;
  final ApiService _apiService = ApiService();
  Habit? _habit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Habit) {
      _habit = args;
      _nameController.text = args.name;
      _descriptionController.text = args.description ?? '';
      _completedToday = args.completedToday;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final habit = Habit(
      id: _habit?.id,
      name: _nameController.text,
      description: _descriptionController.text,
      completedToday: _completedToday,
    );
    if (_habit == null) {
      await _apiService.createHabit(habit);
    } else {
      await _apiService.updateHabit(habit);
    }
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _habit != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Habit' : 'Add Habit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Habit name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _completedToday,
                onChanged: (value) => setState(() => _completedToday = value),
                title: const Text('Completed today'),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: Text(isEditing ? 'Update Habit' : 'Create Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
