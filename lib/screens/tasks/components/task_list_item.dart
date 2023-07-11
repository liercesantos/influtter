import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/task.dart';
import '../../../providers/tasks_provider.dart';

class TaskListItem extends StatefulWidget {
  const TaskListItem(this.task, this.index, {super.key});

  final Task task;
  final int index;

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  void _prepareToEdit(TasksProvider provider) async {
    await provider.onEditTask(widget.index);

    _isPreparedToEdit(provider);
  }

  void _isPreparedToEdit(TasksProvider provider) {
    if (kDebugMode) {
      print('Mudou isEditing em TasksProvider? ${provider.isEditing}');
    }

    if (provider.isEditing) {
      Navigator.pushNamed(
        context,
        '/taskManager',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);

    return ListTile(
      style: ListTileStyle.drawer,
      title: Text(widget.task.name,
          style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data e Hora: ${widget.task.dateTime}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          Text('Local: ${widget.task.location}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _prepareToEdit(provider),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => provider.deleteTask(widget.index),
          ),
        ],
      ),
    );
  }
}
