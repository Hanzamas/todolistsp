import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

/// Implementation of TodoRepository using local data source
/// 
/// This class implements the repository interface and handles
/// the conversion between domain entities and data models
class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource _localDataSource;

  const TodoRepositoryImpl(this._localDataSource);

  @override
  Future<List<Todo>> getAllTodos() async {
    try {
      final todoModels = await _localDataSource.loadTodos();
      return todoModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to load todos: $e');
    }
  }

  @override
  Future<void> saveTodo(Todo todo) async {
    try {
      final todos = await _getAllTodoModels();
      final todoModel = TodoModel.fromEntity(todo);
      
      // Check if todo already exists and update it, otherwise add it
      final existingIndex = todos.indexWhere((t) => t.id == todo.id);
      if (existingIndex != -1) {
        todos[existingIndex] = todoModel;
      } else {
        todos.add(todoModel);
      }
      
      await _localDataSource.saveTodos(todos);
    } catch (e) {
      throw Exception('Failed to save todo: $e');
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      final todos = await _getAllTodoModels();
      final index = todos.indexWhere((t) => t.id == todo.id);
      
      if (index == -1) {
        throw Exception('Todo not found with id: ${todo.id}');
      }
      
      todos[index] = TodoModel.fromEntity(todo);
      await _localDataSource.saveTodos(todos);
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      final todos = await _getAllTodoModels();
      todos.removeWhere((todo) => todo.id == id);
      await _localDataSource.saveTodos(todos);
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }

  @override
  Future<void> deleteCompletedTodos() async {
    try {
      final todos = await _getAllTodoModels();
      todos.removeWhere((todo) => todo.isCompleted);
      await _localDataSource.saveTodos(todos);
    } catch (e) {
      throw Exception('Failed to delete completed todos: $e');
    }
  }

  @override
  Future<void> clearAllTodos() async {
    try {
      await _localDataSource.clearTodos();
    } catch (e) {
      throw Exception('Failed to clear all todos: $e');
    }
  }

  /// Helper method to get all todo models
  Future<List<TodoModel>> _getAllTodoModels() async {
    return await _localDataSource.loadTodos();
  }
}
