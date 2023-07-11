import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oquetemprahoje/main.dart';
import 'package:oquetemprahoje/screens/users/signup_screen.dart';
import 'package:oquetemprahoje/utils/app_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:oquetemprahoje/providers/users_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  void _login(UserProvider provider) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await provider.login(_auth, _email, _password);

      if (provider.user.uid != '') {
        _toTaskList();
        return;
      }

      _alert();
    }
  }

  void _alert() {
    AppDialog.show(context, 'Ops!',
        'Login e/ou senha inválidos! Tente novamente.', 'OK', _closeDialog);
  }

  void _closeDialog() {
    Navigator.pop(context, true);
  }

  void _toTaskList() {
    Navigator.pushReplacementNamed(context, '/taskList');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final user = provider.user;

    if (user.uid != '') {
      TaskApp.isLoggedIn = true;
      if (kDebugMode) {
        print('Mudou isLoggedIn em TaskApp? ${TaskApp.isLoggedIn}');
      }
    }

    return Scaffold(
        key: widget.key,
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background_image.png"),
                  fit: BoxFit.cover,
                  opacity: 25.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, digite um email válido';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Senha'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, digite uma senha válida';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: () => {_login(provider)},
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('Login', style: TextStyle(fontSize: 24.0)),
                      ),
                    ),
                    const SizedBox(height: 64.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen(
                                  key: Key('signup_screen'))),
                        );
                      },
                      child: const Text(
                        'Criar uma nova conta',
                        style: TextStyle(
                            fontSize: 26.0,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
