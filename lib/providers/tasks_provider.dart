import 'package:flutter/material.dart';

import '../models/task.dart';

class TasksProvider with ChangeNotifier {
  final List<Task> tasks = [];
  int id = -1;
  Task task = Task.initial();
  bool isEditing = false;

  void createTask(String newTask, String newDateTime, String newLocation) {
    String task = newTask;
    String datetime = newDateTime;
    String location = newLocation;

    tasks.add(Task(name: task, dateTime: datetime, location: location));
    notifyListeners();
  }

  void onEditTask(int index) {
    id = index;
    task = tasks[id];

    isEditing = true;
    notifyListeners();
  }

  void editTask(Task task) {
    tasks[id] = task;

    id = -1;
    isEditing = false;
    notifyListeners();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }
}
