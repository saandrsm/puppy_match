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
          userDescription!); //llama al método para actualizar el nombre y descripción al dejar de editar
    });
  }

  final ImagePicker imagePicker = ImagePicker();
  void selectedImages() async {
    late String groupImageUrls;
    late File imageElement;
    //File? _image;
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      selectedImages.forEach((element) {
        setState(() {
          imageElement = File(element.path);
        });
        var storageReference = FirebaseStorage.instance
            .ref()
            .child(userId!)
            .child('${DateTime.now()}.jpg');
        UploadTask uploadTask = storageReference.putFile(imageElement);
        uploadTask.whenComplete(() async {
          groupImageUrls = await storageReference.getDownloadURL();
          setState(() {
            imageFileList.add(File(groupImageUrls));
          });
          storageReference.root;
          FirebaseFirestore.instance.collection('users').doc(userId).update({
            'gallery': FieldValue.arrayUnion([groupImageUrls])
          });
        });
      });
    }
    setState(() {});
  }

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
        DatabaseService(uid: userId).updateProfilePictures(userId,
            profileImageUrl); //llama al método para actualizar la foto de perfil con la nueva
        // y borra la antigua del storage
      } catch (e) {
        print("No se ha podido borrar nada");
      }

      setState(() {
        profilePicture =
            profileImageUrl; //modifica la foto de perfil que se muestra con la añadida
      });
    }
  }

  //metodo del imagePicker para abrir cámara
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
    //final ThemeData theme = Theme.of(context); //variable theme para usar colores
    // DatabaseService(uid: userId).getUserProfileImage(userId).then((value){
    //   String? backgroundPicture = value;
    // });

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
            Navigator.pushNamed(context, '/');
          },
        ),
        actions: [
          isEditing
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
                ),
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
              //cuerpo en formato lista
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
                    // child: CircleAvatar(
                    //   radius: 90,
                    //   backgroundImage: NetworkImage(profilePicture),
                    // ),
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
                            isEditing
                                ? TextField(
                                    controller: nameEditingController,
                                    textCapitalization: TextCapitalization.sentences,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  )
                                : Text(
                                    name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            //espacio en blanco de separación
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
                            //prueba de paquete de texto ocultable (leer mas, leer menos)
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: isEditing
                                  ? TextField(
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
                                  : ReadMoreText(
                                      userDescription!,
                                      textAlign: TextAlign.center,
                                      //texto justificado
                                      trimLines: 3,
                                      //colorClickableText: Colors.red,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Show more',
                                      trimExpandedText: ' Hide',
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
                isShelter
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(
                            onPressed: () {
                              Navigator.pushNamed(context,
                                  '/registerDog'); //pasa hacia pantalla dogRegister
                            },
                            child: const Text('AÑADIR PERRO'),
                          ),
                        ],
                      )
                    : ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        Row(
                          //alignment: MainAxisAlignment.center,
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
                            const Expanded(child: SizedBox(width: 5)),
                            const Text(
                              'Galería',
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 16,
                              ),
                            ),
                            const Expanded(child: SizedBox(width: 5)),
                            IconButton(
                              onPressed: () {
                                selectedImages();
                              },
                              icon: const Icon(
                                Icons.photo_library_rounded,
                                semanticLabel: 'gallery',
                                //color: Colors.brown,
                              ),
                              // child: const Text("Abrir Galería",
                              //     style: TextStyle(fontWeight: FontWeight.bold))
                            ),
                            const SizedBox(
                                width: 10), //espacio en blanco de separación
                            //button de abrir camara proxima implementacion en foto de perfil
                            // IconButton(
                            //     onPressed: () {
                            //       _takeImagePicker();
                            //     },
                            //   icon: const Icon(Icons.photo_camera_rounded),
                            //     // child: const Text("Abrir Cámara",
                            //     //     style: TextStyle(fontWeight: FontWeight.bold))
                            // ),
                          ],
                        ),
                        const SizedBox(height: 20), //espacio en blanco de separación
                        GridView.builder(
                          //tabla para mostrar las imagenes seleccionadas
                            padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                            scrollDirection: Axis.vertical,
                            //scroll vertical
                            shrinkWrap: true,
                            itemCount: imageFileList.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              // mainAxisExtent: 350,
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
                                          //se elimina ese item de la lista
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(userId)
                                              .update({
                                            'gallery': FieldValue.arrayRemove(
                                                [imageFileList[index].path])
                                          });
                                          final Reference storageReference =
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
                                          content: Text(
                                              'Imagen eliminada'), //texto del snackbar
                                          duration: Duration(
                                              seconds: 1), //duracion del snackbar
                                        ));
                                      },
                                      //background: Container(color: Colors.red),
                                      child: Image.network(imageFileList[index].path,
                                          fit: BoxFit.fill),
                                      // child: imageFileList!= null
                                      //     ? Image.file(File(imageFileList![index].path), fit: BoxFit.fill)
                                      //     : const Text('Selecciona una imagen'),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ]
                    ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        //button flotante para acceder al chat
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.black87,
        onPressed: () {
          Navigator.pushNamed(context, '/conversations');
          //falta añadir funcionalidad
        },
        child: const Icon(Icons.chat_outlined),
      ),
      // floatingActionButton: isEditing
      //     ? FloatingActionButton(
      //         onPressed: saveText,
      //         child: const Icon(Icons.save),
      //       )
      //     : null,
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
            //color: Colors.orangeAccent
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

//alertDailog para cambiar imagen de perfil
  showAlertDialogPhoto(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget openCamera = TextButton(
      child: const Text("Abrir Cámara"),
      onPressed: () {},
    );

    Widget openGallery = TextButton(
      child: const Text("Abrir Galería"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text('Perfil'),
      content: const Text('Selecciona una imagen de pérfil desde'
          ' la cámara o desde la galería'),
      actions: [
        openCamera,
        openGallery,
        cancelButton,
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
