import 'dart:convert';

class Task {
  final String id;
  final String name;
  final String description;
  final bool done;
  final DateTime createdAt;

  
  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.done,
    required this.createdAt,
  });

  bool get ready => name.isNotEmpty && description.isNotEmpty;


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'done': done,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      done: map['done'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  Task copyWith({
    String? id,
    String? name,
    String? description,
    bool? done,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
