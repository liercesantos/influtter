import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/tasks_provider.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem(this.task, this.index, {super.key});

  final Task task;
  final int index;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);

    return ListTile(
      title: Text(task.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Data e Hora: ${task.dateTime}'),
          Text('Local: ${task.location}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => provider.onEditTask(index),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => provider.deleteTask(index),
          ),
        ],
      ),
    );
  }
}
