import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  final List<Task> tasks;

  const TaskListScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  void _deleteTask(int index) {
    setState(() {
      widget.tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          Task task = widget.tasks[index];
          return ListTile(
            title: Text(task.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data e Hora: ${task.dateTime}'),
                Text('Local: ${task.location}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteTask(index);
              },
            ),
          );
        },
      ),
    );
  }
}
