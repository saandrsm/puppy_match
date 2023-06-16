import 'package:flutter/material.dart';
import 'screens/app.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //interactúa con el engine de Flutter ya que initalize app necesita llamar a código nativo
  await Firebase.initializeApp(); //inicia firebase
  runApp(const PuppyMatch()); //ejecuta la clase principal de la aplicación
}

