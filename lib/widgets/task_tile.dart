// Feedback de task_tile.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../theme/colors.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?) onChanged;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
    this.onEdit,
  });

  void _confirmDelete(BuildContext context) {
    final statusText = task.isDone ? 'completada' : 'incompleta';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('La tarea está $statusText. ¿Deseas eliminarla?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(ctx).pop();
            },
            child: const Text('Eliminar', style: TextStyle(color: error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : null,
                        color: text,
                      ),
                    ),
                    if (task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Checkbox(
                value: task.isDone,
                onChanged: onChanged,
                activeColor: primary,
                checkColor: Colors.white,
              ),
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit, color: primary),
                  onPressed: onEdit,
                ),
              IconButton(
                icon: const Icon(Icons.delete, color: error),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
