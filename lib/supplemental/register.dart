import 'package:flutter/material.dart';
import 'login.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  //controladores de texto de TextFields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _provController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'DOGGY',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            semanticLabel: 'back',
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 30.0),
            // Column(
            //   children: <Widget>[
            //     Image.asset(
            //       'assets/logo_doggy.png',
            //       height: 120,
            //       width: 100,
            //       fit: BoxFit.fitWidth,
            //     ),
            //     const SizedBox(height: 16.0),
            //     // const Text('SHRINE'),
            //   ],
            // ),
            const SizedBox(height: 30.0),
            TextFormField(
              maxLength: 13,
              controller: _usernameController,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Nombre de usuario',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
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
              controller: _nameController,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Nombre completo',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Fecha de nacimiento',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _provController,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Provincia',
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
                const SizedBox(width: 110),
                DropdownButton(
                  value: dropdownValue,
                  items: <String>['Dog', 'Cat', 'Hamster', 'Other', 'Nothing']
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
                    _provController.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () {
                      // if (_usernameController.text.isEmpty || _newPasswordController.text.isEmpty) { //provisional
                      //   showAlertDialog(context); //si el insert fuese incorrecto o algún campo no estuviese completo
                      // } else {
                        Navigator.pushNamed(context, '/home');
                      //}
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
