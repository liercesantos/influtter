import 'package:flutter/material.dart';

class TaskCreationScreen extends StatelessWidget {
  const TaskCreationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController taskController = TextEditingController();

    // ignore: no_leading_underscores_for_local_identifiers
    void _addTask() {
      String newTask = taskController.text;
      Navigator.pop(context, newTask);
    }

    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextField(
            controller: taskController,
            decoration: const InputDecoration(
              labelText: 'Task',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _addTask,
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
