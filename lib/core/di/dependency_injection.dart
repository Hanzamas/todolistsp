import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/todo_local_datasource.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/todo_usecase.dart';
import '../../presentation/providers/todo_notifier.dart';

/// Dependency injection container for the application
/// 
/// This class sets up all the dependencies following clean architecture principles
class DependencyInjection {
  static TodoNotifier? _todoNotifier;

  /// Gets the todo notifier instance (singleton)
  static Future<TodoNotifier> getTodoNotifier() async {
    if (_todoNotifier != null) {
      return _todoNotifier!;
    }

    // Initialize shared preferences
    final sharedPreferences = await SharedPreferences.getInstance();

    // Create data source
    final todoLocalDataSource = TodoLocalDataSource(sharedPreferences);

    // Create repository
    final TodoRepository todoRepository = TodoRepositoryImpl(todoLocalDataSource);

    // Create use case
    final todoUseCase = TodoUseCase(todoRepository);

    // Create notifier
    _todoNotifier = TodoNotifier(todoUseCase);

    return _todoNotifier!;
  }

  /// Disposes all resources
  static void dispose() {
    _todoNotifier?.dispose();
    _todoNotifier = null;
  }
}
