import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/dependency_injection.dart';
import 'view/task_list_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  configurarDependencias();

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => const TaskListApp(),
    ),
  );
}

class TaskListApp extends StatelessWidget {
  const TaskListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskList',
      debugShowCheckedModeBanner: false,

      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const TaskListView(),
    );
  }
}