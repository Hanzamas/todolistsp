import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

/// Local data source using SharedPreferences for todo storage
/// 
/// This class handles the low-level storage operations using shared_preferences
class TodoLocalDataSource {
  static const String _todosKey = 'todos_list';
  
  final SharedPreferences _prefs;

  const TodoLocalDataSource(this._prefs);

  /// Loads all todos from local storage
  Future<List<TodoModel>> loadTodos() async {
    try {
      final todosJson = _prefs.getString(_todosKey);
      if (todosJson == null || todosJson.isEmpty) {
        return [];
      }

      final List<dynamic> todosList = json.decode(todosJson);
      return todosList
          .map((todoJson) => TodoModel.fromJson(todoJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error loading todos, return empty list and clear corrupted data
      await _prefs.remove(_todosKey);
      return [];
    }
  }

  /// Saves todos list to local storage
  Future<void> saveTodos(List<TodoModel> todos) async {
    try {
      final todosJson = json.encode(todos.map((todo) => todo.toJson()).toList());
      await _prefs.setString(_todosKey, todosJson);
    } catch (e) {
      throw Exception('Failed to save todos: $e');
    }
  }

  /// Clears all todos from local storage
  Future<void> clearTodos() async {
    await _prefs.remove(_todosKey);
  }

  /// Checks if todos exist in local storage
  bool hasTodos() {
    final todosJson = _prefs.getString(_todosKey);
    return todosJson != null && todosJson.isNotEmpty;
  }
}
