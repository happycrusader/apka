import 'dart:developer';

import 'package:apka/constants/routes.dart';
import 'package:apka/firebase_options.dart';
import 'package:apka/views/register_view.dart';
import 'package:apka/views/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                if (user.emailVerified) {
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

enum MenuAction { logout, login }

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strona główna'),
        centerTitle: true,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
                case MenuAction.login:
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Wyloguj się'),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.login,
                  child: Text('Zaloguj się'),
                ),
              ];
            },
          )
        ],
        backgroundColor: Colors.amber,
      ),
      body: const Text('Witaj w aplikacji :)'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Wyloguj się'),
          content: const Text('Jesteś pewien że chcesz się wylogować?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Anuluj')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Wyloguj mnie')),
          ],
        );
      }).then((value) => value ?? false);
}
