import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Future saveUserData(String fullname, String email) async{
    return await userCollection.doc(uid).set({
      'uid': uid,
      'name': fullname,
      'email': email,
      'description': "",
      'profilePicture': "",
      'gallery': [],
      'favourites': []
    });

  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where("email",isEqualTo: email).get();
    return snapshot;
  }

}