import 'package:flutter/material.dart';
import 'package:influtter/providers/tasks_provider.dart';
import 'package:influtter/screens/task_list_screen.dart';
import 'package:influtter/screens/task_manager_screen.dart';
import 'package:influtter/screens/task_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatefulWidget {
  const TaskApp({super.key});

  @override
  _TaskAppState createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infnet - Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrientationBuilder(
        builder: (context, orientation) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Gerenciador de Tarefas'),
            ),
            body: ChangeNotifierProvider(
                create: (context) => TasksProvider(),
                child: _buildBody(orientation)),
          );
        },
      ),
    );
  }

  Widget _buildBody(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return const TaskScreen(key: Key('task_screen'));
    } else {
      return const Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TaskManagerScreen(key: Key('task_manager_screen')),
          ),
          Expanded(
            flex: 1,
            child: TaskListScreen(key: Key('task_list_screen')),
          ),
        ],
      );
    }
  }
}
