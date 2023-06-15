import 'dart:io';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:PuppyMatch/services/database.dart';
import 'package:PuppyMatch/model/userData.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatUserProfile extends StatefulWidget {
  final String userId;
  const ChatUserProfile({Key? key, required this.userId}) : super(key: key);
  static final routeName = '/chatUserProfile';

  @override
  State<ChatUserProfile> createState() => _ChatUserProfileState(userId);
}

class _ChatUserProfileState extends State<ChatUserProfile> {
  final String userId;
  _ChatUserProfileState(this.userId);
  late String? name;
  late String? userDescription;
  late bool isShelter = true; //variable que define el tipo de usuario
  bool isLoading = true;
  late String profilePicture;
  late List<File> imageFileList;
  @override
  void initState() {
    super.initState();
    try {
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
            Icons.arrow_back,
            semanticLabel: 'logout',
          ),
          onPressed: () {
            //al presionar vuelve hacia LoginPage
            Navigator.pop(context);
          },
        ),
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
          Container(
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
                      Text(
                        name!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                        child: ReadMoreText(
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
              ? const SizedBox(height: 0)
              : ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Row(
                  children: <Widget>[
                    const Expanded(child: SizedBox(width: 5)),
                    const Text(
                      'Galería',
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 16,
                      ),
                    ),
                    const Expanded(child: SizedBox(width: 5)),
                    const SizedBox(
                        width: 10), //espacio en blanco de separación
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
                            child: Image.network(imageFileList[index].path,
                                fit: BoxFit.fill),
                          ),
                        ],
                      );
                    }),
              ]
          ),
        ],
      ),
    );
  }
}
