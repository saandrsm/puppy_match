import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'llamadasApi.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

  String dropdownValue = 'Labrador Retriever'; //item por defecto en lista de DropDownButton de mascotas
  Sex sexView = Sex.female; //button segmented seleccionado por defecto

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
            const Row(
              children: [
                Text(
                  'Raza',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Expanded(child: SizedBox(width: 60)), //espacio en blanco de separación
              ],
            ),
            FutureBuilder<List<String>>(
              future: fetchDogBreeds(),
              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.orangeAccent,
                    size: 30,
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error al obtener las razas de perro');
                } else {
                  List<String> razasPerro = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: razasPerro.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                }
              },
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
            const SizedBox(height: 5),
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
              textCapitalization: TextCapitalization.sentences, //mayuscula despues de cada punto
              textAlign: TextAlign.start,
              maxLength: 400,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Descripción',
                alignLabelWithHint: true, //coloca el label al principio
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Imagen eliminada'), //texto del snackbar
                      duration: Duration(seconds: 1), //duracion del snackbar
                    ));
                    setState(() {
                      _image = null; //vacia la variable donde se guarda la imagen
                    });
                  },
                  icon: const Icon(Icons.delete_outline_outlined))
              ],
            ),
            const SizedBox(height: 15),
            _image != null //si no hay imagen seleccionada, no muestra el container
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
            //const SizedBox(width: 5.0),
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