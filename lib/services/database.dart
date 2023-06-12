import 'dart:io';
import 'package:PuppyMatch/screens/infoDog.dart';
import 'package:deep_route/deep_route.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PuppyMatch/model/userData.dart';
import 'package:PuppyMatch/model/dogData.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference dogCollection = FirebaseFirestore.instance.collection("dogs");

  Future registerUserData(String fullname, String email) async{
    await FirebaseStorage.instance.ref("icono_perfil.png").getDownloadURL().then((value) async {
      return await userCollection.doc(uid).set({
        'uid': uid,
        'name': fullname,
        'email': email,
        'description': "Escribe una descripción.",
        'profilePicture': value,
        'gallery': [],
        'favourites': [],
        'isShelter': false
      });
    });
  }

  Future registerDogData(String name, String breed, String sex, int age, String description, String? profileImageUrl) async{
    String dogId = dogCollection.doc().id;
      return await dogCollection.doc(dogId).set({
        'dogId': dogId,
        'name': name,
        'breed': breed,
        'sex': sex,
        'age': age,
        'description': description,
        'shelterId': uid,
        'profilePicture': profileImageUrl,
        'gallery': []
      });
  }

  Future gettingUserData(String? userId) async {
    final ref = await userCollection.doc(userId).withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData user, _) => user.toFirestore(),
    );
    final docSnap = await ref.get();
    final userData = docSnap.data()!;
    return userData;
  }

  Future gettingDogData(String? dogId) async {
    final ref = await dogCollection.doc(dogId).withConverter(
      fromFirestore: DogData.fromFirestore,
      toFirestore: (DogData dog, _) => dog.toFirestore(),
    );
    DogData? dogData;
    final docSnap = await ref.get();
    dogData = docSnap.data();
    return dogData;

  }

  Future<void> updateNameAndDescription(String newName, String newDescription) async {
    try {
      final userRef = userCollection.doc(uid);
      await userRef.update({
        'name': newName,
        'description': newDescription,
      });
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> updateDogNameDescriptionBreedAndAge(String dogId, String newName, String newDescription, String breed, int age) async {
    try {
      final dogRef = dogCollection.doc(dogId);
      await dogRef.update({
        'name': newName,
        'description': newDescription,
        'breed': breed,
        'age': age,
      });
    } catch (error) {
      return Future.error(error);
    }
  }


  Future getUserImages(String? userId) async {
    List<File> imageFiles = [];
    UserData? userData;
    gettingUserData(userId).then((value){
      userData = value;
    });
    final Reference storageReference = FirebaseStorage.instance.ref(userId);
    final listResult = await storageReference.listAll();
    for (var item in listResult.items) {
      String imageUrl = await storageReference.child(item.name).getDownloadURL();
      if(imageUrl != userData?.profilePicture){
          imageFiles.add(File(imageUrl));
        };
  }
    return imageFiles;
  }

  Future <void> updateProfilePictures(String? userId, String? profileImageUrl) async {
    UserData? userData;
    String? profilePicture;
    gettingUserData(userId).then((value) async {
      userData = value;
      profilePicture = userData?.profilePicture;
      try {
        final userRef = userCollection.doc(uid);
        userRef.update({
          'profilePicture': profileImageUrl,
        });
      } catch (error) {
        return Future.error(error);
      }
      await FirebaseStorage.instance.ref("icono_perfil.png").getDownloadURL().then((value) async {
      if (profilePicture != value) {
        final Reference storageReference = FirebaseStorage.instance.refFromURL(
            profilePicture!);
        try {
          storageReference.delete();
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
    gettingDogData(dogId).then((value) async {
      dogData = value;
      profilePicture = dogData?.profilePicture;
      try {
        final dogRef = dogCollection.doc(dogId);
        dogRef.update({
          'profilePicture': profileImageUrl,
        });
      } catch (error) {
        return Future.error(error);
      }
      await FirebaseStorage.instance.ref("icono_perfil.png").getDownloadURL().then((value) async {
        if (profilePicture != value) {
          final Reference storageReference = FirebaseStorage.instance
              .refFromURL(profilePicture!);
          try {
            storageReference.delete();
          } catch (e) {
            print(e);
          }
        }
      });
    });
  }

  Future getAllDogs(BuildContext context) async {
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context);
    late String? profilePicture;
    late String? name;
    try {
      QuerySnapshot<DogData> querySnapshot = await dogCollection.withConverter(
        fromFirestore: DogData.fromFirestore,
        toFirestore: (DogData dog, _) => dog.toFirestore(),
      ).get();
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
                      child: Image.network(
                        profilePicture!,
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

  Future getAllShelterDogs(BuildContext context) async {
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context);
    late String? profilePicture;
    late String? name;
    try {
      QuerySnapshot<DogData> querySnapshot = await dogCollection.where("shelterId", isEqualTo: uid).withConverter(
        fromFirestore: DogData.fromFirestore,
        toFirestore: (DogData dog, _) => dog.toFirestore(),
      ).get();
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
                    child: Image.network(
                      profilePicture!,
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

  Future getMaleDogs(BuildContext context) async{
    List<Card> dogCards = [];
    final ThemeData theme = Theme.of(context);
    late String? profilePicture;
    late String? name;
    QuerySnapshot<DogData> querySnapshot = await dogCollection.where("sex", isEqualTo: "male").withConverter(
      fromFirestore: DogData.fromFirestore,
      toFirestore: (DogData dog, _) => dog.toFirestore(),
    ).get();
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
                    child: Image.network(
                      profilePicture!,
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
      ).get();
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
                    child: Image.network(
                      profilePicture!,
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
    ).get();
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
                    child: Image.network(
                      profilePicture!,
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
      ).get();
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
                    child: Image.network(
                      profilePicture!,
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
    });
    for(var dogId in favouriteDogs!){
        await gettingDogData(dogId).then((value) {
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
                    child: Image.network(
                      profilePicture!,
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
                    DeepRoute.toNamed(InfoDog.routeName, arguments: dogData.dogId);
                  },
                  child: Text(name!), //el texto es el getter del nombre del perro
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
    await gettingDogData(dogId).then((value) async {
      dogData = value;
      profilePicture = dogData?.profilePicture;
      try {
        final dogRef = dogCollection.doc(dogId);
        dogRef.delete();
      } catch (error) {
          return Future.error(error);
      }
    });
    final Reference storageReference = FirebaseStorage.instance.refFromURL(profilePicture!);
    try {
      storageReference.delete();
    } catch (e) {
        print(e);
    }
  }
  Future<void> addDogFavourite(String dogId) async{
    userCollection.doc(uid).update({
      'favourites': FieldValue.arrayUnion([dogId])
    });
  }

  Future<void> removeDogFavourite(String dogId) async{
    userCollection.doc(uid).update({
      'favourites': FieldValue.arrayRemove([dogId])
    });
  }

}