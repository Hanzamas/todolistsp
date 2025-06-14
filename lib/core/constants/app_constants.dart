/// Application constants
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // App info
  static const String appName = 'Todo List Minimalis';
  static const String appVersion = '1.0.0';

  // Shared preferences keys
  static const String todosStorageKey = 'todos_list';

  // UI constants
  static const double cardBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
