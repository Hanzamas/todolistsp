import 'package:flutter/material.dart';
import '../../domain/entities/todo.dart';

/// Individual todo item widget with clean, modern design
class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: todo.isCompleted 
                        ? colorScheme.primary 
                        : colorScheme.outline,
                    width: 2,
                  ),
                  color: todo.isCompleted 
                      ? colorScheme.primary 
                      : Colors.transparent,
                ),
                child: todo.isCompleted
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: colorScheme.onPrimary,
                      )
                    : null,
              ),
              
              const SizedBox(width: 16),
              
              // Todo content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        decoration: todo.isCompleted 
                            ? TextDecoration.lineThrough 
                            : null,
                        color: todo.isCompleted 
                            ? colorScheme.onSurface.withOpacity(0.6)
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (todo.description != null && todo.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        todo.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: todo.isCompleted 
                              ? TextDecoration.lineThrough 
                              : null,
                          color: todo.isCompleted 
                              ? colorScheme.onSurface.withOpacity(0.4)
                              : colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(todo.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: colorScheme.error,
                    ),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todoDate = DateTime(date.year, date.month, date.day);
    
    if (todoDate == today) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (todoDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
