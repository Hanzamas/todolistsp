import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Use case for managing todo operations
/// 
/// This class encapsulates all the business logic for todo operations
/// and acts as an intermediary between the presentation and data layers
class TodoUseCase {
  final TodoRepository _repository;

  const TodoUseCase(this._repository);

  /// Gets all todos from the repository
  Future<List<Todo>> getAllTodos() async {
    final todos = await _repository.getAllTodos();
    // Sort by creation date (newest first) and then by completion status
    todos.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1; // Incomplete first
      }
      return b.createdAt.compareTo(a.createdAt); // Newest first
    });
    return todos;
  }

  /// Creates a new todo
  Future<void> createTodo({
    required String title,
    String? description,
  }) async {
    if (title.trim().isEmpty) {
      throw ArgumentError('Todo title cannot be empty');
    }

    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description?.trim().isEmpty == true ? null : description?.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    await _repository.saveTodo(todo);
  }

  /// Updates an existing todo
  Future<void> updateTodo(Todo todo) async {
    if (todo.title.trim().isEmpty) {
      throw ArgumentError('Todo title cannot be empty');
    }
    await _repository.updateTodo(todo);
  }

  /// Toggles the completion status of a todo
  Future<void> toggleTodoCompletion(Todo todo) async {
    final updatedTodo = todo.isCompleted ? todo.incomplete() : todo.complete();
    await _repository.updateTodo(updatedTodo);
  }

  /// Deletes a todo
  Future<void> deleteTodo(String id) async {
    await _repository.deleteTodo(id);
  }

  /// Deletes all completed todos
  Future<void> deleteCompletedTodos() async {
    await _repository.deleteCompletedTodos();
  }

  /// Clears all todos
  Future<void> clearAllTodos() async {
    await _repository.clearAllTodos();
  }

  /// Gets statistics about todos
  Future<TodoStats> getTodoStats() async {
    final todos = await _repository.getAllTodos();
    final completed = todos.where((todo) => todo.isCompleted).length;
    final pending = todos.length - completed;
    
    return TodoStats(
      total: todos.length,
      completed: completed,
      pending: pending,
    );
  }
}

/// Statistics about todos
class TodoStats {
  final int total;
  final int completed;
  final int pending;

  const TodoStats({
    required this.total,
    required this.completed,
    required this.pending,
  });

  @override
  String toString() {
    return 'TodoStats(total: $total, completed: $completed, pending: $pending)';
  }
}
