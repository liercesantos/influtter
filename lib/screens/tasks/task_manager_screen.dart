import 'package:flutter/material.dart';
import 'package:oquetemprahoje/screens/users/components/logout_button.dart';

import './components/task_form.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  TaskManagerState createState() => TaskManagerState();
}

class TaskManagerState extends State<TaskManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      appBar: AppBar(
        title: const Text('Pra amanhã'),
        actions: const [LogoutButton()],
      ),
      body: Container(
          key: widget.key,
          padding: const EdgeInsets.all(16.0),
          child: const TaskForm(key: Key('task_form'))),
    );
  }
}
