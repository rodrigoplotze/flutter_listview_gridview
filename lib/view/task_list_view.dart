import 'package:flutter/material.dart';

import '../controller/task_controller.dart';
import '../core/dependency_injection.dart';
import '../model/task.dart';
import 'task_form_dialog.dart';
import 'task_grid_item.dart';
import 'task_list_item.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() =>
      _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final TaskController controller = getIt<TaskController>();
  final TextEditingController pesquisaController =
      TextEditingController();

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  Future<void> _abrirFormulario({
    Task? task,
  }) async {
    final resultado = await showDialog<TaskFormResult>(
      context: context,
      builder: (context) {
        return TaskFormDialog(task: task);
      },
    );

    if (resultado == null) {
      return;
    }

    if (task == null) {
      controller.adicionarTask(
        titulo: resultado.titulo,
        descricao: resultado.descricao,
      );

      _mostrarMensagem('Tarefa adicionada com sucesso.');
    } else {
      controller.atualizarTask(
        id: task.id,
        titulo: resultado.titulo,
        descricao: resultado.descricao,
      );

      _mostrarMensagem('Tarefa atualizada com sucesso.');
    }
  }

  Future<void> _confirmarRemocao(Task task) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remover tarefa'),
          content: Text(
            'Deseja realmente remover a tarefa '
            '"${task.titulo}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.error,
              ),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      controller.removerTask(task.id);
      _mostrarMensagem('Tarefa removida.');
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final tasks = controller.tasksFiltradas;

        return Scaffold(
          appBar: AppBar(
            title: const Text('TaskList'),
            actions: [
              IconButton(
                tooltip: controller.exibindoLista
                    ? 'Exibir como grade'
                    : 'Exibir como lista',
                onPressed: controller.alternarVisualizacao,
                icon: Icon(
                  controller.exibindoLista
                      ? Icons.grid_view
                      : Icons.view_list,
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1100,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _cabecalho(),
                      const SizedBox(height: 16),
                      _campoPesquisa(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: tasks.isEmpty
                            ? _estadoVazio()
                            : controller.exibindoLista
                                ? _lista(tasks)
                                : _grade(tasks),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _abrirFormulario,
            icon: const Icon(Icons.add),
            label: const Text('Nova tarefa'),
          ),
        );
      },
    );
  }

  Widget _cabecalho() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _indicador(
                titulo: 'Total',
                valor: controller.quantidadeTotal,
                icone: Icons.list_alt,
                cor: Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _indicador(
                titulo: 'Pendentes',
                valor: controller.quantidadePendentes,
                icone: Icons.pending_actions,
                cor: Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _indicador(
                titulo: 'Concluídas',
                valor: controller.quantidadeConcluidas,
                icone: Icons.task_alt,
                cor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _indicador({
    required String titulo,
    required int valor,
    required IconData icone,
    required Color cor,
  }) {
    return Column(
      children: [
        Icon(icone, color: cor),
        const SizedBox(height: 4),
        Text(
          valor.toString(),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _campoPesquisa() {
    return TextField(
      controller: pesquisaController,
      onChanged: controller.pesquisar,
      decoration: InputDecoration(
        labelText: 'Pesquisar tarefas',
        hintText: 'Digite o título ou a descrição',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.termoPesquisa.isNotEmpty
            ? IconButton(
                tooltip: 'Limpar pesquisa',
                onPressed: () {
                  pesquisaController.clear();
                  controller.limparPesquisa();
                },
                icon: const Icon(Icons.clear),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _lista(List<Task> tasks) {
    return ListView.builder(
      keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return TaskListItem(
          key: ValueKey(task.id),
          task: task,
          onAlterarStatus: () {
            controller.alterarStatus(task.id);
          },
          onEditar: () {
            _abrirFormulario(task: task);
          },
          onRemover: () {
            _confirmarRemocao(task);
          },
        );
      },
    );
  }

  Widget _grade(List<Task> tasks) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int colunas = 1;

        if (constraints.maxWidth >= 900) {
          colunas = 3;
        } else if (constraints.maxWidth >= 600) {
          colunas = 2;
        }

        return GridView.builder(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: tasks.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: colunas,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: colunas == 1 ? 1.8 : 1.15,
          ),
          itemBuilder: (context, index) {
            final task = tasks[index];

            return TaskGridItem(
              key: ValueKey(task.id),
              task: task,
              onAlterarStatus: () {
                controller.alterarStatus(task.id);
              },
              onEditar: () {
                _abrirFormulario(task: task);
              },
              onRemover: () {
                _confirmarRemocao(task);
              },
            );
          },
        );
      },
    );
  }

  Widget _estadoVazio() {
    final pesquisando =
        controller.termoPesquisa.trim().isNotEmpty;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            pesquisando
                ? Icons.search_off
                : Icons.task_alt,
            size: 72,
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            pesquisando
                ? 'Nenhuma tarefa encontrada'
                : 'Nenhuma tarefa cadastrada',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            pesquisando
                ? 'Experimente pesquisar outro termo.'
                : 'Clique em "Nova tarefa" para começar.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}