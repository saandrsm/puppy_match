import 'package:flutter/material.dart';
import 'package:PuppyMatch/screens/infoDog.dart';
import 'package:PuppyMatch/screens/profile.dart';
import 'package:PuppyMatch/screens/register.dart';
import 'package:PuppyMatch/screens/resetPassword.dart';
import 'package:PuppyMatch/screens/chatListScreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'dogRegister.dart';
import 'home.dart';
import 'login.dart';
import 'llamadasApi.dart';

class PuppyMatch extends StatelessWidget {
  const PuppyMatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PuppyMatch',
      home: AnimatedSplashScreen(
        splash: Text(
            'PUPPY MATCH',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            fontFamily: 'Kinder'
          ),
        ),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Colors.brown,
        nextScreen: LoginPage(),
      ),
      //initialRoute: '/', //ruta de la pantalla donde comienza a cargar la app
      routes: {        //rutas de otras pantallas a las que dirigirnos
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/api': (context) => const Api(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/info': (context) => const InfoDog(),
        '/reset': (context) => const ResetPage(),
        '/conversations': (context) => const ChatListScreen(),
        '/registerDog': (context) => const DogRegisterPage()

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