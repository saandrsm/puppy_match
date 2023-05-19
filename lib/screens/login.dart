import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial3_flutter/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //metodo para visibilizar e invisibilizar texto (contraseñas)
  bool _isVisible = true;
  void _toggleVisible() {
    setState(() {
      if (_isVisible) {
        _isVisible = false;
      } else {
        _isVisible = true;
      }
    });
  }

  bool shouldPop = true; //vueltra atrás activada

  //controlador del estado de los TextFormFields
  final _claveLogin = GlobalKey<FormState>();
  //controladores de texto de TextFields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return WillPopScope(
      //devuelve un Future
      onWillPop: () async {
        //volver a pantalla anterior
        return shouldPop;
      },
      child: Scaffold(
          body: Form(
        //el cuerpo de la pantalla es un formulario
        key: _claveLogin,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              24, 20, 24, 0), //left, top, right, bottom
          children: <Widget>[
            const SizedBox(height: 50.0), //espacio en blanco de separación
            Column(
              children: <Widget>[
                Image.asset(
                  //inserción del logo y definición de parámetros de imagen
                  'assets/puppy_match-2.png',
                  height: 120,
                  width: 100,
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
            const SizedBox(height: 85.0), //espacio en blanco de separación
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo vacío';
                }
              },
              controller: _usernameController,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16.0), //espacio en blanco de separación
            TextFormField(
              validator: (value) {
                //validador de textField, si el campo está vacio da error
                if (value!.isEmpty) {
                  return 'Campo vacío';
                }
              },
              decoration: InputDecoration(
                filled: false,
                labelText: 'Password',
                suffixIcon: IconButton(
                  //los SUFIXIcons se encuentran al final del text
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center, //posición del botón
                  icon:
                      (_isVisible //en base a si la contraseña es visible o no, muestra un icono u otro
                          ? const Icon(Icons.lock)
                          : const Icon(Icons.lock_open)),
                  color: Colors.orangeAccent,
                  onPressed:
                      _toggleVisible, //al presionar se ejecuta el método de visibilizar/invisibilizar pwd
                ),
              ),
              obscureText: _isVisible, //por defecto la contraseña está oculta
              controller: _passwordController,
            ),
            const SizedBox(height: 10.0), //espacio en blanco de separación
            //forgetPassword(context),
            Row(
              //barra donde se encuentran los botones de log in y cancel
              //alignment: MainAxisAlignment.end, //posicionados al final (a la derecha)
              children: [
                TextButton(
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/reset'); //al pulsar pasa hacia pantalla ResetPage
                  },
                ),
                const Expanded(child: SizedBox(width: 50)),
                TextButton(
                  //al presionar se borra el texto de los controladores
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                const SizedBox(width: 5.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_claveLogin.currentState!.validate()) {
                      //si se valida todo el formulario
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _usernameController.text,
                          password: _passwordController.text
                      ).then((value) {
                        setState(() {
                          print('Login');
                          shouldPop = !shouldPop; //en false hace que no funcione el swip back de ios
                        });
                        Navigator.pushNamed(
                            context, '/home'); //pasa hacia pantalla HomePage
                      }).onError((error, stackTrace) {
                        print('Error ${error.toString()}');
                        showAlertDialogError(context);
                      });
                    }
                  },
                  child: const Text('LOG IN'),
                )
              ],
            ),
            const SizedBox(height: 200.0), //espacio en blanco de separación
            // Text(
            //   '$screenWidth, $screenHeight',
            //   textAlign: TextAlign.center,
            // ),
            const Text(
              '¿Todavía no estás registrado?',
              textAlign: TextAlign.center,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register'); //al pulsar pasa hacia pantalla RegisterPage
                },
                child: const Text('Sign up')),
          ],
        ),
      )),
    );
  }
}

//alertDailog para advertir de error
showAlertDialogError(BuildContext context) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(
      'Error',
    style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red
      ),
    ),
    content: const Text('Usuario o contraseña incorrectos.'),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget forgetPassword(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
      height: 35,
    alignment: Alignment.bottomLeft,
    child: TextButton(
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
              color: Colors.orangeAccent,
          ),
        ),
      onPressed: () {
        Navigator.pushNamed(context, '/reset'); //al pulsar pasa hacia pantalla ResetPage
      },
    )
  );
}

//metodo aparte para visibilizar e invisibilizar contraseñas pero impide controlar el texto del TextField

// class PasswordVisible extends StatefulWidget {
//   const PasswordVisible({super.key});
//
//   @override
//   State<PasswordVisible> createState() => _PasswordVisibleState();
// }
//
// class _PasswordVisibleState extends State<PasswordVisible> {
//   bool _isVisible = true;
//
//   void _toggleVisible(){
//     setState(() {
//       if(_isVisible) {
//         _isVisible = false;
//       } else {
//         _isVisible = true;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         filled: false,
//         labelText: 'Password',
//         suffixIcon: IconButton(
//           padding: const EdgeInsets.all(0),
//           alignment: Alignment.center,
//           icon: (_isVisible
//               ? const Icon(Icons.lock)
//               : const Icon(Icons.lock_open)
//           ),
//           color: Colors.orangeAccent,
//           onPressed: _toggleVisible,
//           ),
//         ),
//       obscureText: _isVisible,
//     );
//   }
// }
