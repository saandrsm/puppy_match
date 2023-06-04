import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //función para registrarse
  Future registerUserWithEmailandPassword(String fullname, String email,
      String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password)).user!;
      if (user != null) {
        //llamar a la función para que guarde el usuario en la base de datos
        DatabaseService(uid: user.uid).registerUserData(fullname, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  //funcion
}