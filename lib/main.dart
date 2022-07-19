import 'package:apka/constants/routes.dart';
import 'package:apka/services/auth/auth_service.dart';
import 'package:apka/views/notes_view.dart';
import 'package:apka/views/register_view.dart';
import 'package:apka/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:apka/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Super aplikacja',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      }));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().Initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;

              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return LoginView();
                }
              } else {
                return LoginView();
              }

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
