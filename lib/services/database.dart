import 'dart:io';
import 'package:PuppyMatch/model/chatData.dart';
import 'package:PuppyMatch/model/messageData.dart';
import 'package:PuppyMatch/screens/chatScreen.dart';
import 'package:PuppyMatch/screens/infoDog.dart';
import 'package:deep_route/deep_route.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PuppyMatch/model/userData.dart';
import 'package:PuppyMatch/model/dogData.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid}); //asignación del id del usuario conectado

  //referencias a las colecciones dentro de la base de datos
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference dogCollection = FirebaseFirestore.instance.collection("dogs");
  final CollectionReference chatCollection = FirebaseFirestore.instance.collection("chats");
  final CollectionReference messageCollection = FirebaseFirestore.instance.collection("messages");

  Future registerUserData(String fullname, String email) async{
    await FirebaseStorage.instance.ref("icono_perfil.png").getDownloadURL().then((value) async { //url de la imagen de perfil por defecto guardada en el storage
      return await userCollection.doc(uid).set({
        'uid': uid,
        'name': fullname,
        'email': email,
        'description': "Escribe una descripción.",
        'profilePicture': value,
        'gallery': [],
        'favourites': [],
        'isShelter': false
      }); //crea un nuevo documento en users asociando los datos del argumento, el id de auth y creando los campos con sus valores por defecto
    });
  }

  Future registerDogData(String name, String breed, String sex, int age, String description, String? profileImageUrl) async{
    String dogId = dogCollection.doc().id; //id auto-generado
      return await dogCollection.doc(dogId).set({
        'dogId': dogId,
        'name': name,
        'breed': breed,
        'sex': sex,
        'age': age,
        'description': description,
        'shelterId': uid,
        'profilePicture': profileImageUrl,
      }); //crea un nuevo en dogs con el id auto-generado y los campos indicados en los argumentos,
          // asociando el id de la protectora que está conectada
  }

  Future createNewChat(String regularUserId, String shelterId) async{
    ChatData chatData;
    QuerySnapshot<ChatData> querySnapshot = await chatCollection.where("regularUserId", isEqualTo: regularUserId)
        .where("shelterId", isEqualTo: shelterId).withConverter(
      fromFirestore: ChatData.fromFirestore,
      toFirestore: (ChatData chat, _) => chat.toFirestore(),
    ).get(); //obtiene los datos del chat si el id de usuario o protectora coinciden con algún chat creado en el que se encuentren ambos
    if(querySnapshot.size == 0){ //si no existe
      String chatId = chatCollection.doc().id; //obtiene un id auto-generado
      return await chatCollection.doc(chatId).set({ //crea un nuevo documento en chats con ese id auto generado y los argumentos
        'chatId': chatId,
        'regularUserId': regularUserId,
        'shelterId': shelterId,
      }).then((value) async {
        await gettingChatData(chatId).then((value) { //tras crearlo, guarda el valor del chat para pasarlo como argumento
          chatData = value;
          DeepRoute.toNamed(ChatScreen.routeName, arguments: chatData); //se dirige a la pantalla del chat
        });
      });

    } else { //si existe ya un chat entre usuario y protectora
      for (var docSnapshot in querySnapshot.docs) {
        chatData = docSnapshot.data(); //guarda el valor del chat para pasarlo como argumento
        DeepRoute.toNamed(ChatScreen.routeName, arguments: chatData); //se dirige a la pantalla del chat
      }
    }
  }

  Future<void> sendMessageToChatroom(String chatId, String senderId, String message) async {
    String messageId = messageCollection.doc().id; //id auto-generado
    messageCollection.doc(messageId).set({
      'chatId': chatId,
      'senderId': senderId,
      'text': message,
      'time': Timestamp.now()
    }); //crea un documento en messages con el id auto-generado, los argumentos y le genera un timestamp del momento en el que se llama al método
  }

  Future gettingUserData(String? userId) async {
    final ref = await userCollection.doc(userId).withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData user, _) => user.toFirestore(),
    ); //obtiene la referencia al documento cuyo id es igual al del argumento, convirtiéndolo según el modelo de datos de usuario
    final docSnap = await ref.get(); //obtiene el documento con .get()
    final userData = docSnap.data()!; //obtiene los datos con .data()
    return userData; //devuelve los datos del usuario
  }

  Future gettingDogData(String? dogId) async {
    final ref = await dogCollection.doc(dogId).withConverter(
      fromFirestore: DogData.fromFirestore,
      toFirestore: (DogData dog, _) => dog.toFirestore(),
    ); //obtiene la referencia al documento cuyo id es igual al del argumento, convirtiéndolo según el modelo de datos de perro
    DogData? dogData;
    final docSnap = await ref.get(); //obtiene el documento con .get()
    dogData = docSnap.data(); //obtiene los datos con .data()
    return dogData; //devuelve los datos del perro
  }

  Future gettingChatData(String? chatId) async {
    final ref = await chatCollection.doc(chatId).withConverter(
      fromFirestore: ChatData.fromFirestore,
      toFirestore: (ChatData chat, _) => chat.toFirestore(),
    ); //obtiene la referencia al documento cuyo id es igual al del argumento, convirtiéndolo según el modelo de datos del chat
    ChatData? chatData;
    final docSnap = await ref.get(); //obtiene el documento con .get()
    chatData = docSnap.data(); //obtiene los datos con .data()
    return chatData; //devuelve los datos del chat
  }


  Future<void> updateNameAndDescription(String newName, String newDescription) async {
    try {
      final userRef = userCollection.doc(uid); //obtiene la referencia al usuario actual
      await userRef.update({
        'name': newName,
        'description': newDescription,
      }); //actualiza los campos de esa referencia con los argumentos
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> updateDogNameDescriptionBreedAndAge(String dogId, String newName, String newDescription, String breed, int age) async {
    try {
      final dogRef = dogCollection.doc(dogId); //obtiene la referencia al perro con el argumento dogId
      await dogRef.update({
        'name': newName,
        'description': newDescription,
        'breed': breed,
        'age': age,
      }); //actualiza los campos de esa referencia con los argumentos
    } catch (error) {
      return Future.error(error);
    }
  }


  Future getUserImages(String? userId) async {
    List<File> imageFiles = [];
    UserData? userData;
    gettingUserData(userId).then((value){ //obtiene los datos del usuario
      userData = value;
    });
    final Reference storageReference = FirebaseStorage.instance.ref(userId); //obtiene la referencia del usuario en firebase storage
    final listResult = await storageReference.listAll(); //obtiene las referencias de las imágenes de esa carpeta
    for (var item in listResult.items) {
      String imageUrl = await storageReference.child(item.name).getDownloadURL(); //obtiene los enlaces de cada imagen
      if(imageUrl != userData?.profilePicture){
          imageFiles.add(File(imageUrl)); //añade cada enlace a la lista de imágenes
        };
  }
    return imageFiles; //devuelve la lista
  }

  Future <void> updateProfilePictures(String? userId, String? profileImageUrl) async {
    UserData? userData;
    String? profilePicture;
    gettingUserData(userId).then((value) async { //obtiene los datos del usuario
      userData = value;
      profilePicture = userData?.profilePicture; //guarda el enlace de la imagen antigua del usuario
      try {
        final userRef = userCollection.doc(uid); //obtiene la referencia al documento del usuario
        userRef.update({
          'profilePicture': profileImageUrl,
        }); //actualiza la imagen de perfil con el enlace del argumento
      } catch (error) {
        return Future.error(error);
      }
      await FirebaseStorage.instance.ref("icono_perfil.png").getDownloadURL().then((value) async { //obtiene la referencia de la imagen de perfil por defecto en el storage
      if (profilePicture != value) { //si no coincide la imagen anterior del usuario con la imagen por defecto
        final Reference storageReference = FirebaseStorage.instance.refFromURL(
            profilePicture!); //obtiene la referencia de la antigua imagen de perfil del usuario
        try {
          storageReference.delete(); //borra la antigua imagen de perfil del usuario
        } catch (e) {
          print(e);
        }
      }
    });
    });
  }

  Future <void> updateDogProfilePictures(String? dogId, String? profileImageUrl) async {
    DogData? dogData;
    String? profilePicture;
    gettingDogData(dogId).then((value) async { //obtiene los datos del perro según el id de los argumentos
      dogData = value;
      profilePicture = dogData?.profilePicture; //guarda el enlace de la imagen antigua del perro
      try {
        final dogRef = dogCollection.doc(dogId); //obtiene la referencia al documento del perro
        dogRef.update({
          'profilePicture': profileImageUrl,
        }); //actualiza la imagen de perfil con el enlace del argumento
      } catch (error) {
        return Future.error(error);
      }
      await FirebaseStorage.instance.ref("icono_perfil.png").getDownloadURL().then((value) async { //obtiene la referencia de la imagen de perfil por defecto en el storage
        if (profilePicture != value) { //si no coincide la imagen anterior del perro con la imagen por defecto
          final Reference storageReference = FirebaseStorage.instance
              .refFromURL(profilePicture!); //obtiene la referencia de la antigua imagen de perfil del perro
          try {
            storageReference.delete(); //borra la antigua imagen de perfil del perro
          } catch (e) {
            print(e);
          }
        }
      });
    });
  }

  Future getAllDogs(BuildContext context) async {
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context); //obtiene el tema según el contexto recibido para aplicarlo a la Card
    late String? profilePicture;
    late String? name;
    try {
      QuerySnapshot<DogData> querySnapshot = await dogCollection.withConverter(
        fromFirestore: DogData.fromFirestore,
        toFirestore: (DogData dog, _) => dog.toFirestore(),
      ).get(); //obtiene todos los documentos en la colección de perros, convirtiéndolo según el modelo de datos del perro
        for (var docSnapshot in querySnapshot.docs) {
          DogData dogData = docSnapshot.data(); //obtiene los datos de cada documento y asigna el nombre y la fotografía a los campos de la Card
          profilePicture = dogData.profilePicture;
          name = dogData.name;
          Card dogCard = new Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //alineado en el centro
                children: <Widget>[
                  Expanded(
                    // height: 135,
                    // width: 300,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: GestureDetector(
                        onTap: () => DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId), //se dirige a la pantalla de perfil de perro pasando el id
                        child: Image.network(
                          profilePicture!,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        foregroundColor: theme.colorScheme
                            .secondary //usar esquema determinado para color de fuente
                    ),
                    onPressed: () {
                      DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId); //se dirige a la pantalla de perfil de perro pasando el id
                    },
                    child: Text(
                        name!),
                  ),
                ],
              ),
            ),
          );
          dogCards.add(dogCard); //añade cada Card a la lista
        }
    } catch (error){
      return Future.error(error);
    }

      return dogCards; //devuelve la lista con cada perro guardado en una Card
  }

  Future getAllDogsByName(BuildContext context, String searchedName) async {
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context);
    late String? profilePicture;
    late String? name;
    try {
      QuerySnapshot<DogData> querySnapshot = await dogCollection.where("name", isEqualTo: searchedName).withConverter(
        fromFirestore: DogData.fromFirestore,
        toFirestore: (DogData dog, _) => dog.toFirestore(),
      ).get(); //obtiene todos los documentos en la colección de perros cuyo nombre sea igual al nombre del argumento
      for (var docSnapshot in querySnapshot.docs) {
        DogData dogData = docSnapshot.data();
        profilePicture = dogData.profilePicture;
        name = dogData.name;
        Card dogCard = new Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //alineado en el centro
              children: <Widget>[
                Expanded(
                  // height: 135,
                  // width: 300,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: GestureDetector(
                      onTap: () => DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId),
                      child: Image.network(
                        profilePicture!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      foregroundColor: theme.colorScheme
                          .secondary //usar esquema determinado para color de fuente
                  ),
                  onPressed: () {
                    DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId);
                  },
                  child: Text(
                      name!),
                ),
              ],
            ),
          ),
        );
        dogCards.add(dogCard);
      }
    } catch (error){
      return Future.error(error);
    }

    return dogCards;
  }

  Future getAllShelterDogs(BuildContext context) async {
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context);
    late String? profilePicture;
    late String? name;
    try {
      QuerySnapshot<DogData> querySnapshot = await dogCollection.where("shelterId", isEqualTo: uid).withConverter(
        fromFirestore: DogData.fromFirestore,
        toFirestore: (DogData dog, _) => dog.toFirestore(),
      ).get(); //obtiene todos los documentos en la colección de perros cuyo id sea igual al id de la protectora
      for (var docSnapshot in querySnapshot.docs) {
        DogData dogData = docSnapshot.data();
        profilePicture = dogData.profilePicture;
        name = dogData.name;
        Card dogCard = new Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //alineado en el centro
              children: <Widget>[
                Expanded(
                  // height: 135,
                  // width: 300,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: GestureDetector(
                      onTap: () => DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId),
                      child: Image.network(
                        profilePicture!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      foregroundColor: theme.colorScheme
                          .secondary //usar esquema determinado para color de fuente
                  ),
                  onPressed: () {
                    DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId);
                  },
                  child: Text(
                      name!),
                ),
              ],
            ),
          ),
        );
        dogCards.add(dogCard);
      }
    } catch (error){
      return Future.error(error);
    }

    return dogCards;
  }

  Future getAllShelterDogsByName(BuildContext context, String searchedName) async {
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context);
    late String? profilePicture;
    late String? name;
    try {
      QuerySnapshot<DogData> querySnapshot = await dogCollection.where("shelterId", isEqualTo: uid)
          .where("name", isEqualTo: searchedName).withConverter(
        fromFirestore: DogData.fromFirestore,
        toFirestore: (DogData dog, _) => dog.toFirestore(),
      ).get(); //obtiene todos los documentos en la colección de perros cuyo id sea igual al id de la protectora y
              // cuyo nombre sea igual al nombre del argumento
      for (var docSnapshot in querySnapshot.docs) {
        DogData dogData = docSnapshot.data();
        profilePicture = dogData.profilePicture;
        name = dogData.name;
        Card dogCard = new Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //alineado en el centro
              children: <Widget>[
                Expanded(
                  // height: 135,
                  // width: 300,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: GestureDetector(
                      onTap: () => DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId),
                      child: Image.network(
                        profilePicture!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      foregroundColor: theme.colorScheme
                          .secondary //usar esquema determinado para color de fuente
                  ),
                  onPressed: () {
                    DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId);
                  },
                  child: Text(
                      name!),
                ),
              ],
            ),
          ),
        );
        dogCards.add(dogCard);
      }
    } catch (error){
      return Future.error(error);
    }

    return dogCards;
  }

  Future getAllRegularUserChats() async {
    List<ChatData> chats = [];
    try {
      QuerySnapshot<ChatData> querySnapshot = await chatCollection.where("regularUserId", isEqualTo: uid).withConverter(
        fromFirestore: ChatData.fromFirestore,
        toFirestore: (ChatData chat, _) => chat.toFirestore(),
      ).get(); //obtiene todos los documentos en la colección de chats cuyo id de usuario sea igual al id del usuario conectado,
              // convirtiéndolo según el modelo de datos del chat
      for (var docSnapshot in querySnapshot.docs) {
        ChatData chatData = docSnapshot.data(); //obtiene los datos de cada chat
        chats.add(chatData); //añade cada chat a la lista
      }
    } catch (error){
      return Future.error(error);
    }
    return chats; //devuelve la lista
  }

  Future getAllShelterChats() async {
    List<ChatData> chats = [];
    try {
      QuerySnapshot<ChatData> querySnapshot = await chatCollection.where("shelterId", isEqualTo: uid).withConverter(
        fromFirestore: ChatData.fromFirestore,
        toFirestore: (ChatData chat, _) => chat.toFirestore(),
      ).get(); //obtiene todos los documentos en la colección de chats cuyo id de protectora sea igual al id del usuario conectado
      for (var docSnapshot in querySnapshot.docs) {
        ChatData chatData = docSnapshot.data();
        chats.add(chatData);
      }
    } catch (error){
      return Future.error(error);
    }
    return chats;
  }

  Future getAllMessagesFromChat(String? chatId) async {
    Stream<QuerySnapshot<MessageData>> querySnapshot = await messageCollection.where("chatId", isEqualTo: chatId)
        .orderBy('time', descending: true).withConverter(
      fromFirestore: MessageData.fromFirestore,
      toFirestore: (MessageData message, _) => message.toFirestore(),
    ).snapshots(); //obtiene todos los documentos en la colección de mensajes cuyo id de chat sea igual al id del argumento,
    // convirtiéndolo según el modelo de datos del mensaje
    return querySnapshot;
  }

  Future getLastMessageDataFromChat(String? chatId) async {
    List<MessageData> messages = [];
    QuerySnapshot<MessageData> querySnapshot = await messageCollection.where("chatId", isEqualTo: chatId)
        .orderBy('time', descending: true).withConverter(
      fromFirestore: MessageData.fromFirestore,
      toFirestore: (MessageData message, _) => message.toFirestore(),
    ).get();//obtiene todos los documentos en la colección de mensajes cuyo id de chat sea igual al id del argumento,
    // ordenándolo para obtener el primero (o el último enviado)
    for (var docSnapshot in querySnapshot.docs) {
      MessageData messageData = docSnapshot.data();
      messages.add(messageData);
    }
    if(messages.length > 0){ //si hay mensajes, obtiene el último enviado / primero de la lista
      MessageData lastMessageData = messages.first;
      return lastMessageData;
    } else{ //si no, devuelve un mensaje vacío
      MessageData lastMessageData = new MessageData(chatId: chatId, senderId: uid, text: "", time: Timestamp.now());
      return lastMessageData;
    }
  }

  Future getMaleDogs(BuildContext context) async{
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context);
    late String? profilePicture;
    late String? name;
    QuerySnapshot<DogData> querySnapshot = await dogCollection.where("sex", isEqualTo: "male").withConverter(
      fromFirestore: DogData.fromFirestore,
      toFirestore: (DogData dog, _) => dog.toFirestore(),
    ).get(); //obtiene todos los documentos en la colección de perros cuyo sexo sea macho
      for (var docSnapshot in querySnapshot.docs) {
        final dogData = docSnapshot.data();
        profilePicture = dogData.profilePicture;
        name = dogData.name;
        Card dogCard = new Card(
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
                    child: GestureDetector(
                      onTap: () => DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId),
                      child: Image.network(
                        profilePicture!,
                        //snapshot.data?.imagen ?? 'https://images.dog.ceo/breeds/greyhound-italian/n02091032_7813.jpg',
                        fit: BoxFit.fill,
                      ),
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
                    DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId);
                  },
                  child: Text(name!), //el texto es el getter del nombre del perro
                ),
              ],
            ),
          ),
        );
        dogCards.add(dogCard);
      }

    return dogCards;
  }

  Future getShelterMaleDogs(BuildContext context) async {
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context);
    late String? profilePicture;
    late String? name;
    try {
      QuerySnapshot<DogData> querySnapshot = await dogCollection.where("shelterId", isEqualTo: uid).where("sex", isEqualTo: "male").withConverter(
        fromFirestore: DogData.fromFirestore,
        toFirestore: (DogData dog, _) => dog.toFirestore(),
      ).get(); //obtiene todos los documentos en la colección de perros cuyo id sea igual al id de la protectora y
      // cuyo sexo sea macho
      for (var docSnapshot in querySnapshot.docs) {
        DogData dogData = docSnapshot.data();
        profilePicture = dogData.profilePicture;
        name = dogData.name;
        Card dogCard = new Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //alineado en el centro
              children: <Widget>[
                Expanded(
                  // height: 135,
                  // width: 300,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: GestureDetector(
                      onTap: () => DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId),
                      child: Image.network(
                        profilePicture!,
                        //snapshot.data?.imagen ?? 'https://images.dog.ceo/breeds/greyhound-italian/n02091032_7813.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      foregroundColor: theme.colorScheme
                          .secondary //usar esquema determinado para color de fuente
                  ),
                  onPressed: () {
                    //al presional pasa hacia pantalla InfoDog
                    DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId);
                  },
                  child: Text(
                      name!), //el texto es el getter del nombre del perro
                ),
              ],
            ),
          ),
        );
        dogCards.add(dogCard);
      }
    } catch (error){
      //return Future.error(error);
      return print("está fallando esto");
    }

    return dogCards;
  }

  Future getFemaleDogs(BuildContext context) async{
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context);
    late String? profilePicture;
    late String? name;
    QuerySnapshot<DogData> querySnapshot = await dogCollection.where("sex", isEqualTo: "female").withConverter(
      fromFirestore: DogData.fromFirestore,
      toFirestore: (DogData dog, _) => dog.toFirestore(),
    ).get(); //obtiene todos los documentos en la colección de perros cuyo sexo sea hembra
      for (var docSnapshot in querySnapshot.docs) {
        final dogData = docSnapshot.data();
        profilePicture = dogData.profilePicture;
        name = dogData.name;
        Card dogCard = new Card(
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
                    child: GestureDetector(
                      onTap: () => DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId),
                      child: Image.network(
                        profilePicture!,
                        //snapshot.data?.imagen ?? 'https://images.dog.ceo/breeds/greyhound-italian/n02091032_7813.jpg',
                        fit: BoxFit.fill,
                      ),
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
                    DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId);
                  },
                  child: Text(name!), //el texto es el getter del nombre del perro
                ),
              ],
            ),
          ),
        );
        dogCards.add(dogCard);
      }
    return dogCards;
  }

  Future getShelterFemaleDogs(BuildContext context) async {
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context);
    late String? profilePicture;
    late String? name;
    try {
      QuerySnapshot<DogData> querySnapshot = await dogCollection.where("shelterId", isEqualTo: uid).where("sex", isEqualTo: "female").withConverter(
        fromFirestore: DogData.fromFirestore,
        toFirestore: (DogData dog, _) => dog.toFirestore(),
      ).get(); //obtiene todos los documentos en la colección de perros cuyo id sea igual al id de la protectora y
      // cuyo sexo sea hembra
      for (var docSnapshot in querySnapshot.docs) {
        DogData dogData = docSnapshot.data();
        profilePicture = dogData.profilePicture;
        name = dogData.name;
        Card dogCard = new Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //alineado en el centro
              children: <Widget>[
                Expanded(
                  // height: 135,
                  // width: 300,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: GestureDetector(
                      onTap: () => DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId),
                      child: Image.network(
                        profilePicture!,
                        //snapshot.data?.imagen ?? 'https://images.dog.ceo/breeds/greyhound-italian/n02091032_7813.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      foregroundColor: theme.colorScheme
                          .secondary //usar esquema determinado para color de fuente
                  ),
                  onPressed: () {
                    //al presional pasa hacia pantalla InfoDog
                    DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId);
                  },
                  child: Text(
                      name!), //el texto es el getter del nombre del perro
                ),
              ],
            ),
          ),
        );
        dogCards.add(dogCard);
      }
    } catch (error){
      return Future.error(error);
    }

    return dogCards;
  }

  Future getFavouriteDogs(BuildContext context) async {
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context);
    late String? profilePicture;
    late String? name;
    UserData? userData;
    DogData dogData;
    List<String>? favouriteDogs;
    await gettingUserData(uid).then((value){
      userData = value;
      favouriteDogs = userData!.favourites;
    }); //obtiene los datos del usuario y asigna a una variable la lista de ids de los perros favoritos
    for(var dogId in favouriteDogs!){
        await gettingDogData(dogId).then((value) { //obtiene los datos de cada perro por su ID y los asigna a la card
        dogData = value;
        profilePicture = dogData.profilePicture;
        name = dogData.name;
        Card dogCard = new Card(
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
                    child: GestureDetector(
                      onTap: () => DeepRoute.toNamed(InfoDog.routeName, arguments: dogId),
                      child: Image.network(
                        profilePicture!,
                        fit: BoxFit.fill,
                      ),
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
                    DeepRoute.toNamed(InfoDog.routeName, arguments: dogId);
                  },
                  child: Text(name!),
                ),
              ],
            ),
          ),
        );
        dogCards.add(dogCard);
      });
    }
    return dogCards;
  }

  Future<void> deleteDog(String dogId) async {
    DogData? dogData;
    String? profilePicture;
    await gettingDogData(dogId).then((value) async { //obtiene los datos del perro según el ID de argumentos
      dogData = value;
      profilePicture = dogData?.profilePicture; //guarda la url de la imagen de perfil
      try {
        final dogRef = dogCollection.doc(dogId); //obtiene la referencia al documento del perro en la base de datos
        await dogRef.delete().then((value) async { //borra el perro de la base de datos
          QuerySnapshot<UserData> querySnapshot = await userCollection.where("favourites", arrayContains: dogId).withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData user, _) => user.toFirestore(),
          ).get(); //obtiene los documentos de los usuarios que tenga el id de este perro en favoritos
          for (var docSnapshot in querySnapshot.docs) {
                final userRef = docSnapshot.reference;
                userRef.update({
                  'favourites': FieldValue.arrayRemove([dogId])
                }); //por cada usuario, elimina del array de favoritos el id del perro
          }
        });
      } catch (error) {
          return Future.error(error);
      }
    });
    final Reference storageReference = FirebaseStorage.instance.refFromURL(profilePicture!);
    try { //obtiene la referencia de la url de la imagen de perfil del perro y la borra
      storageReference.delete();
    } catch (e) {
        print(e);
    }
  }
  Future<void> addDogFavourite(String dogId) async{
    userCollection.doc(uid).update({ //obtiene el documento del usuario conectado y añade el id del perro a favoritos
      'favourites': FieldValue.arrayUnion([dogId])
    });
  }

  Future<void> removeDogFavourite(String dogId) async{
    userCollection.doc(uid).update({ //obtiene el documento del usuario conectado y elimina el id del perro de favoritos
      'favourites': FieldValue.arrayRemove([dogId])
    });
  }
}