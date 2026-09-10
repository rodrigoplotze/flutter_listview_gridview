import 'package:flutter/material.dart';

import '../model/task.dart';

class TaskGridItem extends StatelessWidget {
  final Task task;
  final VoidCallback onAlterarStatus;
  final VoidCallback onEditar;
  final VoidCallback onRemover;

  const TaskGridItem({
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
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onAlterarStatus,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: task.concluida,
                    onChanged: (_) => onAlterarStatus(),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Editar',
                    onPressed: onEditar,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: 'Remover',
                    onPressed: onRemover,
                    icon: Icon(
                      Icons.delete_outline,
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                task.titulo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: task.concluida
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  task.descricao,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ),
              const SizedBox(height: 8),
              Chip(
                avatar: Icon(
                  task.concluida
                      ? Icons.check_circle
                      : Icons.pending,
                  size: 18,
                ),
                label: Text(
                  task.concluida
                      ? 'Concluída'
                      : 'Pendente',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}