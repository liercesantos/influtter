import 'package:firebase_auth/firebase_auth.dart';
import 'package:oquetemprahoje/models/app_user.dart';

class AppAuth {
  static AppUser getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User currentUser = auth.currentUser as User;
    String email = currentUser.email as String;
    return AppUser(uid: currentUser.uid, email: email, password: '');
  }
}
