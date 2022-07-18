import 'dart:convert';

import 'package:apka/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text(
              'Wysłaliśmy wiadomość weryfikacyjną na twój adres E-mail.'),
          const Text(
              'Jeśli nie otrzymałeś wiadomości, kliknij w przycisk poniżej aby wysłać jeszcze raz'),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              user?.sendEmailVerification();
            },
            child: const Text('wyślij email weryfikacyjny'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
