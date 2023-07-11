import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:oquetemprahoje/models/app_user.dart';

class UserProvider with ChangeNotifier {
  AppUser user = AppUser.initial();

  signup(FirebaseAuth auth, String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print('Usuário criado: ${userCredential.user!.uid}');
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Erro ao criar usuário: ${e.code}');
      }
      rethrow;
    }

    return false;
  }

  login(FirebaseAuth auth, String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user =
          AppUser(uid: credential.user!.uid, email: email, password: password);

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao autenticar usuário: $e');
      }
    }
  }

  logout(FirebaseAuth auth) async {
    await auth.signOut();
    user = AppUser.initial();

    notifyListeners();
  }
}
