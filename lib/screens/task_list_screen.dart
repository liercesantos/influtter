import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/task_list_item.dart';
import '../models/task.dart';
import '../providers/tasks_provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          const Expanded(
              flex: 1,
              child: Card(
                child:
                    Text(style: TextStyle(fontSize: 24.0), 'Lista de Tarefas'),
              )),
          Expanded(
              flex: 9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: provider.tasks.length,
                itemBuilder: (context, index) {
                  Task task = provider.tasks[index];

                  return TaskListItem(task, index);
                },
              )),
        ],
      ),
    );
  }
}
