import 'package:flutter/material.dart';
import 'package:tutorial3_flutter/supplemental/register.dart';

import 'home.dart';
import 'login.dart';
import 'post.dart';


class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/api': (context) => const Api(),
        '/register': (context) => const RegisterPage(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
      ),
    );
  }
}