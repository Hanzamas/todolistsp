import 'package:flutter/material.dart';
import '../../domain/entities/todo.dart';
import '../providers/todo_notifier.dart';
import '../widgets/add_edit_todo_dialog.dart';
import '../widgets/todo_item.dart';

/// Main todo list screen
class TodoListScreen extends StatefulWidget {
  final TodoNotifier todoNotifier;

  const TodoListScreen({
    super.key,
    required this.todoNotifier,
  });

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    // Load todos when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.todoNotifier.loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_completed',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Clear Completed'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep),
                    SizedBox(width: 8),
                    Text('Clear All'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.todoNotifier,
        builder: (context, child) {
          if (widget.todoNotifier.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (widget.todoNotifier.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.todoNotifier.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      widget.todoNotifier.clearError();
                      widget.todoNotifier.loadTodos();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (widget.todoNotifier.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No todos yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first todo',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Stats header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Todo Statistics',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          context,
                          'Total',
                          widget.todoNotifier.totalCount.toString(),
                          Icons.list_alt,
                        ),
                        _buildStatItem(
                          context,
                          'Pending',
                          widget.todoNotifier.pendingCount.toString(),
                          Icons.pending_actions,
                        ),
                        _buildStatItem(
                          context,
                          'Completed',
                          widget.todoNotifier.completedCount.toString(),
                          Icons.task_alt,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Todo list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: widget.todoNotifier.todos.length,
                  itemBuilder: (context, index) {
                    final todo = widget.todoNotifier.todos[index];
                    return TodoItem(
                      todo: todo,
                      onToggle: () => widget.todoNotifier.toggleTodoCompletion(todo),
                      onEdit: () => _editTodo(todo),
                      onDelete: () => _deleteTodo(todo),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Future<void> _addTodo() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddEditTodoDialog(),
    );

    if (result != null) {
      await widget.todoNotifier.createTodo(
        title: result['title'] as String,
        description: result['description'] as String?,
      );
    }
  }

  Future<void> _editTodo(Todo todo) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddEditTodoDialog(
        initialTitle: todo.title,
        initialDescription: todo.description,
        isEditing: true,
      ),
    );

    if (result != null) {
      final updatedTodo = todo.copyWith(
        title: result['title'] as String,
        description: result['description'] as String?,
      );
      await widget.todoNotifier.updateTodo(updatedTodo);
    }
  }

  Future<void> _deleteTodo(Todo todo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.todoNotifier.deleteTodo(todo.id);
    }
  }

  Future<void> _handleMenuAction(String action) async {
    switch (action) {
      case 'clear_completed':
        final confirmed = await _showConfirmationDialog(
          'Clear Completed Todos',
          'Are you sure you want to delete all completed todos?',
        );
        if (confirmed) {
          await widget.todoNotifier.deleteCompletedTodos();
        }
        break;
      case 'clear_all':
        final confirmed = await _showConfirmationDialog(
          'Clear All Todos',
          'Are you sure you want to delete all todos? This action cannot be undone.',
        );
        if (confirmed) {
          await widget.todoNotifier.clearAllTodos();
        }
        break;
    }
  }

  Future<bool> _showConfirmationDialog(String title, String content) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
