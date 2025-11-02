class Habit {
  final int? id;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final bool completedToday;

  Habit({
    this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.completedToday = false,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt:
          json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      completedToday: json['completed_today'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'completed_today': completedToday,
    };
  }

  Habit copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
    bool? completedToday,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedToday: completedToday ?? this.completedToday,
    );
  }
}
