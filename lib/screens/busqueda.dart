import 'package:PuppyMatch/model/dogData.dart';
import 'package:PuppyMatch/model/userData.dart';
import 'package:PuppyMatch/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance; //instancia de la base de datos
  final FirebaseFirestore firebaseFire = FirebaseFirestore.instance; //instancia de la base de datos
  late String? userId;
  late String? dogId;
  late String? name;
  late String? breed;
  late String? shelterId;
  late String? description;
  late bool isShelter; //variable que define el tipo de usuario
  late String profilePicture;
  List<Card> dogCards = [];
  //late List<File> imageFileList;
  bool isSearching = false;

    final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
        ? TextFormField(
          onChanged: (text) {
            //aqui falta implementar funcionalidad de busqueda
          },
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: ' Search...',
            hintStyle: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.normal,
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
          ),
        )
        : Text("Bienvenido"),
        automaticallyImplyLeading: false, //esto no lo entiendo
        actions: [
          isSearching
          ? IconButton(
          onPressed: () {
            stopSearch();
          },
            icon: Icon(Icons.clear),
          )
          : IconButton(
            onPressed: () {
              startSearch();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              //Navigator.pushNamed(context, '/api');
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.pets),
                          title: const Text('Todos'),
                          onTap: () {
                            setState(() {
                              dogCards.clear();
                              dogCards = DatabaseService(uid: userId).getAllDogs(context);
                              Navigator.pop(context);
                            });
                          },
                        ),
                        isShelter
                        ? const SizedBox(height: 0)
                        : ListTile(
                          leading: const Icon(Icons.favorite),
                          title: const Text('Favoritos'),
                          onTap: () {
                            setState(() {
                              dogCards.clear();
                              dogCards = DatabaseService(uid: userId).getFavouriteDogs(context);
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.female),
                          title: const Text('Hembras'),
                          onTap: () {
                            setState(() {
                              dogCards.clear();
                              dogCards = DatabaseService(uid: userId).getFemaleDogs(context);
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.male),
                          title: const Text('Machos'),
                          onTap: () {
                            setState(() {
                              dogCards.clear();
                              dogCards = DatabaseService(uid: userId).getMaleDogs(context);
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(
              Icons.filter_list,
              semanticLabel: 'filter',
            ),
          ),
        ],
        leading: IconButton(
          //icono a la izquierda (principio) del texto para cerrar sesión
          icon: const Icon(
            Icons.logout,
            semanticLabel: 'logout',
          ),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              //al presionar vuelve hacia LoginPage
              print('Signed out');
              Navigator.pushNamed(context, '/');
            });
          },
        ),
      ),
      body: dogCards.isEmpty
          ? Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.orangeAccent,
          size: 40,
        ),
      ):OrientationBuilder(
          //el cuerpo es un orientation builder para controlar las columns en horizontal
          builder: (context, orientation) {
        return GridView.count(
            //hay 2 columns en vertical y 4 en horizontal
            crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
            padding: const EdgeInsets.all(16.0),
            childAspectRatio: 8.0 / 9.0, //esto no se muy bien que es
            children: dogCards, //llama al metodo para generar las Cards
            );
      }),
      floatingActionButton: FloatingActionButton(
        //button flotante para acceder al chat
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.black87,
        onPressed: () {
          Navigator.pushNamed(context, '/registerDog'); //pasa hacia pantalla Chat

          //falta añadir funcionalidad
        },
        child: const Icon(Icons.chat_outlined),
      ),
    );
  }

  @override
    void initState() {
      super.initState();
      try {
        userId = firebaseAuth.currentUser?.uid; //obtiene el id del usuario que se le ha asignado al iniciar sesión (auth)
        UserData userData;
        DatabaseService(uid: userId).gettingUserData(userId).then((value) {
          setState(() {
            userData = value;
            isShelter = userData.isShelter!;
          }); //se llama al método para obtener el registro del usuario y sus datos correspondientes, asignando dichos datos a las variables de la clase
        });
        Future.delayed(Duration.zero, () {
          setState(() {
            dogCards = DatabaseService(uid: userId).getAllDogs(context);
          });
        });

      } catch (e) {
        print(e);
      }
    }


  void startSearch() {
    setState(() {
      isSearching = true;
      _searchController.text = "";
    });
  }



  void stopSearch() {
    setState(() {
      isSearching = false;
    });
  }
}

// void _onTap() {
//   print('Hola');
// }
