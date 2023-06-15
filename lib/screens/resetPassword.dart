import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({Key? key}) : super(key: key);

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {

  //controlador del estado del TextFormField
  final _claveReset = GlobalKey<FormState>();
  //controladores de texto de TextFields
  final TextEditingController _mail = TextEditingController();


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
            //los LEADINGIcon se situan al principio de la línea (a la izquierda del texto)
            icon: const Icon(
              Icons.arrow_back_ios,
              semanticLabel: 'back',
            ),
            onPressed: () {
              //al pulsar vuelve hacia pantalla anterior
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Form(
          //el cuerpo de la pantalla es un formulario
          key: _claveReset,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0), //left, top, right, bottom
            children: <Widget>[
              const SizedBox(height: 60.0), //espacio en blanco de separación
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo vacío';
                  }
                  return null;
                },
                controller: _mail,
                decoration: const InputDecoration(
                  filled: false,
                  labelText: 'Introduce tu email',
                ),
              ),
              const SizedBox(height: 10.0), //espacio en blanco de separación
              OverflowBar(
                //barra donde se encuentran los botones de log in y cancel
                alignment: MainAxisAlignment.center, //posicionados al final (a la derecha)
                children: <Widget>[
                  FilledButton(
                      onPressed: () { //si se valida el formulario envia el mail
                        if (_claveReset.currentState!.validate()) {
                          FirebaseAuth.instance.sendPasswordResetEmail(email: _mail.text).then((value) {
                            Navigator.popAndPushNamed(context, "/");
                          }).onError((error, stackTrace) {
                            print('Error ${error.toString()}');
                            showAlertDialogError(context); //si da error muestra el alertDialog
                          });;
                        }
                      },
                      child: const Text('RECUPERAR CONTRASEÑA'),
                  ),
                ],
              ),
            ],
          ),
        ));
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
        'ponernos en contacto contigo. ',
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


