import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jelajahbaturaden/login/login.dart';
import 'package:jelajahbaturaden/screen/halamanutama.dart';
import 'package:jelajahbaturaden/model/user_session.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserSession(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jelajah Baturaden',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer<UserSession>(
        builder: (context, userSession, child) {
          if (userSession.isLoggedIn) {
            return const HalamanUtama();
          } else {
            return const PageLogin();
          }
        },
      ),
    );
  }
}
