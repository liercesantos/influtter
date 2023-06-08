import 'package:flutter/material.dart';
import 'package:influtter/components/task_list_item.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/tasks_provider.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, provider, _) {
        return ListView.builder(
          itemCount: provider.tasks.length,
          itemBuilder: (context, index) {
            Task task = provider.tasks[index];
            return TaskListItem(task, index);
          },
        );
      },
    );
  }
}
