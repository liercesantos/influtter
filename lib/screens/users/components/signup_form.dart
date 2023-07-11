import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oquetemprahoje/main.dart';
import 'package:oquetemprahoje/providers/users_provider.dart';
import 'package:oquetemprahoje/utils/app_dialogs.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  void _signup(UserProvider provider) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (await provider.signup(_auth, _email, _password)) {
          _navigate();
        }
      } on FirebaseAuthException catch (e){
        if(e.code == 'email-already-in-use'){
          _alert('Ops!', 'Esse email já está em uso. Tente novamente com outra conta.');
        }

        if(e.code == 'invalid-email'){
          _alert('Atenção!', 'É necessário informar um email válido.');
        }

        if(e.code == 'weak-password'){
          _alert('Atenção!', 'A senha deve ter, pelo menos, 6 caracteres.');
        }
      }
    }
  }

  void _alert(String title, String message) {
    AppDialog.show(context, title,
        message, 'OK', _closeDialog);
  }

  void _closeDialog() {
    Navigator.pop(context, true);
  }

  void _navigate() {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Padding(
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
              onPressed: () => {_signup(provider)},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Criar Conta', style: TextStyle(fontSize: 24.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
