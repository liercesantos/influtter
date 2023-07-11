import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:oquetemprahoje/connections/api/tasks_api.dart';
import 'package:oquetemprahoje/models/app_user.dart';
import 'package:oquetemprahoje/models/task.dart';

class TaskContract {
  dynamic client;
  Future<List<Task>> all(AppUser user, bool next) async {
    final response =
        await http.get(Uri.parse('$TASK_URL/${user.uid}/${next ? next : ''}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      return data.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Falha ao carregar as tarefas');
    }
  }

  Future<Task> create(Task task) async {
    try {
      final response = await http.post(
        Uri.parse(TASK_URL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Task.fromJson(data);
      } else {
        throw Exception('Falha ao criar a tarefa (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro ao se conectar à API: $e');
    }
  }

  Future<Task> update(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$TASK_URL/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Task.fromJson(data);
      } else {
        throw Exception('Falha ao atualizar a tarefa (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro ao se conectar à API: $e');
    }
  }

  Future<int> delete(int taskId) async {
    try {
      final response = await http.delete(Uri.parse('$TASK_URL/$taskId'));
      if (response.statusCode != 204) {
        throw Exception('Falha ao excluir a tarefa (${response.statusCode})');
      }

      return response.statusCode;
    } catch (e) {
      throw Exception('Erro ao se conectar à API: $e');
    }
  }
}
