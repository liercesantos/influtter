import 'package:flutter/material.dart';
import 'package:influtter/components/task_form.dart';
import 'package:influtter/components/task_list.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        key: widget.key,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: Container(
                      key: widget.key,
                      padding: const EdgeInsets.all(16.0),
                      child: const TaskForm(key: Key('task_form'))))
            ],
          ),
          const Expanded(
            child: TaskList(key: Key('task_list')),
          ),
        ],
      ),
    );
  }
}
