import '../../domain/entities/todo.dart';

/// Data model for Todo that can be serialized to/from JSON
/// 
/// This model is used for data persistence and conversion
class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    super.description,
    required super.isCompleted,
    required super.createdAt,
    super.completedAt,
  });

  /// Creates TodoModel from domain Todo entity
  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
      createdAt: todo.createdAt,
      completedAt: todo.completedAt,
    );
  }

  /// Creates TodoModel from JSON map
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  /// Converts TodoModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// Converts TodoModel to domain Todo entity
  Todo toEntity() {
    return Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
      completedAt: completedAt,
    );
  }

  @override
  String toString() {
    return 'TodoModel(${toJson()})';
  }
}
