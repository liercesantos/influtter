import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oquetemprahoje/main.dart';
import 'package:oquetemprahoje/providers/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:oquetemprahoje/providers/users_provider.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _prepareLogout(
      UserProvider userProvider, TasksProvider tasksProvider) async {
    await userProvider.logout(_auth);
    tasksProvider.tasks = [];
    TaskApp.isLoggedIn = false;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      ModalRoute.withName('/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final tasksProvider = Provider.of<TasksProvider>(context);

    return IconButton(
      tooltip: 'Sair',
      icon: const Icon(Icons.logout),
      onPressed: () => {_prepareLogout(userProvider, tasksProvider)},
    );
  }
}
