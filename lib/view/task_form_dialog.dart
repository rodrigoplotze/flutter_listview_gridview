import 'package:flutter/material.dart';

import '../model/task.dart';

class TaskFormResult {
  final String titulo;
  final String descricao;

  const TaskFormResult({
    required this.titulo,
    required this.descricao,
  });
}

class TaskFormDialog extends StatefulWidget {
  final Task? task;

  const TaskFormDialog({
    super.key,
    this.task,
  });

  @override
  State<TaskFormDialog> createState() =>
      _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _tituloController;
  late final TextEditingController _descricaoController;

  bool get editando => widget.task != null;

  @override
  void initState() {
    super.initState();

    _tituloController = TextEditingController(
      text: widget.task?.titulo ?? '',
    );

    _descricaoController = TextEditingController(
      text: widget.task?.descricao ?? '',
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      TaskFormResult(
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        editando ? 'Atualizar tarefa' : 'Adicionar tarefa',
      ),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _tituloController,
                  autofocus: true,
                  textCapitalization:
                      TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Digite o título da tarefa',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Informe o título da tarefa.';
                    }

                    if (value.trim().length < 3) {
                      return 'O título deve possuir pelo menos 3 caracteres.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descricaoController,
                  maxLines: 4,
                  textCapitalization:
                      TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Descreva a tarefa',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Informe a descrição da tarefa.';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _salvar,
          icon: const Icon(Icons.save),
          label: Text(editando ? 'Atualizar' : 'Adicionar'),
        ),
      ],
    );
  }
}