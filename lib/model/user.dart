import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String name;
  String uid;
  String image;
  String email;


  User({
   required this.name,
    required this.uid,
    required this.image,
    required this.email,

});
  Map<String,dynamic> toJson()=>
      {
        "name":name,
        "uid":uid,
        "image":image,
        "email":email,

      };
  static User fromSnap(DocumentSnapshot snapshot){
    var dataSnapshot=snapshot.data() as Map<String, dynamic>;
    return User(
      name: dataSnapshot["name"],
      uid: dataSnapshot["uid"],
      image: dataSnapshot["image"],
      email: dataSnapshot["email"],

    );


  }
}

