import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oquetemprahoje/connections/firebase/firebase_options.dart';
import 'package:oquetemprahoje/providers/tasks_provider.dart';
import 'package:oquetemprahoje/providers/users_provider.dart';
import 'package:oquetemprahoje/screens/tasks/task_manager_screen.dart';
import 'package:oquetemprahoje/screens/tasks/task_screen.dart';
import 'package:oquetemprahoje/screens/tasks/task_tomorrow_screen.dart';
import 'package:oquetemprahoje/screens/users/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});
  static var isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => TasksProvider())
        ],
        child: MaterialApp(
          title: 'Hoje?',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => isLoggedIn
                ? const TaskScreen(key: Key('task_screen'))
                : const LoginScreen(key: Key('login_screen')),
            '/taskList': (context) => const TaskScreen(key: Key('task_screen')),
            '/taskManager': (context) =>
                const TaskManagerScreen(key: Key('task_manager')),
            '/taskTomorrow': (context) =>
                const TaskTomorrowScreen(key: Key('task_tomorrow')),
          },
        ));
  }
}
