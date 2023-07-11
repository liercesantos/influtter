import 'dart:convert';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:oquetemprahoje/connections/api/tasks_api.dart';
import 'package:oquetemprahoje/models/task.dart';

import 'appuser.mock.dart';

class HttpMock extends MockClient {
  HttpMock() : super(_handler);


  static Future<http.Response> _handler(http.Request request) async {
    final user = AppUserMock.user;
    // Implemente o comportamento do mockClient de acordo com as requisições esperadas.
    if (request.url.toString() == '$TASK_URL/tasks/${user.uid}/true') {
      return http.Response(jsonEncode([
        {
          'id': 1,
          'owner': user.uid,
          'name': 'Task 1',
          'dateTime': '2023-07-01',
          'location': 'Location 1',
        },
        {
          'id': 2,
          'owner': user.uid,
          'name': 'Task 2',
          'dateTime': '2023-07-02',
          'location': 'Location 2',
        },
      ]), 200);
    } else if (request.url.toString() == '$TASK_URL/tasks') {
      final taskJson = jsonDecode(request.body) as Map<String, dynamic>;
      final task = Task.fromJson(taskJson);
      // Implemente a lógica de criação da tarefa e retorne a resposta adequada.
      // Por exemplo:
      // task.id = 123;
      // return http.Response(jsonEncode(task.toJson()), 201);
    } else if (request.url.toString() == '$TASK_URL/tasks/456') {
      final taskJson = jsonDecode(request.body) as Map<String, dynamic>;
      final task = Task.fromJson(taskJson);
      // Implemente a lógica de atualização da tarefa e retorne a resposta adequada.
      // Por exemplo:
      // return http.Response(jsonEncode(task.toJson()), 200);
    } else if (request.url.toString() == '$TASK_URL/tasks/789') {
      // Implemente a lógica de exclusão da tarefa e retorne a resposta adequada.
      // Por exemplo:
      // return http.Response('', 204);
    }

    return http.Response('', 404);
  }

}
