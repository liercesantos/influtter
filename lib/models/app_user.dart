class AppUser {
  final String uid;
  final String email;
  final String password;

  AppUser({
    required this.uid,
    required this.email,
    required this.password,
  });

  AppUser.initial()
      : uid = '',
        email = '',
        password = '';
}
