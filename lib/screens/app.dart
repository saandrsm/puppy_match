import 'package:flutter/material.dart';
import 'package:tutorial3_flutter/screens/infoDog.dart';
import 'package:tutorial3_flutter/screens/profile.dart';
import 'package:tutorial3_flutter/screens/register.dart';

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
        '/home': (context) => const HomePage2(),
        '/api': (context) => const Api(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/info': (context) => const InfoDog(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
      ),
    );
  }
}