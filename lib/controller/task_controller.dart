import 'package:flutter/material.dart';

import '../model/task.dart';

enum TipoVisualizacao { lista, grade }

class TaskController extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: 1,
      titulo: 'Estudar ListView',
      descricao: 'Criar uma lista dinâmica utilizando ListView.builder.',
      concluida: false,
      criadaEm: DateTime.now(),
    ),
    Task(
      id: 2,
      titulo: 'Estudar GridView',
      descricao: 'Exibir as tarefas utilizando GridView.builder.',
      concluida: true,
      criadaEm: DateTime.now(),
    ),
    Task(
      id: 3,
      titulo: 'Revisar ChangeNotifier',
      descricao: 'Entender o funcionamento do método notifyListeners.',
      concluida: false,
      criadaEm: DateTime.now(),
    ),
  ];

  String _termoPesquisa = '';
  TipoVisualizacao _tipoVisualizacao = TipoVisualizacao.lista;
  int _proximoId = 4;

  List<Task> get tasks => List.unmodifiable(_tasks);

  String get termoPesquisa => _termoPesquisa;

  TipoVisualizacao get tipoVisualizacao => _tipoVisualizacao;

  bool get exibindoLista => _tipoVisualizacao == TipoVisualizacao.lista;

  int get quantidadeTotal => _tasks.length;

  int get quantidadeConcluidas => _tasks.where((task) => task.concluida).length;

  int get quantidadePendentes => _tasks.where((task) => !task.concluida).length;

  List<Task> get tasksFiltradas {
    if (_termoPesquisa.trim().isEmpty) {
      return List.unmodifiable(_tasks);
    }

    final termo = _termoPesquisa.toLowerCase().trim();

    return _tasks.where((task) {
      return task.titulo.toLowerCase().contains(termo) ||
          task.descricao.toLowerCase().contains(termo);
    }).toList();
  }

  void adicionarTask({required String titulo, required String descricao}) {
    final task = Task(
      id: _proximoId++,
      titulo: titulo.trim(),
      descricao: descricao.trim(),
      concluida: false,
      criadaEm: DateTime.now(),
    );

    _tasks.add(task);
    notifyListeners();
  }

  void atualizarTask({
    required int id,
    required String titulo,
    required String descricao,
  }) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) {
      return;
    }

    _tasks[index] = _tasks[index].copyWith(
      titulo: titulo.trim(),
      descricao: descricao.trim(),
    );

    notifyListeners();
  }

  void removerTask(int id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void alterarStatus(int id) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) {
      return;
    }

    final task = _tasks[index];

    _tasks[index] = task.copyWith(concluida: !task.concluida);

    notifyListeners();
  }

  void pesquisar(String termo) {
    _termoPesquisa = termo;
    notifyListeners();
  }

  void limparPesquisa() {
    if (_termoPesquisa.isEmpty) {
      return;
    }

    _termoPesquisa = '';
    notifyListeners();
  }

  void alternarVisualizacao() {
    _tipoVisualizacao = _tipoVisualizacao == TipoVisualizacao.lista
        ? TipoVisualizacao.grade
        : TipoVisualizacao.lista;

    notifyListeners();
  }
}
