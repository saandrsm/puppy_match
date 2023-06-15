import 'dart:io';
import 'package:PuppyMatch/model/dogData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:readmore/readmore.dart';
import '../model/perro.dart';
import '../model/userData.dart';
import '../services/database.dart';

class InfoDog extends StatefulWidget {
  final String dogId; //inicializa la variable donde se guarda el Id de la Card
  const InfoDog({Key? key, required this.dogId})
      : super(key: key); //obtiene el valor de la key y lo asigna a la variable
  static final routeName = '/info';
  @override
  State<InfoDog> createState() => _InfoDogState(dogId);
}

class _InfoDogState extends State<InfoDog> {
  final String? dogId;
  _InfoDogState(this.dogId);
  final FirebaseAuth firebaseAuth =
      FirebaseAuth.instance; //instancia de la base de datos
  late bool isShelter = false; //variable que define el tipo de usuario
  bool isEditing = false;
  late String? dogName = "";
  late String? breedName = "";
  late String? dogDescription = "";
  late int? dogAge = 0;
  late String? userId;
  late String? shelterId = "";
  late String? dogProfilePicture = "";
  late String profileImageUrl = "";
  late List<String>? userFavouriteDogs;
  late bool _isFavorite = false;
  bool isLoading = true;

  //metodo para marcar/desmarcar button favoritos
  void _toggleFavorite() async {
    if (_isFavorite) {
      await DatabaseService(uid: userId)
          .removeDogFavourite(dogId!)
          .then((value) {
        setState(() {
          _isFavorite = false;
        });
      });
    } else {
      await DatabaseService(uid: userId).addDogFavourite(dogId!).then((value) {
        setState(() {
          _isFavorite = true;
        });
      });
    }
  }

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController breedEditingController = TextEditingController();
  TextEditingController dogDescriptionEditingController = TextEditingController();
  TextEditingController dogAgeEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    try {
      userId = firebaseAuth.currentUser
          ?.uid; //obtiene el id del usuario que se le ha asignado al iniciar sesión (auth)
      UserData userData;
      DatabaseService(uid: userId).gettingUserData(userId).then((value) {
        setState(() {
          userData = value;
          isShelter = userData.isShelter!;
          userFavouriteDogs = userData.favourites;
          if (userFavouriteDogs!.contains(dogId)) {
            _isFavorite = true;
          } else {
            _isFavorite = false;
          }
        });
      });
      Future.delayed(Duration.zero, () async {
        await DatabaseService(uid: userId).gettingDogData(dogId).then((value) {
          setState(() {
            DogData dogData = value;
            shelterId = dogData.shelterId;
            dogDescription = dogData.description;
            dogName = dogData.name;
            breedName = dogData.breed;
            dogProfilePicture = dogData.profilePicture;
            dogAge = dogData.age;
            isLoading = false;
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    breedEditingController.dispose();
    dogDescriptionEditingController.dispose();
    dogAgeEditingController.dispose();
    super.dispose();
  }

  void startEditing() {
    setState(() {
      isEditing = true;
      nameEditingController.text = dogName!;
      breedEditingController.text = breedName!;
      dogDescriptionEditingController.text = dogDescription!;
      dogAgeEditingController.text = dogAge.toString();
    });
  }

  void saveText() {
    setState(() {
      isEditing = false;
      dogName = nameEditingController.text;
      breedName = breedName;
      dogDescription = dogDescriptionEditingController.text;
      dogAge = int.parse(dogAgeEditingController.text);
      DatabaseService(uid: userId).updateDogNameDescriptionBreedAndAge(
          dogId!,
          dogName!,
          dogDescription!,
          breedName!,
          dogAge!); //llama al método para actualizar el nombre y descripción al dejar de editar
    });
  }

  //metodo del imagePicker para abrir galería y seleccionar una imagen
  final _pickerPerfil = ImagePicker();
  //metodo del imagePicker para abrir galería
  Future<void> _openImagePicker() async {
    File? _image;
    final XFile? pickedImage =
        await _pickerPerfil.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      var storageReference = FirebaseStorage.instance.ref().child(userId!).child(
          '${DateTime.now()}.jpg'); //crea o se dirige a una referencia  (dependiendo si ya existe) con nombre del id del usuario y dentro otra con
      // la fechahora.jpg
      await storageReference.putFile(
          _image!); //guarda la imagen en la referencia de encima con los datos de fechahora.jpg
      profileImageUrl = await storageReference.getDownloadURL();
      try {
        DatabaseService(uid: userId).updateDogProfilePictures(dogId,
            profileImageUrl); //llama al método para actualizar la foto de perfil con la nueva
        // y borra la antigua del storage
      } catch (e) {
        print("No se ha podido borrar nada");
      }

      setState(() {
        dogProfilePicture = profileImageUrl; //modifica la foto de perfil que se muestra con la añadida
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //widget de seccion de nombre
    Widget titleSection = Container(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 0), //left, top, right, bottom
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    dogName!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isShelter
            ? SizedBox(width: 0)
            : IconButton(
                onPressed: _toggleFavorite,
                icon:
                    (_isFavorite //si se presiona o no (cambia el valor o no) muestra un icono u otro
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border)),
                color: Colors.brown,
              ),
        ],
      ),
    );

    //widget de seccion de datos
    Widget dataSection = Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 15), //left, top, right, bottom
      child: Row( //fila con datos de raza y edad
        children: [
          Text(
            breedName!,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          Text(
            " | ",
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          Text(
            dogAge!.toString() + " años",
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );

    //widget de seccion de descripcion
    Widget descriptionSection = Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20), //left, top, right, bottom
      child: ReadMoreText(
        dogDescription!,
        trimLines: 3,
        trimMode: TrimMode.Line,
        trimCollapsedText: ' Mostrar más',
        trimExpandedText: ' Ocultar',
        //estilo de texto que amplía
        moreStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.blueGrey),
        //estilo de texto que reduce
        lessStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.blueGrey),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        //barra superior
        centerTitle: true,
        title: const Text(
          //titulo y su diseño
          'Información',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Colors.brown,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          isShelter
              ? isEditing
                  ? IconButton(
                      onPressed: () {
                        saveText();
                      },
                      icon: const Icon(Icons.save),
                    )
                  : IconButton(
                      onPressed: () {
                        startEditing();
                      },
                      icon: const Icon(Icons.edit),
                    )
              : SizedBox(width: 0)
        ],
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.orangeAccent,
                size: 40,
              ),
            )
          : ListView(
              //cuerpo en formato de lista
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              children: [
                isShelter //si es una protectora
                ? GestureDetector( //al mantener presionado sobre la imagen puede cambiarla
                  onLongPress: _openImagePicker,
                  child: Image.network(
                    //imagen y sus parametros
                    dogProfilePicture!,
                    width: 600,
                    height: 240,
                    fit: BoxFit.contain,
                  ),
                )
                : Image.network( //si es un usuario particular solo ve la imagen
                  //imagen y sus parametros
                    dogProfilePicture!,
                    width: 600,
                    height: 240,
                    fit: BoxFit.contain,
                  ),
                const SizedBox(height: 5), //espacio en blanco de separación
                isEditing
                    ? Padding( //si se esta editando se muestra un TextField
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0), //left, top, right, bottom
                        child: Column(
                          children: [
                            TextField(
                              controller: nameEditingController,
                              maxLength: 20,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Nombre',
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      )
                    : titleSection, //sino, muestra el widget de seccion de titulo
                isEditing //si se está editando se muestra una columna con un DropdownButton y TextField
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0), //left, top, right, bottom
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: breedName,
                              onChanged: (String? newValue) {
                                setState(() {
                                  breedName = newValue!;
                                });
                              },
                              items: razasDePerro.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                      value,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20), //espacio en blanco de separación
                            TextField(
                              controller: dogAgeEditingController,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Edad',
                              ),
                            ),
                            SizedBox(height: 20), //espacio en blanco de separación
                          ],
                        ),
                      )
                    : dataSection, //sino, se muestra el widget de la sección de datos
                isEditing
                    ? Padding( //si se está editando se muestra un TextField
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20), //left, top, right, bottom
                        child: TextField(
                          controller: dogDescriptionEditingController,
                          textCapitalization: TextCapitalization.sentences,
                          textAlign: TextAlign.start,
                          maxLength: 400,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Descripción',
                          ),
                          maxLines: 10,
                        ),
                      )
                    : descriptionSection, //sino, se muestra el widget de la sección de descripción
                const SizedBox(height: 5), //espacio en blanco de separación
                OverflowBar(
                  //barra donde se encuentra el boton de Enviar Mensaje
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isShelter
                        ? ElevatedButton(
                            onPressed: () {
                              showAlertDialogInfo(context, userId!, dogId!);
                            },
                            child: const Text('ELIMINAR PERRO'),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              DatabaseService(uid: userId)
                                  .createNewChat(userId!, shelterId!);
                            },
                            child: const Text('ENVIAR MENSAJE'),
                          )
                  ],
                ),
                SizedBox(height: 10) //espacio en blanco de separación
              ],
            ),
    );
  }
}

//alertDailog de confirmación
showAlertDialogInfo(BuildContext context, String userId, dogId) {
  Widget okButton = TextButton(
    child: const Text("ELIMINAR"),
    onPressed: () async {
      await DatabaseService(uid: userId).deleteDog(dogId).then((value) {
        Navigator.pushNamed(context, '/home');
      });
    },
  );
  Widget cancelButton = TextButton(
    child: const Text("CANCELAR"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(
      'Eliminar perro',
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    ),
    content: const Text(
      '¿Estás seguro de que quieres eliminar este perro?',
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.start,
    ),
    actions: [cancelButton, okButton],
  );
// show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
