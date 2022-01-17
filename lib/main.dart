// ignore_for_file: deprecated_member_use

import 'package:chatapp/views/auth_page.dart';
import 'package:chatapp/views/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'ChatApp',
              theme: ThemeData(
                primarySwatch: Colors.pink,
                scaffoldBackgroundColor: Colors.pink,
                accentColor: Colors.deepPurple,
                accentColorBrightness: Brightness.dark,
                buttonTheme: ButtonTheme.of(context).copyWith(
                  buttonColor: Colors.pink,
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return const ChatPage();
                  }
                  return const AuthPage();
                },
              ));
        }
      },
    );
  }
}
