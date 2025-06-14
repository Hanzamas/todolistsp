/// Core todo entity representing a task in the application
/// 
/// This is a domain entity that contains only business logic
/// and doesn't depend on any external frameworks
class Todo {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Todo({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  /// Creates a copy of this todo with the given fields replaced with new values
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Marks this todo as completed
  Todo complete() {
    return copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
  }

  /// Marks this todo as incomplete
  Todo incomplete() {
    return copyWith(
      isCompleted: false,
      completedAt: null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Todo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, isCompleted: $isCompleted)';
  }
}
