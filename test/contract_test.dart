import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:oquetemprahoje/contracts/task_contract.dart';
import 'package:oquetemprahoje/models/task.dart';

import 'mocks/appuser.mock.dart';
import 'mocks/date.time.mock.dart';

void main() {
  group('TaskContract', () {
    final user = AppUserMock.user;
    final logger = Logger();
    late TaskContract contract;
    late List<Task> tasks;

    setUp(() {
      contract = TaskContract();
    });

    test('create - cria uma tarefa', () async {
      logger.i('Iniciando o create...');
      final task = Task(
        owner: user.uid,
        name: 'Task 3',
        dateTime: DateTimeMock.getNextDay(),
        location: 'Location 3',
      );

      final createdTask = await contract.create(task);
      expect(createdTask.id, isNotNull);
      expect(createdTask.owner, user.uid);
      expect(createdTask.name, 'Task 3');
      expect(DateTimeMock.isValid(createdTask.dateTime), isTrue);
      expect(createdTask.location, 'Location 3');
      logger.i('Task criada: ${createdTask.toString()}');
      logger.i('Finalizado o create...');
    });

    test('all - retorna lista de tarefas', () async {
      logger.i('Iniciando o all...');

      final response = await contract.all(user, true);
      expect(response.isNotEmpty, isTrue);
      tasks = response;

      for (var task in response) {
        expect(task.owner, user.uid);
        expect(DateTimeMock.isValid(task.dateTime), isTrue);

        logger.i('Task testada: ${task.toString()}');
      }

      logger.i('Finalizado o all...');
    });

    test('update - atualiza uma tarefa', () async {
      logger.i('Iniciando o update...');

      expect(tasks.isNotEmpty, isTrue);
      final limit = tasks.length;
      int counter = 0;

      for (var task in tasks) {
        logger.i('Task para atualização: ${task.toString()}');
        final updated = DateTimeMock.getNextDay();
        task.dateTime = updated;

        final updatedTask = await contract.update(task);
        expect(updatedTask.owner, user.uid);
        expect(DateTimeMock.isValid(updatedTask.dateTime), isTrue);
        expect(updatedTask.dateTime, updated);

        counter++;

        logger.i('Task atualizada: ${updatedTask.toString()}');
      }

      expect(counter, limit);

      logger.i('Finalizado o update, tasks atualizadas: ${counter.toString()}');
    });

    test('delete - exclui todas as tarefas', () async {
      logger.i('Iniciando o delete...');
      expect(tasks.isNotEmpty, isTrue);

      final limit = tasks.length;
      int counter = 0;

      for (var task in tasks) {
        logger.i('Task para deletar: ${task.toString()}');
        expect(task.id, isPositive);

        final response = await contract.delete(task.id!);
        expect(response, 204);

        counter++;
      }

      expect(counter, limit);

      logger.i('Finalizado o delete, tasks deletadas: ${counter.toString()}');
    });
  });
}
