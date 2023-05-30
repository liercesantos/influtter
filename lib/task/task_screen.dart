import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  final List<String> _tasks = [];
  int _editingIndex = -1;

  void _addTask() {
    setState(() {
      String newTask = _taskController.text;
      if (_editingIndex != -1) {
        _tasks[_editingIndex] = newTask;
        _editingIndex = -1;
      } else {
        _tasks.add(newTask);
      }
      _taskController.clear();
    });
  }

  void _editTask(int index) {
    setState(() {
      _taskController.text = _tasks[index];
      _editingIndex = index;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = -1;
        _taskController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.key,
      children: <Widget>[
        TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            labelText: 'Task',
          ),
        ),
        ElevatedButton(
          onPressed: _addTask,
          child: Text(_editingIndex != -1 ? 'Update Task' : 'Add Task'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_tasks[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editTask(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTask(index),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
