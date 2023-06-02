import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  String initialText1 = 'Nombre provisional';
  String initialText2 =
      'Aquí tiene que haber una descripción del usuario que explique '
      'un poco por encima su entorno, situación y personalidad. '
      'Cuántos animales ha cuidado, cuales son, como fue, cual es su situacion '
      'actual, en que tipo de casa residen, si tiene experiencia en '
      'adiestramiento, en participación en protectoras, en trabajos con '
      'animales, etc. Tendrá un máximo de caracteres. ';

  @override
  void dispose() {
    textEditingController1.dispose();
    textEditingController2.dispose();
    super.dispose();
  }

  void startEditing() {
    setState(() {
      isEditing = true;
      textEditingController1.text = initialText1;
      textEditingController2.text = initialText2;
    });
  }

  void saveText() {
    setState(() {
      isEditing = false;
      initialText1 = textEditingController1.text;
      initialText2 = textEditingController2.text;
    });
  }

  bool isShelter = false; //variable que define el tipo de usuario

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectedImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

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

  //metodo del imagePicker para abrir cámara
  Future<void> _takeImagePicker() async {
    final XFile? pickedImage =
        await _pickerPerfil.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); //variable theme para usar colores
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
      body: ListView(
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle, //forma de imagen circular
                image: DecorationImage(
                    image: AssetImage('assets/icono_perfil.png'),
                    fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 10), //espacio en blanco de separación
          //dataSection,
          Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, //alineación en el centro
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
                         controller: textEditingController1,
                         textCapitalization: TextCapitalization.sentences,
                         decoration: const InputDecoration(
                           border: OutlineInputBorder(),
                         ),
                       )
                       : Text(
                        initialText1,
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
                                controller: textEditingController2,
                                textCapitalization: TextCapitalization.sentences,
                                textAlign: TextAlign.start,
                                maxLength: 400,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 10,
                              )
                            : ReadMoreText(
                                  initialText2,
                                  textAlign: TextAlign.center,
                                  //texto justificado
                                  trimLines: 3,
                                  //colorClickableText: Colors.red,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Hide',
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
                  Navigator.pushNamed(context, '/registerDog'); //pasa hacia pantalla dogRegister
                },
                child: const Text('AÑADIR PERRO'),
              ),
            ],
          )
          : Row(
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
                  //_openImagePicker();
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
              const SizedBox(width: 10), //espacio en blanco de separación
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
              itemCount: imageFileList!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 10,
                // mainAxisExtent: 350,
                crossAxisCount: 1, //columnas(imagenes) x fila
              ),
              itemBuilder: (BuildContext context, int index) {
                final item = imageFileList![index];
                //si lo rodeo con un expanded y una row respectivamente
                //el tamaño de las fotos se ajusta
                return Dismissible(
                  //widgets eliminables
                  //la llave identifica los widgets, tiene que ser un String
                  key: Key(item.path),
                  onDismissed: (direction) {
                    //cuando se deslice en cualquier dirección
                    setState(() {
                      //se elimina ese item de la lista
                      imageFileList?.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Imagen eliminada'), //texto del snackbar
                      duration: Duration(seconds: 1), //duracion del snackbar
                    ));
                  },
                  //background: Container(color: Colors.red),
                  child: Image.file(File(imageFileList![index].path),
                      fit: BoxFit.fill),
                  // child: imageFileList!= null
                  //     ? Image.file(File(imageFileList![index].path), fit: BoxFit.fill)
                  //     : const Text('Selecciona una imagen'),
                );
              }),
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

  //widget de seccion de datos
//   Widget dataSection = Container(
//     padding: const EdgeInsets.all(30),
//     child: Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.center, //alineación en el centro
//             children: [
//               Container(
//                 //contenedor de texto (para poder poner padding)
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: const Text(
//                   'Nombre de usuario',
//                   style: TextStyle(
//                     color: Colors.orangeAccent,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               const Text(
//                 '@username',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20), //espacio en blanco de separación
//               Container(
//                 //contenedor de texto (para poder poner padding)
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: const Text(
//                   'Descripción',
//                   style: TextStyle(
//                     color: Colors.orangeAccent,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               //prueba de paquete de texto ocultable (leer mas, leer menos)
//               isEditing
//                 ? TextField(
//                   controller: textEditingController,
//                   decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   ),
//                 : GestureDetector(
//                   onTap: startEditing,
//                   child: ReadMoreText(
//                     'Aquí tiene que haber una descripción del usuario que explique '
//                     'un poco por encima su entorno, situación y personalidad. '
//                     'Cuántos animales ha cuidado, cuales son, como fue, cual es su situacion '
//                     'actual, en que tipo de casa residen, si tiene experiencia en '
//                     'adiestramiento, en participación en protectoras, en trabajos con '
//                     'animales, etc. Tendrá un máximo de caracteres. ',
//                     textAlign: TextAlign.center, //texto justificado
//                     trimLines: 3,
//                     //colorClickableText: Colors.red,
//                     trimMode: TrimMode.Line,
//                     trimCollapsedText: 'Show more',
//                     trimExpandedText: 'Hide',
//                     //estilo de texto que amplía
//                     moreStyle: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.normal,
//                         color: Colors.blueGrey),
//                     //estilo de texto que reduce
//                     lessStyle: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.normal,
//                         color: Colors.blueGrey),
//                     //estilo de texto general
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold, //estilo en negrita
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

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
