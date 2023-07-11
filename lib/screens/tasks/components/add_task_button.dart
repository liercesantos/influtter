import 'package:flutter/material.dart';

Widget addTaskButton(BuildContext context) {
  void navigate() {
    Navigator.pushNamed(
      context,
      '/taskManager',
    );
  }

  return Center(
    child: ElevatedButton(
      onPressed: navigate,
      child: const Text('Adicionar Tarefa'),
    ),
  );
}
