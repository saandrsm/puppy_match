import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:PuppyMatch/services/database.dart';
import 'package:PuppyMatch/model/userData.dart';
import 'package:PuppyMatch/model/dogData.dart';


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
  late bool isShelter = true; //variable que define el tipo de usuario
  bool isLoading = true;
  late String profilePicture;
  //late List<File> imageFileList;
  bool isSearching = false;

    @override
    void initState() {
      super.initState();
      try {
        userId = firebaseAuth.currentUser?.uid; //obtiene el id del usuario que se le ha asignado al iniciar sesión (auth)
        UserData userData;
        DogData dogData;
        DatabaseService(uid: userId).gettingUserData(userId).then((value) {
          setState(() {
            userData = value;
            isShelter = userData.isShelter!;
          }); //se llama al método para obtener el registro del usuario y sus datos correspondientes, asignando dichos datos a las variables de la clase
          DatabaseService(uid: dogId).gettingDogData(dogId).then((value) {
            setState(() {
              dogData = value;
              name = dogData.name!;
              breed = dogData.breed!;
              description = dogData.description!;
              profilePicture = dogData.profilePicture!;
            });
          });
        });
      } catch (e) {
        print(e);
      }
    }

  //metodo para generar Cards con coleccion de perros
  List<Card> _buildGridCards(BuildContext context) {
    final ThemeData theme = Theme.of(context); //variable theme para usar colores

    firebaseFire.collection("dogs").get().then(
            (querySnapshot) {
          print("Successfully completed");
          for (var docSnapshot in querySnapshot.docs) {
              List<DocumentSnapshot> perros = querySnapshot.docs;
              if (perros.isEmpty) {
                //si la lista estuviera vacia devolvería una Card vacia
                return const <Card>[];
              } else {
                return perros.map((perros) {
                  return Card(
                    //clipBehavior: Clip.antiAlias, //esto aún no se que es
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, //alineado en el centro
                        children: <Widget>[
                          Expanded(
                            // height: 135,
                            // width: 300,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              child: Image.network(
                                profilePicture,
                                //snapshot.data?.imagen ?? 'https://images.dog.ceo/breeds/greyhound-italian/n02091032_7813.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                foregroundColor: theme.colorScheme.secondary //usar esquema determinado para color de fuente
                            ),
                            onPressed: () {
                              //al presional pasa hacia pantalla InfoDog
                              Navigator.pushNamed(context, '/info');
                            },
                            child: Text(name!), //el texto es el getter del nombre del perro
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList();
              }
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
  }

  final TextEditingController _searchController = TextEditingController();

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
                            Navigator.pop(context);
                          },
                        ),
                        isShelter
                        ? const SizedBox(height: 0)
                        : ListTile(
                          leading: const Icon(Icons.favorite),
                          title: const Text('Favoritos'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.female),
                          title: const Text('Hembras'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.male),
                          title: const Text('Machos'),
                          onTap: () {
                            Navigator.pop(context);
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
      body: OrientationBuilder(
          //el cuerpo es un orientation builder para controlar las columns en horizontal
          builder: (context, orientation) {
        return GridView.count(
            //hay 2 columns en vertical y 4 en horizontal
            crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
            padding: const EdgeInsets.all(16.0),
            childAspectRatio: 8.0 / 9.0, //esto no se muy bien que es
            children: _buildGridCards(context) //llama al metodo para generar las Cards
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
}

// void _onTap() {
//   print('Hola');
// }
