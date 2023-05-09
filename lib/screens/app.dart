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
      initialRoute: '/', //ruta de la pantalla donde comienza a cargar la app
      routes: {        //rutas de otras pantallas a las que dirigirnos
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/api': (context) => const Api(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/info': (context) => const InfoDog(),
      },
      theme: ThemeData(   //definición del tema claro
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        brightness: Brightness.light
      ),
      darkTheme: ThemeData(  //definición del tema oscuro
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system, //el tema de la app será acorde al tema del sistema operativo
    );
  }
}