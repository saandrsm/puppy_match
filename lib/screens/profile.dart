import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //int _selectedIndex = 1;


  File? _image;
  // This is the image picker
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

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
    final ThemeData theme = Theme.of(context);        //theme para usar colores
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
            Icons.logout,
            semanticLabel: 'logout',
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        children: [
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
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage('assets/puppy_match.png'),
                  fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 20),
          dataSection,
          OverflowBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    _openImagePicker();
                  },
                  child: const Text("Abrir Galería",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    _takeImagePicker();
                  },
                  child: const Text("Abrir Cámara",
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 300,
            child: _image != null
                ? Image.file(_image!, fit: BoxFit.cover)
                : const Text('Please select an image'),
          ),
        ],
      ),
    );
  }


  Widget dataSection = Container(
    padding: const EdgeInsets.all(30),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  'Nombre de usuario',
                  style: TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ),
              const Text(
                '@username',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  'Descripción',
                  style: TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ),
              const Text(
                'Aquí tiene que haber una descripción del usuario que explique '
                'un poco por encima su entorno, situación y personalidad. '
                'Cuántos animales ha cuidado, cuales son, como fue, cual es su situacion '
                'actual, en que tipo de casa residen, si tiene experiencia en '
                'adiestramiento, en participación en protectoras, en trabajos con '
                'animales, etc. Tendrá un máximo de caracteres.',
                textAlign: TextAlign.justify,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Mis Favoritos',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
