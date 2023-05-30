import 'package:flutter/material.dart';
import 'package:influtter/task_manager/task_creator.dart';
import 'package:influtter/task_manager/task_list.dart';
import 'package:influtter/task_manager/task_screen.dart';

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
      home: OrientationBuilder(
        builder: (context, orientation) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Task List'),
            ),
            body: _buildBody(orientation),
          );
        },
      ),
    );
  }

  Widget _buildBody(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return TaskScreen(key: Key('taskScreen'));
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TaskCreationScreen(key: Key('taskCreationScreen')),
          ),
          Expanded(
            flex: 1,
            child: TaskListScreen(key: Key('taskListScreen')),
          ),
        ],
      );
    }
  }
}
