import 'package:flutter/material.dart';
import 'package:oquetemprahoje/providers/users_provider.dart';
import 'package:oquetemprahoje/screens/users/components/signup_form.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_image.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: ChangeNotifierProvider(
            create: (context) => UserProvider(),
            child: const SignupForm(key: Key('signup_form')),
          )),
    );
  }
}
