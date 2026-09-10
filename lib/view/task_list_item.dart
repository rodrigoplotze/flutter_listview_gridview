import 'package:flutter/material.dart';

import '../model/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onAlterarStatus;
  final VoidCallback onEditar;
  final VoidCallback onRemover;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onAlterarStatus,
    required this.onEditar,
    required this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Checkbox(
          value: task.concluida,
          onChanged: (_) => onAlterarStatus(),
        ),
        title: Text(
          task.titulo,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: task.concluida
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.concluida
                ? colorScheme.onSurfaceVariant
                : colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            task.descricao,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'editar':
                onEditar();
                break;
              case 'remover':
                onRemover();
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'editar',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'remover',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Remover'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}