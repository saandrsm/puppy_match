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

  // var _currentSelectedDate = DateTime.now();
  //
  // void callDatePicker() async{
  //   var selectedDate = await getDatePickerWidget();
  //   setState(() {
  //     _currentSelectedDate = selectedDate!;
  //   });
  // }
  // Future<DateTime?> getDatePickerWidget() {
  //   return showDatePicker(
  //       context: context,
  //       initialDate: _currentSelectedDate,
  //       firstDate: DateTime(2017),
  //       lastDate: DateTime(2021),
  //       builder: (context, child) => {
  //       return Theme(data: ThemeData.dark(), child: child);
  //     },
  //   );
  //   }

  //controlador del estado de los TextFormFields
  final _claveFormulario = GlobalKey<FormState>();
  //controladores de texto de TextFields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();

  //bool shouldPop = true;

  String dropdownValue = 'Dog'; //item por defecto en lista de DropDownButton de mascotas
 //metodo para visibilizar e invisibilizar texto (contraseñas)
  bool _isVisible = true;
  void _toggleVisible(){
    setState(() {
      if(_isVisible) {
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
          icon: const Icon(
            Icons.arrow_back_ios,
            semanticLabel: 'back',
          ),
          onPressed: () {
            //Navigator.pushNamed(context, '/');
            Navigator.popAndPushNamed(context, "/");
          },
        ),
      ),
      body: Form(
        key: _claveFormulario,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 40.0),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe un usuario';
                }
                return null;
              },
              maxLength: 13,
              controller: _usernameController,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Nombre de usuario',
              ),
            ),
            const SizedBox(height: 16.0),
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
                labelText: 'Nueva contraseña',
                suffixIcon: IconButton(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  icon: (_isVisible
                      ? const Icon(Icons.remove_red_eye)
                      : const Icon(Icons.remove_red_eye_outlined)
                  ),
                  color: Colors.brown,
                  onPressed: _toggleVisible,
                ),
              ),
              obscureText: _isVisible,
              controller: _newPasswordController,
            ),
            const SizedBox(height: 16.0),
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
                        : const Icon(Icons.remove_red_eye_outlined)
                    ),
                  color: Colors.brown,
                ),
              ),
              obscureText: _isVisible,
              controller: _confPasswordController,
            ),
            const SizedBox(height: 16.0),
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
            const SizedBox(height: 16.0),
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
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2003),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2005)
                );
                if(pickedDate != null) {
                  setState(() {
                    _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
            ),
            const SizedBox(height: 16.0),
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
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Text(
                    '¿Anteriores mascotas?',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                ),
                const SizedBox(width: 90),
                DropdownButton(
                  value: dropdownValue,
                  items: <String>['Nothing', 'Dog', 'Cat', 'Hamster', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ],
            ),
            // const SizedBox(height: 20.0),
            // Text(
            //   'Selected Value: $dropdownValue',
            //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
            // ),
            const SizedBox(height: 10.0),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
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
                    if(_claveFormulario.currentState!.validate()) {
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
                      Navigator.pushNamed(context, '/home');
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
