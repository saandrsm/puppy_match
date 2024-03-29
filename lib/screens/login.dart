import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
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
          return WillPopScope(
            //devuelve un Future
            onWillPop: () async {
              //volver a pantalla anterior
              return shouldPop;
            },
            child: Scaffold(
              body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double screenWidth = constraints.maxWidth;
                  if (screenWidth >= 390) {
                    return Form(
                      //el cuerpo de la pantalla es un formulario
                      key: _claveLogin,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0), //left, top, right, bottom
                        children: <Widget>[
                          const SizedBox(height: 35.0), //espacio en blanco de separación
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
                              return null;
                            },
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              filled: false,
                              labelText: 'Correo electrónico',
                            ),
                          ),
                          const SizedBox(height: 16.0), //espacio en blanco de separación
                          TextFormField(
                            validator: (value) {
                              //validador de textField, si el campo está vacio da error
                              if (value!.isEmpty) {
                                return 'Campo vacío';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: false,
                              labelText: 'Contraseña',
                              suffixIcon: IconButton(
                                //los SUFIXIcons se encuentran al final del text
                                padding: const EdgeInsets.all(0),
                                alignment: Alignment.center,
                                //posición del botón
                                icon:
                                (_isVisible //en base a si la contraseña es visible o no, muestra un icono u otro
                                    ? const Icon(Icons.lock)
                                    : const Icon(Icons.lock_open)),
                                color: Colors.orangeAccent,
                                onPressed:
                                _toggleVisible, //al presionar se ejecuta el método de visibilizar/invisibilizar pwd
                              ),
                            ),
                            obscureText: _isVisible,
                            //por defecto la contraseña está oculta
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 10.0), //espacio en blanco de separación
                          Row(
                            //barra donde se encuentran los botones de log in y cancel
                            //alignment: MainAxisAlignment.end, //posicionados al final (a la derecha)
                            children: [
                              forgetPassword(context),
                              const Expanded(child: SizedBox(width: 30)), //espacio en blanco de separación que ocupa el espacio disponible
                              TextButton(
                                //al presionar se borra el texto de los controladores
                                onPressed: () {
                                  _usernameController.clear();
                                  _passwordController.clear();
                                },
                                child: const Text('CANCELAR'),
                              ),
                              const SizedBox(width: 5.0), //espacio en blanco de separación
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
                                        shouldPop =
                                        !shouldPop; //en false hace que no funcione el swip back de ios
                                      });
                                      Navigator.pushNamed(
                                          context,
                                          '/home'); //pasa hacia pantalla HomePage
                                    }).onError((error, stackTrace) {
                                      print('Error ${error.toString()}');
                                      showAlertDialogError(context);
                                    });
                                    _usernameController.clear();
                                    _passwordController.clear();
                                  }
                                },
                                child: const Text('ENTRAR'),
                              )
                            ],
                          ),
                          const SizedBox(height: 200.0), //espacio en blanco de separación
                          const Text(
                            '¿Todavía no estás registrado?',
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context,
                                    '/register'); //al pulsar pasa hacia pantalla RegisterPage
                              },
                              child: const Text('Registrarme')),
                        ],
                      ),
                    );
                  } else {
                    return Form(
                      //el cuerpo de la pantalla es un formulario
                      key: _claveLogin,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                            24, 20, 24, 0), //left, top, right, bottom
                        children: <Widget>[
                          const SizedBox(height: 30.0), //espacio en blanco de separación
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
                          const SizedBox(height: 60.0), //espacio en blanco de separación
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo vacío';
                              }
                              return null;
                            },
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              filled: false,
                              labelText: 'Correo electrónico',
                            ),
                          ),
                          const SizedBox(height: 16.0), //espacio en blanco de separación
                          TextFormField(
                            validator: (value) {
                              //validador de textField, si el campo está vacio da error
                              if (value!.isEmpty) {
                                return 'Campo vacío';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: false,
                              labelText: 'Contraseña',
                              suffixIcon: IconButton(
                                //los SUFIXIcons se encuentran al final del text
                                padding: const EdgeInsets.all(0),
                                alignment: Alignment.center,
                                //posición del botón
                                icon:
                                (_isVisible //en base a si la contraseña es visible o no, muestra un icono u otro
                                    ? const Icon(Icons.lock)
                                    : const Icon(Icons.lock_open)),
                                color: Colors.orangeAccent,
                                onPressed:
                                _toggleVisible, //al presionar se ejecuta el método de visibilizar/invisibilizar pwd
                              ),
                            ),
                            obscureText: _isVisible,
                            //por defecto la contraseña está oculta
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 10.0), //espacio en blanco de separación
                          OverflowBar(
                            //barra donde se encuentran los botones de log in y cancel
                            alignment: MainAxisAlignment.center, //posicionados al final (a la derecha)
                            children: [
                              //const SizedBox(width: 50),
                              TextButton(
                                //al presionar se borra el texto de los controladores
                                onPressed: () {
                                  _usernameController.clear();
                                  _passwordController.clear();
                                },
                                child: const Text('CANCELAR'),
                              ),
                              const SizedBox(width: 5.0), //espacio en blanco de separación
                              ElevatedButton(
                                onPressed: () async {
                                  if (_claveLogin.currentState!.validate()) {
                                    //si se valida el formulario entero
                                    FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: _usernameController.text,
                                        password: _passwordController.text
                                    ).then((value) {
                                      setState(() {
                                        print('Login');
                                        shouldPop =
                                        !shouldPop; //en false hace que no funcione el swip back de ios
                                      });
                                      Navigator.pushNamed(
                                          context,
                                          '/home'); //pasa hacia pantalla HomePage
                                    }).onError((error, stackTrace) {
                                      print('Error ${error.toString()}');
                                      showAlertDialogError(context);
                                    });
                                    _usernameController.clear();
                                    _passwordController.clear();
                                  }
                                },
                                child: const Text('ENTRAR'),
                              )
                            ],
                          ),
                          forgetPassword2(context),
                          const SizedBox(height: 200.0), //espacio en blanco de separación
                          const Text(
                            '¿Todavía no estás registrado?',
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context,
                                    '/register'); //al pulsar pasa hacia pantalla de registro de usuario
                              },
                              child: const Text('Registrarme')),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
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
  return TextButton(
        child: const Text(
          '¿Recuperar \n'
          'contraseña?',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.orangeAccent,
          ),
        ),
      onPressed: () {
        Navigator.pushNamed(context, '/reset'); //al pulsar pasa hacia pantalla ResetPage
      },
    );
}

Widget forgetPassword2(BuildContext context) {
  return TextButton(
    child: const Text(
      '¿Recuperar contraseña?',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.orangeAccent,
      ),
    ),
    onPressed: () {
      Navigator.pushNamed(context, '/reset'); //al pulsar pasa hacia pantalla ResetPage
    },
  );
}
