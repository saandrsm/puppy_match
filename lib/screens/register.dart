import 'dart:core';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'login.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controlador del estado de los TextFormFields
  final _claveSingup = GlobalKey<FormState>();
  //controladores de texto de TextFields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();

  String dropdownValue =
      'Dog'; //item por defecto en lista de DropDownButton de mascotas

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

  //metodo para validar email
  void Validate(String email) {
    bool isvalid = EmailValidator.validate(email);
    print(isvalid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //barra superior
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
          //los LEADINGIcon se situan al principio de la línea (a la izquierda del texto)
          icon: const Icon(
            Icons.arrow_back_ios,
            semanticLabel: 'back',
          ),
          onPressed: () {
            //al pulsar vuelve hacia pantalla LoginPage
            //Navigator.pushNamed(context, '/');
            Navigator.popAndPushNamed(context, "/");
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
            const SizedBox(height: 40.0), //espacio en blanco de separación
            TextFormField(
              validator: (value) {
                //validador de textField, si el campo está vacio da error
                if (value!.isEmpty) {
                  return 'Escribe un usuario';
                }
                return null;
              },
              maxLength: 13, //máximo de 13 carcateres
              controller: _usernameController,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Nombre de usuario',
              ),
            ),
            const SizedBox(height: 16.0), //espacio en blanco de separación
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe una contraseña';
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
            const SizedBox(height: 16.0), //espacio en blanco de separación
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe una contraseña';
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
            const SizedBox(height: 16.0), //espacio en blanco de separación
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
                //al pulsar llama a un DatePicker
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
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
            ),
            const SizedBox(height: 16.0), //espacio en blanco de separación
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
            const SizedBox(height: 20.0), //espacio en blanco de separación
            Row(
              children: [
                const Text(
                  '¿Anteriores mascotas?',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 90), //espacio en blanco de separación
                DropdownButton(
                  value: dropdownValue, //valor inicial
                  items: <String>[
                    'Nothing',
                    'Dog',
                    'Cat',
                    'Hamster',
                    'Other'
                  ] //lista de items del DropdownButton
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      //devuelve la lista
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      //al cambiar, pone el nuevo valor como valor determinado
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ],
            ),

            //prueba para utilizar el valor seleccionado en el DropdownButton
            // const SizedBox(height: 20.0),
            // Text(
            //   'Selected Value: $dropdownValue',
            //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
            // ),

            const SizedBox(height: 10.0), //espacio en blanco de separación
            OverflowBar(
              //barra donde se encuentran los botones de sing up y cancel
              alignment:
                  MainAxisAlignment.end, //posicionados al final (a la derecha)
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    //al presionar se borra el texto de los controladores
                    _usernameController.clear();
                    _nameController.clear();
                    _newPasswordController.clear();
                    _confPasswordController.clear();
                    _dateController.clear();
                    _mailController.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_claveSingup.currentState!.validate()) {
                      //si se valida todo el formulario
                      // try {
                      //   final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      //     email: _mailController.text,
                      //     password: _confPasswordController.text,
                      //   );
                      // } on FirebaseAuthException catch (e) {
                      //   if (e.code == 'weak-password') {
                      //     print('The password provided is too weak.');
                      //   } else if (e.code == 'email-already-in-use') {
                      //     print('The account already exists for that email.');
                      //   }
                      // } catch (e) {
                      //   print(e);
                      // }
                      Navigator.pushNamed(
                          context, '/home'); //pasa hacia pantalla HomePage
                    }
                  },
                  child: const Text('SIGN UP'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
