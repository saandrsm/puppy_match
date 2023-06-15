import 'package:PuppyMatch/model/chatData.dart';
import 'package:PuppyMatch/screens/chatUserProfile.dart';
import 'package:deep_route/deep_material_app.dart';
import 'package:flutter/material.dart';
import 'package:PuppyMatch/screens/infoDog.dart';
import 'package:PuppyMatch/screens/profile.dart';
import 'package:PuppyMatch/screens/register.dart';
import 'package:PuppyMatch/screens/resetPassword.dart';
import 'package:PuppyMatch/screens/chatListScreen.dart';
import 'package:PuppyMatch/screens/chatScreen.dart';
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
    return DeepMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PuppyMatch',
      home: AnimatedSplashScreen( //animación que aparece al iniciar la app
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
        nextScreen: LoginPage(), //lleva a la pantalla de Login
      ),
      routes: {        //rutas de otras pantallas a las que dirigirnos
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/api': (context) => const Api(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/reset': (context) => const ResetPage(),
        '/conversations': (context) => const ChatListScreen(),
        '/registerDog': (context) => const DogRegisterPage()

      },
      onGenerateRoute: (settings){
    if (settings.name == InfoDog.routeName) { //comprueba si la ruta pasada coincide con la que tiene la pantalla de información del perro
      final args = settings.arguments as String; //y pasa los argumentos como String asociándolos al id que tiene que recibir al ejecutarse
      return MaterialPageRoute(
        builder: (context) {
          return InfoDog(
            dogId: args,
          );
        },
      );
    }
    if (settings.name == ChatScreen.routeName) { //comprueba si la ruta pasada coincide con la que tiene la pantalla de Chat
      final args = settings.arguments as ChatData; //y pasa los argumentos como ChatData asociándolos al chat que tiene que recibir al ejecutarse
      return MaterialPageRoute(
        builder: (context) {
          return ChatScreen(
            chat: args,
          );
        },
      );
    }
    if (settings.name == ChatUserProfile.routeName) { //comprueba si la ruta pasada coincide con la que tiene la pantalla del perfil del chat
      final args = settings.arguments as String; //y pasa los argumentos como ChatData asociándolos al perfil que tiene que recibir al ejecutarse
      return MaterialPageRoute(
        builder: (context) {
          return ChatUserProfile(
            userId: args,
          );
        },
      );
    }
        assert(false, 'No se ha recibido ${settings.name}'); //Da error si no hay ruta
        return null;
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