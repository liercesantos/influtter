import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oquetemprahoje/screens/users/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:oquetemprahoje/providers/users_provider.dart';
import 'package:oquetemprahoje/screens/tasks/task_screen.dart';

class Redirect extends StatelessWidget {
  const Redirect({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (kDebugMode) {
      print('Usuário Existe: ${userProvider.user.uid}');
    }

    if (userProvider.user.uid == '') {
      return const LoginScreen(key: Key('login_screen'));
    } else {
      return const TaskScreen(key: Key('task_screen'));
    }
  }
}
