import 'package:flutter/material.dart';
import 'package:oquetemprahoje/contracts/task_contract.dart';
import 'package:oquetemprahoje/models/app_user.dart';
import 'package:oquetemprahoje/utils/auth.dart';
import 'package:provider/provider.dart';
import 'package:oquetemprahoje/screens/tasks/components/task_list_item.dart';
import 'package:oquetemprahoje/models/task.dart';
import 'package:oquetemprahoje/providers/tasks_provider.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final TaskContract _contract = TaskContract();
  List<Task> _tasks = [];
  bool _loadining = false;

  @override
  void initState() {
    super.initState();
    _onLoad();
  }

  Future<void> _onLoad() async {
    setState(() {
      _loadining = true;
    });

    try {
      List<Task> tasks = [];
      AppUser user = AppAuth.getCurrentUser();
      tasks = await _contract.all(user, false);

      setState(() {
        _tasks = tasks;
        _loadining = false;
      });
    } catch (e) {
      setState(() {
        _loadining = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TasksProvider>(context);
    taskProvider.tasks = _tasks;

    return Consumer<TasksProvider>(
      builder: (context, provider, _) {
        return _loadining
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  Task task = _tasks[index];
                  return TaskListItem(
                    task,
                    index,
                    key: const Key('task_list_item'),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1.0,
                  );
                });
      },
    );
  }
}
