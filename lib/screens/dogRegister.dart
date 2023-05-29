import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class DogRegisterPage extends StatefulWidget {
  const DogRegisterPage({Key? key}) : super(key: key);

  @override
  State<DogRegisterPage> createState() => _DogRegisterPageState();
}

enum Sex { male, female }

class _DogRegisterPageState extends State<DogRegisterPage> {

  final _claveSingupDog = GlobalKey<FormState>();
  final TextEditingController _nameDogController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String dropdownValue = 'Raza 1'; //item por defecto en lista de DropDownButton de mascotas
  Sex sexView = Sex.female;

  File? _image;
  final _pickerPerfil = ImagePicker();

  //metodo del imagePicker para abrir galería
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
    await _pickerPerfil.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
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
            Navigator.of(context).pop();
          },
        ),
      ),
    body: Form(
      key: _claveSingupDog,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          children: <Widget>[
            const SizedBox(height: 20.0), //espacio en blanco de separación
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe un nombre';
                }
                return null;
              },
              controller: _nameDogController,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Nombre de perro',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Raza',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const Expanded(child: SizedBox(width: 60)), //espacio en blanco de separación
                DropdownButton(
                  value: dropdownValue, //valor inicial
                  //lista de items del DropdownButton
                  items: <String>[
                    'Raza 1',
                    'Raza 2',
                    'Raza 3',
                    'Raza 4',
                    'Otro'
                  ]
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
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Sexo',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const Expanded(child: SizedBox(width: 60)), //espacio en blanco de separación
                SegmentedButton<Sex>(
                  segments: const <ButtonSegment<Sex>>[
                    ButtonSegment<Sex>(
                      value: Sex.male,
                      label: Text('Macho'),
                      icon: Icon(Icons.male)
                    ),
                    ButtonSegment<Sex>(
                      value: Sex.female,
                      label: Text('Hembra'),
                      icon: Icon(Icons.female)
                    )
                  ],
                  selected: <Sex>{sexView},
                  onSelectionChanged: (Set<Sex> newSelection) {
                    setState(() {
                      sexView = newSelection.first;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe una edad';
                }
                return null;
              },
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                filled: false,
                labelText: 'Edad (en años)',
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe una descripción';
                }
                return null;
              },
              controller: _descriptionController,
              textCapitalization: TextCapitalization.sentences,
              textAlign: TextAlign.start,
              maxLength: 400,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Descripción',
                alignLabelWithHint: true,
              ),
              maxLines: 10,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    _openImagePicker();
                  },
                  child: const Text('Añadir imagen',),
                ),
                const Expanded(child: SizedBox(width: 5)),
                IconButton(
                  onPressed: () {
                      //_image = null;
                  },
                  icon: const Icon(Icons.delete_outline_outlined))
              ],
            ),
            const SizedBox(height: 15),
            _image != null
              ? Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 300,
                    child: Image.file(_image!, fit: BoxFit.cover)
                  ),
                  const SizedBox(height: 15),
                ],
              )
              : const SizedBox(height: 15),
            const SizedBox(width: 5.0),
            FilledButton.tonal(
              onPressed: () async {
                if (_claveSingupDog.currentState!.validate()) {
                  //registrar en la bbdd
                } else {
                  //mostrar error
                }
              },
              child: const Text('REGISTER DOG'),
            ),
            const SizedBox(height: 20),
          ]
      ),
    ),
    );
  }
}