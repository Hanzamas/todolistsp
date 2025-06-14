import '../entities/todo.dart';

/// Abstract repository interface defining todo operations
/// 
/// This interface belongs to the domain layer and doesn't know
/// about implementation details (shared_preferences, etc.)
abstract class TodoRepository {
  /// Retrieves all todos from storage
  Future<List<Todo>> getAllTodos();
  
  /// Saves a new todo to storage
  Future<void> saveTodo(Todo todo);
  
  /// Updates an existing todo
  Future<void> updateTodo(Todo todo);
  
  /// Deletes a todo by ID
  Future<void> deleteTodo(String id);
  
  /// Deletes all completed todos
  Future<void> deleteCompletedTodos();
  
  /// Clears all todos from storage
  Future<void> clearAllTodos();
}
