import 'package:apka/constants/routes.dart';
import 'package:apka/services/auth/auth_exceptions.dart';
import 'package:apka/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../utilites/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
                AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );

                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(
                  verifyEmailRoute,
                );
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Podane hasło jest zbyt słabe',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Podany E-mail jest w użyciu',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Podany E-mail jest niepoprawny ',
                );
              } on GenericAuthException catch (e) {
                await showErrorDialog(context, 'Błąd podczas rejestracji');
              }
            },
            child: const Text('Zarejestruj'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Masz konto? Zaloguj się!'),
          )
        ],
      ),
    );
  }
}
