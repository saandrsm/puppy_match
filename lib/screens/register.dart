import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:PuppyMatch/services/auth.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controlador del estado de los TextFormFields
  final _claveSingup = GlobalKey<FormState>();
  //controladores de texto de TextFields
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _confMailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  AuthService authService = AuthService();


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //barra superior
        centerTitle: true,
        title: const Text(
          'PUPPY MATCH',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Colors.brown,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          //los LeadingIcon se situan al principio de la línea (a la izquierda del texto)
          icon: const Icon(
            Icons.arrow_back_ios,
            semanticLabel: 'back',
          ),
          onPressed: () {
            //al pulsar vuelve hacia pantalla LoginPage
            Navigator.popAndPushNamed(context, "/login");
          },
        ),
      ),
      body: Form(
        //el cuerpo de la pantalla es un formulario
        key: _claveSingup,
        child: ListView(
          //en formato lista
          shrinkWrap: true, //esto aun no se que es
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 30.0), //espacio en blanco de separación
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe tu correo electrónico';
                }
                return null;
              },
              controller: _mailController,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Correo electrónico',
              ),
            ),
            const SizedBox(height: 16.0), //espacio en blanco de separación
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe tu correo electrónico';
                  //validador de comparación, si el correo no coincide con el anterior da error
                } else if (value != _mailController.text){
                  return 'Los correos electrónicos no coinciden';
                }
                return null;
              },
              controller: _confMailController,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Confirmar correo electrónico',
              ),
            ),
            const SizedBox(height: 16.0), //espacio en blanco de separación
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe una contraseña';
                } else if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres.';
                }
                return null;
              },
              maxLength: 20, //máximo de 20 carcateres
              decoration: InputDecoration(
                filled: false, //sin fondo
                labelText: 'Nueva contraseña',
                suffixIcon: IconButton(
                  alignment: Alignment.center,
                  icon:
                      (_isVisible //en base a si la contraseña es visible o no, muestra un icono u otro
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.remove_red_eye_outlined)),
                  color: Colors.brown,
                  onPressed:
                      _toggleVisible, //al presionar se ejecuta el método de visibilizar/invisibilizar pwd
                ),
              ),
              obscureText: _isVisible, //por defecto la contraseña está oculta
              controller: _newPasswordController,
            ),
            const SizedBox(height: 6.0), //espacio en blanco de separación
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe una contraseña';
                  //validador de comparación, si la contraseña no coincide con la anterior da error
                } else if (value != _newPasswordController.text){
                  return 'Las contraseñas no coinciden';
                } else if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres.';
                }
                return null;
              },
              maxLength: 20,
              decoration: InputDecoration(
                filled: false,
                labelText: 'Confirmar contraseña',
                suffixIcon: IconButton(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  onPressed: _toggleVisible,
                  icon: (_isVisible
                      ? const Icon(Icons.remove_red_eye)
                      : const Icon(Icons.remove_red_eye_outlined)),
                  color: Colors.brown,
                ),
              ),
              obscureText: _isVisible,
              controller: _confPasswordController,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe tu nombre completo';
                }
                return null;
              },
              controller: _nameController,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Nombre completo',
              ),
            ),
            const SizedBox(height: 16.0), //espacio en blanco de separación
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Selecciona tu fecha de nacimiento';
                }
                return null;
              },
              controller: _dateController,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.calendar_today_outlined),
                filled: false,
                labelText: 'Fecha de nacimiento',
              ),
              onTap: () async {
                //al pulsar llama a un DatePicker (calendario)
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime(2003), //fecha en la que se inicia por defecto
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2005));
                if (pickedDate != null) {
                  //si ha sido seleccionada una fecha el estado del controlador de
                  setState(() {
                    //texto se rellena en el formato establecido
                    _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                  });
                }
              },
            ),
            const SizedBox(height: 30.0), //espacio en blanco de separación
            OverflowBar(
              //barra donde se encuentran los botones de sing up y cancel
              alignment: MainAxisAlignment.spaceBetween, //posicionados al final (a la derecha)
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    //al presionar se borra el texto de los controladores
                    _mailController.clear();
                    _confMailController.clear();
                    _nameController.clear();
                    _newPasswordController.clear();
                    _confPasswordController.clear();
                    _dateController.clear();
                  },
                  child: const Text('CANCELAR'),
                ),
                const SizedBox(width: 5.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_claveSingup.currentState!.validate()) {
                      //si se valida todo el formulario
                      authService.registerUserWithEmailandPassword(_nameController.text, _mailController.text, _confPasswordController.text)
                      .then((value) {
                        print('Created new account');
                        Navigator.pushNamed(
                        context, '/home'); //pasa hacia pantalla HomePage
                      }).onError((error, stackTrace) {
                        print('Error ${error.toString()}');
                        showAlertDialogError(context);
                      });
                    }
                  },
                  child: const Text('REGISTRARME'),
                )
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}

//alertDailog para advertir de error
showAlertDialogError(BuildContext context) {
  Widget okButton = TextButton(
    child: const Text("OK"),
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
    content: const Text(
      'Correo electrónico inválido.'
      '\n'
      'Escribe un correo válido para poder '
      'registrarte. ',
      style: TextStyle(fontSize: 16),
    ),
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

