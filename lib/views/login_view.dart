import 'package:apka/constants/routes.dart';
import 'package:apka/services/auth/auth_exceptions.dart';
import 'package:apka/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../utilites/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Wpisz tutaj swój e-mail'),
          ),
          TextField(
            controller: _password,
            enableSuggestions: false,
            obscureText: true,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Wpisz tutaj swoje hasło'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );

                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  //zweryfikowany użytkownik
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  // niezweryfikowany użytkownik
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'Nie znaleziono użytkownika',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Niepoprawne hasło ',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Błąd uwierzytelniania',
                );
              }
            },
            child: const Text('Zaloguj się'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Nie masz konta? Zarejestruj się!'),
          )
        ],
      ),
    );
  }
}
