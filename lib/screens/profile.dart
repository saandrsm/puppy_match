import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:PuppyMatch/services/database.dart';
import 'package:PuppyMatch/model/userData.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance; //instancia de la base de datos
  late String? userId;
  bool isEditing = false;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController userDescriptionEditingController = TextEditingController();
  late String? name;
  late String? userDescription;
  late bool isShelter = true; //variable que define el tipo de usuario
  bool isLoading = true;
  late String profileImageUrl;
  late String profilePicture;
  late List<File> imageFileList;

  @override
  void initState() {
    super.initState();
    try {
      userId = firebaseAuth.currentUser?.uid; //obtiene el id del usuario que se le ha asignado al iniciar sesión (auth)
      UserData userData;
      DatabaseService(uid: userId).gettingUserData(userId).then((value) {
        setState(() {
          userData = value;
          name = userData.name;
          userDescription = userData.description;
          isShelter = userData.isShelter!;
          profilePicture = userData.profilePicture!;
        }); //se llama al método para obtener el registro del usuario y sus datos correspondientes, asignando dichos datos a las variables de la clase
        DatabaseService(uid: userId).getUserImages(userId).then((value) {
          setState(() {
            imageFileList = value;
            isLoading = false;
          }); //llama al método getUserImages que devuelve una lista de tipo List<XFile> y la asigna a la variable imageFileList
        });
      });
    } catch (e) {
      print(e);
    }
  }

  //métodos para cambiar y guardar el texto
  @override
  void dispose() {
    nameEditingController.dispose();
    userDescriptionEditingController.dispose();
    super.dispose();
  }

  void startEditing() {
    setState(() {
      isEditing = true;
      nameEditingController.text = name!;
      userDescriptionEditingController.text = userDescription!;
    });
  }

  void saveText() {
    setState(() {
      isEditing = false;
      name = nameEditingController.text;
      userDescription = userDescriptionEditingController.text;
      DatabaseService(uid: userId).updateNameAndDescription(name!,
          userDescription!); //llama al método para actualizar el nombre y descripción en la base de datos al dejar de editar
    });
  }

  //método para abrir la galería del dispositivo y seleccionar varias imágenes
  final ImagePicker imagePicker = ImagePicker();
  void selectedImages() async {
    late String groupImageUrls;
    late File imageElement;
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      selectedImages.forEach((element) {
        setState(() {
          imageElement = File(element.path); //guarda el path de la imagen
        });
        var storageReference = FirebaseStorage.instance
            .ref()
            .child(userId!)
            .child('${DateTime.now()}.jpg'); //crea o se dirige a una referencia  (dependiendo si ya existe) con nombre
                                            //del id del usuario y dentro otra con la fechahora.jpg
        UploadTask uploadTask = storageReference.putFile(imageElement); //guarda la imagen en firebase storage
        uploadTask.whenComplete(() async {
          groupImageUrls = await storageReference.getDownloadURL(); //guarda la url de la imagen en la lista de imágenes
          setState(() {
            imageFileList.add(File(groupImageUrls));
          });
          storageReference.root; //vuelve a la raiz de firebase storage para evitar anidación de carpetas
          FirebaseFirestore.instance.collection('users').doc(userId).update({
            'gallery': FieldValue.arrayUnion([groupImageUrls]) //añade la url al array galería del usuario en la base de datos
          });
        });
      });
    }
    setState(() {});
  }

  final _pickerPerfil = ImagePicker();

  //metodo del imagePicker para abrir galería y seleccionar una imagen
  Future<void> _openImagePicker() async {
    File? _image;
    final XFile? pickedImage =
        await _pickerPerfil.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      var storageReference = FirebaseStorage.instance.ref().child(userId!).child(
          '${DateTime.now()}.jpg'); //crea o se dirige a una referencia  (dependiendo si ya existe) con nombre
                                    //del id del usuario y dentro otra con la fechahora.jpg
      await storageReference.putFile(
          _image!); //guarda la imagen en la referencia de encima con los datos de fechahora.jpg
      profileImageUrl = await storageReference.getDownloadURL();
      try {
        DatabaseService(uid: userId).updateProfilePictures(userId,
            profileImageUrl); //llama al método para actualizar la foto de perfil con la nueva
        // y borra la antigua del storage
      } catch (e) {
        print("No se ha podido borrar nada");
      }
      setState(() {
        profilePicture =
            profileImageUrl; //modifica la foto de perfil que se muestre la nueva
      });
    }
  }

  //metodo del imagePicker para abrir cámara no utilizado
  // Future<void> _takeImagePicker() async {
  //   File? _image;
  //   final XFile? pickedImage =
  //       await _pickerPerfil.pickImage(source: ImageSource.camera);
  //   if (pickedImage != null) {
  //     setState(() {
  //       _image = File(pickedImage.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //barra superior
        centerTitle: true,
        title: const Text(
          //titulo y su formato
          'PUPPY MATCH',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Colors.brown,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          //icono a la izquierda (principio) del texto para cerrar sesión
          icon: const Icon(
            Icons.logout,
            semanticLabel: 'logout',
          ),
          onPressed: () {
            //al presionar vuelve hacia LoginPage
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
        ),
        actions: [
          isEditing //si se está editando, al pulsar el boton se guarda el texto
              ? IconButton(
                  onPressed: () {
                    saveText();
                  },
                  icon: const Icon(Icons.save),
                )
              : IconButton( //si no se esta editando, al pulsar el boton se hace editable
                  onPressed: () {
                    startEditing();
                  },
                  icon: const Icon(Icons.edit),
                ),
        ],
      ),
      body: isLoading
          ? Center( //muestra el icono de carga o el resto de elementos
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.orangeAccent,
                size: 40,
              ),
            )
          : ListView( //cuerpo en formato lista
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              children: [
                //detecta el gesto especificado y realiza una acción
                GestureDetector(
                  //al presionar durante unos segundos se abre la galería
                  onLongPress: _openImagePicker,
                  child: Container(
                    width: 110,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, //forma de imagen circular
                      image: DecorationImage(
                          image: NetworkImage(profilePicture),
                          fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 10), //espacio en blanco de separación
                Container(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, //alineación en el centro
                          children: [
                            Container(
                              //contenedor de texto (para poder poner padding)
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                isShelter ? 'Protectora' : 'Nombre',
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            isEditing //si se está editando se muestra un textField
                                ? TextField(
                                    controller: nameEditingController,
                                    maxLength: 20,
                                    textCapitalization: TextCapitalization.sentences,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  )
                                : Text( //si no se está editando se muestra un Text
                                    name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            const SizedBox(height: 10), //espacio en blanco de separación
                            Container(
                              //contenedor de texto (para poder poner padding)
                              padding: const EdgeInsets.only(bottom: 8),
                              child: const Text(
                                'Descripción',
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: isEditing
                                  ? TextField( //si se está editando se muestra un textField
                                      controller:
                                          userDescriptionEditingController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      textAlign: TextAlign.start,
                                      maxLength: 400,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      maxLines: 10,
                                    )
                                  : ReadMoreText( //si no se está editando se muestra un ReadMoreText
                                      userDescription!,
                                      textAlign: TextAlign.center,
                                      trimLines: 3,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: ' Mostrar más',
                                      trimExpandedText: ' Ocultar',
                                      //estilo de texto que amplía
                                      moreStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.blueGrey),
                                      //estilo de texto que reduce
                                      lessStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.blueGrey),
                                      //estilo de texto general
                                      style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold, //estilo en negrita
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                isShelter //si es una protectora muestra un boton de añadir perro
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/registerDog'); //pasa hacia pantalla de registro de perros
                            },
                            child: const Text('AÑADIR PERRO'),
                          ),
                        ],
                      )
                    : ListView( //si es un usuario particular muestra la galeria de imagenes
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                showAlertDialogInfo(context);
                              },
                              icon: const Icon(
                                Icons.info_outline,
                                semanticLabel: 'info',
                                //color: Colors.brown,
                              ),
                            ),
                            const Expanded(child: SizedBox(width: 5)), //espacio en blanco de separación que rellena el espacio disponible
                            const Text(
                              'Galería',
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 16,
                              ),
                            ),
                            const Expanded(child: SizedBox(width: 5)), //espacio en blanco de separación que rellena el espacio disponible
                            IconButton(
                              onPressed: () {
                                selectedImages();
                              },
                              icon: const Icon(
                                Icons.photo_library_rounded,
                                semanticLabel: 'gallery',
                              ),
                            ),
                            const SizedBox(width: 10), //espacio en blanco de separación
                          ],
                        ),
                        const SizedBox(height: 20), //espacio en blanco de separación
                        GridView.builder(
                          //tabla para mostrar las imagenes seleccionadas
                            padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                            scrollDirection: Axis.vertical, //scroll vertical
                            shrinkWrap: true,
                            itemCount: imageFileList.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              crossAxisCount: 1, //columnas(imagenes) x fila
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              final item = imageFileList[index];
                              return Row(
                                children: [
                                  Expanded(
                                    child: Dismissible(
                                      //widgets eliminables
                                      //la llave identifica los widgets, tiene que ser un String
                                      key: Key(item.path),
                                      onDismissed: (direction) {
                                        //cuando se deslice en cualquier dirección
                                        setState(() {
                                          //se elimina ese item de la lista y del array galería del usuario
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(userId)
                                              .update({
                                            'gallery': FieldValue.arrayRemove(
                                                [imageFileList[index].path])
                                          });
                                          final Reference storageReference = //elimina la imagen de firebase storage
                                          FirebaseStorage.instance.refFromURL(
                                              imageFileList[index].path);
                                          try {
                                            storageReference.delete();
                                          } catch (e) {
                                            print(e);
                                          }
                                          imageFileList.removeAt(index);
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                              content: Text('Imagen eliminada'),
                                              duration: Duration(seconds: 1),
                                        ));
                                      },
                                      child: Image.network(imageFileList[index].path,
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ]
                    ),
              ],
            ),
      floatingActionButton: FloatingActionButton( //button flotante para acceder a la pantalla de conversaciones
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.black87,
        onPressed: () {
          Navigator.pushNamed(context, '/conversations');
        },
        child: const Icon(Icons.chat_outlined),
      ),
    );
  }

//alertDailog de información
  showAlertDialogInfo(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("Entendido"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        'Información',
        style: TextStyle(
            ),
      ),
      content: const Text(
        'Puedes deslizar hacia los lados para eliminar las imágenes de tu perfil.',
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.start,
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
}
