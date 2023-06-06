import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PuppyMatch/model/userData.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Future registerUserData(String fullname, String email) async{
    await FirebaseStorage.instance.ref("icono_perfil.png").getDownloadURL().then((value) async {
      return await userCollection.doc(uid).set({
        'uid': uid,
        'name': fullname,
        'email': email,
        'description': "",
        'profilePicture': value,
        'gallery': [],
        'favourites': [],
        'isShelter': false
      });
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
    gettingUserData(userId).then((value){
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
      if(profilePicture != ""){
        final Reference storageReference = FirebaseStorage.instance.refFromURL(profilePicture!);
        try{
          storageReference.delete();
        }catch (e){
          print(e);
        }
      }
    });



  }
}