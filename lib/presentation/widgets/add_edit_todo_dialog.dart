import 'package:flutter/material.dart';

/// Dialog for adding or editing a todo
class AddEditTodoDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final bool isEditing;

  const AddEditTodoDialog({
    super.key,
    this.initialTitle,
    this.initialDescription,
    this.isEditing = false,
  });

  @override
  State<AddEditTodoDialog> createState() => _AddEditTodoDialogState();
}

class _AddEditTodoDialogState extends State<AddEditTodoDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Todo' : 'Add New Todo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter todo title...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Enter description...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submitForm(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submitForm,
          child: Text(widget.isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final result = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
      };
      Navigator.of(context).pop(result);
    }
  }
}
