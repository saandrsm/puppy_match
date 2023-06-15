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
  List<Card> dogCards = []; //variable para guardar las Cards que muestran a cada perro
  bool isSearching = false; //variable que controla la condición de la barra de búsqueda
  bool isLoading = true; //variable que controla la condición de carga
  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
        ? TextFormField( //si estás buscando se muestra un textField (barra de busqueda)
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar por nombre...',
            hintStyle: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.normal,
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
          ),
        )
        : Text("Bienvenido"), //si no, se muestra un Text
        automaticallyImplyLeading: false,
        actions: [
          isSearching //si esta buscando, al pulsar el boton deja de hacerlo
          ? IconButton(
          onPressed: () {
            stopSearch();
          },
            icon: Icon(Icons.clear),
          )
          : IconButton( //sino, al pulsarlo comienza a hacerlo
            onPressed: () {
              startSearch();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet( //al pulsarse se muestra un menú de opciones
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Wrap(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.pets),
                            title: const Text('Todos'),
                            onTap: ()  {
                              Future.delayed(Duration.zero, (){
                                setState(() {
                                  isLoading = true; //muestra el icono de carga
                                });
                                if(isShelter){
                                  DatabaseService(uid: userId).getAllShelterDogs(context).then((value) { //llama al método para cargar los perros
                                    setState(() {                                                        // de la protectora
                                      isLoading = true;
                                      dogCards.clear(); //vacía la lista de los perros anteriores si los hubiera
                                      dogCards = value; //le asigna la nueva lista de Cards
                                      isLoading = false;
                                    });
                                  });
                                }
                                else{
                                  DatabaseService(uid: userId).getAllDogs(context).then((value) { //llama al método para cargar todos los perros
                                    setState(() {
                                      isLoading = true;
                                      dogCards.clear();
                                      dogCards = value;
                                      isLoading = false;
                                    });
                                  });
                                }
                              });
                              Navigator.pop(context);
                            },
                          ),
                          isShelter
                          ? const SizedBox(height: 0)
                          : ListTile(
                            leading: const Icon(Icons.favorite),
                            title: const Text('Favoritos'),
                            onTap: () {
                              Future.delayed(Duration.zero, (){
                                setState(() {
                                  isLoading = true;
                                });
                                DatabaseService(uid: userId).getFavouriteDogs(context).then((value) { //carga los perros guardados en favoritos
                                  setState(() {
                                    isLoading = true;
                                    dogCards.clear();
                                    dogCards = value;
                                    isLoading = false;
                                  });
                                });
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.female),
                            title: const Text('Hembras'),
                            onTap: () {
                              Future.delayed(Duration.zero, (){
                                setState(() {
                                  isLoading = true;
                                });
                                if(isShelter){
                                  DatabaseService(uid: userId).getShelterFemaleDogs(context).then((value) { //carga los perros de sexo hembra
                                    setState(() {                                                           //de la protectora
                                      isLoading = true;
                                      dogCards.clear();
                                      dogCards = value;
                                      isLoading = false;
                                    });
                                  });
                                }
                                else{
                                  DatabaseService(uid: userId).getFemaleDogs(context).then((value) { //carga los perros de sexo hembra
                                    setState(() {
                                      isLoading = true;
                                      dogCards.clear();
                                      dogCards = value;
                                      isLoading = false;
                                    });
                                  });
                                }
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.male),
                            title: const Text('Machos'),
                            onTap: () {
                              Future.delayed(Duration.zero, (){
                                setState(() {
                                  isLoading = true;
                                });
                                if(isShelter){
                                  DatabaseService(uid: userId).getShelterMaleDogs(context).then((value) { //carga los perros de sexo macho
                                    setState(() {                                                         //de la protectora
                                      isLoading = true;
                                      dogCards.clear();
                                      dogCards = value;
                                      isLoading = false;
                                    });
                                  });
                                }
                                else{
                                  DatabaseService(uid: userId).getMaleDogs(context).then((value) { ////carga los perros de sexo macho
                                    setState(() {
                                      isLoading = true;
                                      dogCards.clear();
                                      dogCards = value;
                                      isLoading = false;
                                    });
                                  });
                                }
                              });
                              Navigator.pop(context); //cierra el menú de opciones
                            },
                          ),
                        ],
                      ),
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
              print('Signed out');
              Navigator.pushNamed(context, '/'); //navega hacia la pantalla de inicio de la app
            });
          },
        ),
      ),
      body: isLoading //muestra el icono de carga o los elementos de la página
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
            childAspectRatio: 8.0 / 9.0,
            children: dogCards, //asigna las cards devueltas por el método ejecutado
            );
      }),
      floatingActionButton: FloatingActionButton(
        //button flotante para acceder al chat
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.black87,
        onPressed: () {
          Navigator.pushNamed(context, '/conversations'); //pasa hacia pantalla de conversaciones
        },
        child: const Icon(Icons.chat_outlined),
      ),
    );
  }

  @override
    void initState() {
      super.initState();
      _searchController.addListener(getDogsByName);
      try {
        userId = firebaseAuth.currentUser?.uid; //obtiene el id del usuario que se le ha asignado al iniciar sesión (auth)
        UserData userData;
        DatabaseService(uid: userId).gettingUserData(userId).then((value) {
          setState(() {
            userData = value;
            isShelter = userData.isShelter!;
            if(isShelter){
              Future.delayed(Duration.zero, (){
                DatabaseService(uid: userId).getAllShelterDogs(context).then((value) {
                  setState(() {
                    dogCards = value;
                    isLoading = false;
                  });
                });
              });
            }
            else{
              Future.delayed(Duration.zero, (){
                DatabaseService(uid: userId).getAllDogs(context).then((value) {
                  setState(() {
                    dogCards = value;
                    isLoading = false;
                  });
                });
              });
            }
          }); //se llama al método para obtener el registro del usuario y sus datos correspondientes, asignando dichos datos a las variables de la clase
        });
      } catch (e) {
        print(e);
      }

    }

//metodos para controlar la busqueda
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

  void getDogsByName(){
    Future.delayed(Duration.zero, (){
      setState(() {
        isLoading = true;
      });
      if(_searchController.text.isEmpty){ //si está vacío, llama a los métodos para mostrar todos los perros
        if(isShelter){
          DatabaseService(uid: userId).getAllShelterDogs(context).then((value) {
            setState(() {
              isLoading = true;
              dogCards.clear();
              dogCards = value;
              isLoading = false;
            });
          });
        }
        else{
          DatabaseService(uid: userId).getAllDogs(context).then((value) {
            setState(() {
              isLoading = true;
              dogCards.clear();
              dogCards = value;
              isLoading = false;
            });
          });
        }
      }
      else{ // si no, llama a los métodos que filtran los perros por nombre
        if(isShelter){
          DatabaseService(uid: userId).getAllShelterDogsByName(context, _searchController.text).then((value) {
            setState(() {
              isLoading = true;
              dogCards.clear();
              dogCards = value;
              isLoading = false;
            });
          });
        }
        else{
          DatabaseService(uid: userId).getAllDogsByName(context, _searchController.text).then((value) {
            setState(() {
              isLoading = true;
              dogCards.clear();
              dogCards = value;
              isLoading = false;
            });
          });
        }
      }
    });
  }
}
