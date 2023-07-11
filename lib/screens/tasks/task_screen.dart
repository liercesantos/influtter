import 'package:flutter/material.dart';
import 'package:oquetemprahoje/components/drawer_menu.dart';
import 'package:oquetemprahoje/screens/tasks/components/task_list.dart';
import 'package:oquetemprahoje/screens/users/components/logout_button.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: widget.key,
        appBar: AppBar(
          title: const Text('O que tem pra hoje?'),
          actions: [
            IconButton(
              tooltip: 'Nova Tarefa',
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/taskManager',
                );
              },
            ),
            const SizedBox(width: 8.0),
            const LogoutButton()
          ],
        ),
        drawer: const AppDrawer(),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: TaskList(key: Key('task_list')),
                ),
              ),
            ],
          ),
        ));
  }
}
