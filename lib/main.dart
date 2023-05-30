import 'package:flutter/material.dart';
import 'package:influtter/task/task_creator.dart';
import 'package:influtter/task/task_list.dart';
import 'package:influtter/task/task_screen.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LayoutBuilder(
        builder: (context, constraints) {
          final orientation = constraints.maxWidth > constraints.maxHeight
              ? Orientation.landscape
              : Orientation.portrait;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Task List'),
            ),
            body: _buildBody(orientation),
          );
        },
      ),
    );
  }

  Widget _buildBody(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return const TaskScreen(key: Key('taskScreen'));
    } else {
      return Row(
        children: <Widget>[
          const Flexible(
            flex: 1,
            child: TaskListScreen(key: Key('taskListScreen')),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                child: const TaskCreationScreen(key: Key('taskCreationScreen')),
              ),
            ),
          ),
        ],
      );
    }
  }
}
