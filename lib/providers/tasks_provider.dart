import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oquetemprahoje/models/app_user.dart';
import 'package:oquetemprahoje/models/task.dart';
import 'package:oquetemprahoje/contracts/task_contract.dart';

class TasksProvider with ChangeNotifier {
  List<Task> tasks = [];
  TaskContract contract = TaskContract();
  Task task = Task.initial();
  int listId = -1;
  bool isEditing = false;
  bool created = false;
  bool updated = false;
  bool next = false;

  onLoad(AppUser user) async {
    tasks = await contract.all(user, false);
    if (kDebugMode) {
      print('Tasks carregadas: ${tasks.length}');
    }
    notifyListeners();
    return;
  }

  createTask(Task newTask, BuildContext context) async {
    try {
      var createdTask = await contract.create(newTask);
      if (createdTask.id != null) {
        created = true;

        notifyListeners();
      }
    } catch (e) {
      created = false;
      if (kDebugMode) {
        print('Erro ao criar tarefa: $e');
      }
    }
  }

  onEditTask(int index) async {
    listId = index;
    task = tasks[listId];
    isEditing = true;
    notifyListeners();
  }

  editTask(Task editedTask) async {
    try {
      tasks[listId] = await contract.update(editedTask);
      updated = true;

      listId = -1;
      isEditing = false;
      notifyListeners();
    } catch (e) {
      updated = false;
      if (kDebugMode) {
        print('Erro ao alterar tarefa: $e');
      }
    }
  }

  void deleteTask(int index) async {
    var currentId = tasks[index].id;
    if (currentId != null) {
      await contract.delete(currentId);

      tasks.removeAt(index);
      notifyListeners();
    }
  }
}
