import 'package:flutter/foundation.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/todo_usecase.dart';

/// State management for the todo list
/// 
/// This class manages the application state and provides methods
/// for the UI to interact with the todo data
class TodoNotifier extends ChangeNotifier {
  final TodoUseCase _todoUseCase;
  
  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;

  TodoNotifier(this._todoUseCase);

  // Getters
  List<Todo> get todos => List.unmodifiable(_todos);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _todos.isEmpty;
  
  List<Todo> get completedTodos => _todos.where((todo) => todo.isCompleted).toList();
  List<Todo> get pendingTodos => _todos.where((todo) => !todo.isCompleted).toList();
  
  int get totalCount => _todos.length;
  int get completedCount => completedTodos.length;
  int get pendingCount => pendingTodos.length;

  /// Loads all todos from storage
  Future<void> loadTodos() async {
    _setLoading(true);
    _clearError();
    
    try {
      _todos = await _todoUseCase.getAllTodos();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load todos: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Creates a new todo
  Future<void> createTodo({
    required String title,
    String? description,
  }) async {
    try {
      _clearError();
      await _todoUseCase.createTodo(title: title, description: description);
      await loadTodos(); // Reload to get updated list
    } catch (e) {
      _setError('Failed to create todo: $e');
    }
  }

  /// Updates an existing todo
  Future<void> updateTodo(Todo todo) async {
    try {
      _clearError();
      await _todoUseCase.updateTodo(todo);
      await loadTodos(); // Reload to get updated list
    } catch (e) {
      _setError('Failed to update todo: $e');
    }
  }

  /// Toggles the completion status of a todo
  Future<void> toggleTodoCompletion(Todo todo) async {
    try {
      _clearError();
      await _todoUseCase.toggleTodoCompletion(todo);
      await loadTodos(); // Reload to get updated list
    } catch (e) {
      _setError('Failed to toggle todo: $e');
    }
  }

  /// Deletes a todo
  Future<void> deleteTodo(String id) async {
    try {
      _clearError();
      await _todoUseCase.deleteTodo(id);
      await loadTodos(); // Reload to get updated list
    } catch (e) {
      _setError('Failed to delete todo: $e');
    }
  }

  /// Deletes all completed todos
  Future<void> deleteCompletedTodos() async {
    try {
      _clearError();
      await _todoUseCase.deleteCompletedTodos();
      await loadTodos(); // Reload to get updated list
    } catch (e) {
      _setError('Failed to delete completed todos: $e');
    }
  }

  /// Clears all todos
  Future<void> clearAllTodos() async {
    try {
      _clearError();
      await _todoUseCase.clearAllTodos();
      await loadTodos(); // Reload to get updated list
    } catch (e) {
      _setError('Failed to clear all todos: $e');
    }
  }

  /// Clears the current error
  void clearError() {
    _clearError();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
