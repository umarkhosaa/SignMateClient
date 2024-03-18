import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart%20';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signmate/screens/home/home_screen.dart';
import 'package:signmate/screens/splash_screen.dart';
import '../screens/Authentication/Sign_In/login_Screen.dart';
import '../screens/Authentication/Sign_Up/signUp_screen.dart';
import '../screens/main_screen.dart';
import '../model/user.dart' as userModel;
class AuthenticationController extends GetxController {
  late Rx<User?> _currentUser;
  static AuthenticationController instanceAuth = Get.find();
   Rx<File?> _pickedFile = Rx<File?>(null); // Initialized with null
  File? get profileImage => _pickedFile.value;
  User get user =>_currentUser.value!;

  void chooseImageFromGallery() async {
    try {
      final pickedImageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImageFile != null) {
        print("Image Picked: ${pickedImageFile.path}"); // Debug print
        _pickedFile.value = File(pickedImageFile.path);
        update(); // Notify listeners
        Fluttertoast.showToast(msg: "Image selected successfully!");
      } else {
        print("No image selected"); // Debug print
        Fluttertoast.showToast(msg: "No image selected");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error selecting image: ${e.toString()}");
    }
  }

  // Method to reset the image
  void resetImage() {
    _pickedFile.value = null;
    update(); // Notify listeners
  }

  void captureImage() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImageFile != null) {
      print("Image Picked: ${pickedImageFile.path}"); // Debug print
      _pickedFile.value = File(pickedImageFile.path);
      update(); // Notify listeners
    } else {
      print("No image selected"); // Debug print
    }

  }
  Future<void> createAccountForNewUser(File imageFile, String userName,
      String userEmail, String userPassword) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      String imageUrl = await uploadedImagetoStorage(imageFile); // Modified

      userModel.User newUser = userModel.User(
        name: userName,
        uid: userCredential.user!.uid,
        image: imageUrl,
        email: userEmail,
      );
      try {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set(
            newUser.toJson());

      } catch (e) {
        print("Error writing to Firestore: $e");
        Fluttertoast.showToast(
            msg: "Failed to save user data to Firestore.",);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        Fluttertoast.showToast(msg: "Your Password is not Strong", );
      }
      if (e.code == "email-already-in-use") {
        Fluttertoast.showToast(
            msg: "There is already exists an account with the given email address",);
      }
      if (e.code == "invalid-email") {
        Fluttertoast.showToast(msg: "The email address is not valid.",);
      }
    }
    catch (e) {

    }
  }

  Future<String> uploadedImagetoStorage(File imageFile) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("Profile Image")
        .child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask uploadTask= reference.putFile(imageFile);
    TaskSnapshot taskSnapshot =await uploadTask;
    String downloadUrlOfImage=await taskSnapshot.ref.getDownloadURL();
    return downloadUrlOfImage;
  }
  void login(String userEmail,String userPassword)async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email:userEmail,password: userPassword);
      Get.snackbar("Login","You are successfully login");
    }
    catch(error){
      Get.snackbar("Login","Un successful");
      // Get.to(());
    }
  }

  void signOut() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if user is not null
    if (user != null) {
      // Determine the provider based on the list of user's provider data
      String? providerId = user.providerData[0].providerId;

      // Handle sign out based on the provider
      if (providerId == 'google.com') {
        // Sign out from Google
        await GoogleSignIn().signOut();
      } else if (providerId == 'facebook.com') {
        // Sign out from Facebook
        await FacebookAuth.instance.logOut();
      }

      // Finally, sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Update shared preferences to reflect logout
      // await Global.storageServices.logout(); // or your equivalent method to remove the login token or status

      // Optionally, you can also reset the first open flag if needed
      // await Global.storageServices.setBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME, false);
    }
  }

  gotoScreen(User? currentUser){
    if(currentUser==null){
      Get.offAll(SplashScreen());
    }
    else{
      Get.offAll(MainScreen());
    }
  }//method runs first when this method calls

  @override
  void onReady(){
    super.onReady();
    _currentUser= Rx<User?>(FirebaseAuth.instance.currentUser);
    _currentUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_currentUser, gotoScreen);
  }

}

class GoogleAuthentication {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; // User canceled the login process
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        await storeUserDataInFirestore(user, context);
      }
    } catch (error) {
      print(error.toString());
    }
  }
}

class FacebookAuthentication {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void loginWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status != LoginStatus.success) {
        Get.snackbar("Login", "Login with Facebook unsuccessful");
        return;
      }

      final AuthCredential facebookCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookCredential);
      User? user = userCredential.user;
      if (user != null) {
        await storeUserDataInFirestore(user, context);
      }
    } catch (error) {
      print(error.toString());
    }
  }
}

Future<void> storeUserDataInFirestore(User firebaseUser, BuildContext context) async {
  userModel.User newUser = userModel.User(
    name: firebaseUser.displayName ?? "",
    uid: firebaseUser.uid,
    image: firebaseUser.photoURL ?? "",
    email: firebaseUser.email ?? "",
  );

  try {
    await FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).set(newUser.toJson());
    Get.to(MainScreen());
    } catch (e) {print("Error writing to Firestore: $e");
  }
}