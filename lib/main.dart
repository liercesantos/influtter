import 'package:flutter/material.dart';
import 'package:influtter/models/task.dart';
import 'package:influtter/task_manager/task_creator.dart';
import 'package:influtter/task_manager/task_list.dart';
import 'package:influtter/task_manager/task_screen.dart';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatefulWidget {
  @override
  _TaskAppState createState() => _TaskAppState();
}

// ignore: must_be_immutable
class _TaskAppState extends State<TaskApp> {
  List<Task> mainTasks = [];

  void _addTask(String newTask, String newDateTime, String newLocation) {
    String task = newTask;
    String datetime = newDateTime;
    String location = newLocation;

    setState(() {
      mainTasks.add(Task(name: task, dateTime: datetime, location: location));
    });
  }

  void _editTask(int index, Task task) {
    setState(() {
      mainTasks[index] = task;
    });
  }

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
      return TaskScreen(
        key: Key('taskScreen'),
        onAddTask: _addTask,
        onEditTask: _editTask,
        tasks: mainTasks,
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TaskCreationScreen(
                key: const Key('taskCreationScreen'), onAddTask: _addTask),
          ),
          Expanded(
            flex: 1,
            child: TaskListScreen(
              key: const Key('taskListScreen'),
              tasks: mainTasks,
            ),
          ),
        ],
      );
    }
  }
}
