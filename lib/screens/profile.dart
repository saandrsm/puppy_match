import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //variables para dropDownButton
  // String dropdownvalue = 'Item 1';
  // var items = [
  //   'Item 1',
  //   'Item 2',
  //   'Item 3',
  //   'Item 4',
  //   'Item 5',
  // ];


  File? _image;
  final _picker = ImagePicker();

  //metodo del imagePicker para abrir galería
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  //metodo del imagePicker para abrir cámara
  Future<void> _takeImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);  //variable theme para usar colores
    return Scaffold(
      appBar: AppBar( //barra superior
        title: const Text( //titulo y su formato
          'PUPPY MATCH',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Colors.brown,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton( //icono a la izquierda (principio) del texto para cerrar sesión
          icon: const Icon(
            Icons.logout,
            semanticLabel: 'logout',
          ),
          onPressed: () { //al presionar vuelve hacia LoginPage
            Navigator.pushNamed(context, '/');
          },
        ),
      ),
      body: ListView( //cuerpo en formato lista
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        children: [
          //forma distinta (medio fallido) para crear una imagen circular de perfil
          // CircleAvatar(
          //   radius: 40,
          //   //backgroundImage: AssetImage('assets/puppy_match.png'),
          //   child: Image.asset(
          //       'assets/puppy_match.png',
          //       width: 70,
          //       height: 55,
          //       fit: BoxFit.fill
          //   ),
          // )
          Container(
            width: 110,
            height: 90,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,  //forma de imagen circular
              image: DecorationImage(
                  image: AssetImage('assets/puppy_match.png'),
                  fit: BoxFit.contain
              ),
            ),
          ),
          const SizedBox(height: 20),  //espacio en blanco de separación
          dataSection,
          // DropdownButton(
          //   alignment: Alignment.,
          //   value: dropdownvalue,
          //   items: items.map((String items) {
          //     return DropdownMenuItem(
          //       value: items,
          //       child: Text(items),
          //     );
          //   }).toList(),
          //   onChanged: (String? newValue) {
          //     setState(() {
          //       dropdownvalue = newValue!;
          //     });
          //   },
          // ),
          OverflowBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    _openImagePicker();
                  },
                  child: const Text("Abrir Galería",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(width: 10),  //espacio en blanco de separación
              ElevatedButton(
                  onPressed: () {
                    _takeImagePicker();
                  },
                  child: const Text("Abrir Cámara",
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 10),  //espacio en blanco de separación
          Container( //contenedor para mostrar la imagen seleccionada de la galeria o cámara
            alignment: Alignment.center,
            width: double.infinity,
            height: 300,
            child: _image != null //si la variable donde se guarda la imagen esta vacia muestra un Text
                ? Image.file(_image!, fit: BoxFit.cover)
                : const Text('Selecciona una imagen'),
          ),
        ],
      ),
    );
  }

  //widget de seccion de datos
  Widget dataSection = Container(
    padding: const EdgeInsets.all(30),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, //alineación en el centro
            children: [
              Container( //contenedor de texto (para poder poner padding)
                padding: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  'Nombre de usuario',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
              const Text(
                '@username',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),  //espacio en blanco de separación
              Container( //contenedor de texto (para poder poner padding)
                padding: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  'Descripción',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
              //prueba de paquete de texto ocultable (leer mas, leer menos)
              const ReadMoreText(
                'Aquí tiene que haber una descripción del usuario que explique '
                'un poco por encima su entorno, situación y personalidad. '
                'Cuántos animales ha cuidado, cuales son, como fue, cual es su situacion '
                'actual, en que tipo de casa residen, si tiene experiencia en '
                'adiestramiento, en participación en protectoras, en trabajos con '
                'animales, etc. Tendrá un máximo de caracteres. ',
                textAlign: TextAlign.justify, //texto justificado
                trimLines: 3,
                //colorClickableText: Colors.red,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Hide',
                //estilo de texto que amplía
                moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.blueGrey),
                //estilo de texto que reduce
                lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.blueGrey),
                //estilo de texto general
                style: TextStyle(
                  fontWeight: FontWeight.bold, //estilo en negrita
                ),
              ),
              const SizedBox(height: 20),  //espacio en blanco de separación
            ],
          ),
        ),
      ],
    ),
  );
}
