import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oquetemprahoje/providers/tasks_provider.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TasksProvider>(context);

    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
              image: AssetImage(
                "assets/background_image.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Text(
            'Do que precisa?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          enabled: true,
          leading: const Icon(
            Icons.task_alt_rounded,
            color: Colors.blue,
          ),
          title: const Text('Pra hoje'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        ListTile(
          enabled: true,
          leading: const Icon(
            Icons.add_task_rounded,
            color: Colors.blue,
          ),
          title: const Text('Pra amanhã'),
          onTap: () {
            taskProvider.next = true;
            Navigator.pushReplacementNamed(context, '/taskTomorrow');
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.settings,
            color: Colors.blue,
          ),
          title: const Text('Configurações'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(
            Icons.logout_rounded,
            color: Colors.red,
          ),
          title: const Text('Sair'),
          onTap: () {
            final FirebaseAuth auth = FirebaseAuth.instance;
            auth.signOut().then((value) => {
              TaskApp.isLoggedIn = false,
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                ModalRoute.withName('/'),
              )
            });

          },
        ),
      ],
    ));
  }
}
