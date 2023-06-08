import 'package:flutter/material.dart';

import '../components/task_form.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreen();
}

class _TaskManagerScreen extends State<TaskManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        key: widget.key,
        padding: const EdgeInsets.all(16.0),
        child: const TaskForm(key: Key('task_form')));
  }
}
