import 'package:get_it/get_it.dart';

import '../controller/task_controller.dart';

final getIt = GetIt.instance;

void configurarDependencias() {
  if (!getIt.isRegistered<TaskController>()) {
    getIt.registerSingleton<TaskController>(
      TaskController(),
    );
  }
}