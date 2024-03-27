import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:signmate/Components/default_button.dart';
import 'package:signmate/Controllers/authenticationController.dart';
import "package:signmate/model/user.dart" as UserModel;

import '../../Components/gradient_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel.User? currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthenticationController _authController = Get.find();
  final TextEditingController _nameController = TextEditingController();
  bool isLoading = true;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get();
      currentUser = UserModel.User.fromSnap(userDoc);
      _nameController.text = currentUser?.name ?? '';
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> updateUserData() async {
    String name = _nameController.text.trim();
    String imageUrl = currentUser?.image ?? '';

    if (_profileImage != null) {
      imageUrl = await uploadImageToStorage(_profileImage!);
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser?.uid).update({
        'name': name,
        'image': imageUrl,
      });

      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateDisplayName(name);
        if (_profileImage != null) {
          await _auth.currentUser!.updatePhotoURL(imageUrl);
        }
      }

      Fluttertoast.showToast(msg: "Profile Updated Successfully");
    } catch (e) {
      print("Error updating user profile: $e");
      Fluttertoast.showToast(msg: "Error updating profile");
    }
  }

  Future<String> uploadImageToStorage(File image) async {
    String userId = _auth.currentUser?.uid ?? 'unknown';
    Reference ref = FirebaseStorage.instance.ref().child('profile_images').child(userId);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> resetPassword() async {
    if (currentUser?.email != null) {
      try {
        await _auth.sendPasswordResetEmail(email: currentUser!.email);
        Fluttertoast.showToast(msg: "Password reset email sent. Check your inbox.");
      } catch (e) {
        print("Error sending password reset email: $e");
        Fluttertoast.showToast(msg: "Error sending password reset email");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
      appBar: AppBar(
        title: null,
        flexibleSpace: Container(
          padding: const EdgeInsets.only(top: 20.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 192, 203),
                Color.fromARGB(200, 255, 0, 0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/Audiozic logo.png',
              height: 35,
              fit: BoxFit.contain,
            ),
          ),
        ),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Stack(
              alignment: Alignment.center, // Align stack contents to center
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : (currentUser?.image != null
                      ? NetworkImage(currentUser!.image)
                      : AssetImage('assets/images/karaoke.png')) as ImageProvider,
                  backgroundColor: Colors.transparent,
                ),
                Positioned(
                  bottom: 0,
                  right: 110,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.orange),
                    onPressed: pickImageFromGallery,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: buildEditableField('Name', _nameController),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: ListTile(
                title: Text(currentUser?.email ?? 'Email'),
                leading: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            GradientButton(
              text: 'Update Profile',
              onPressed: updateUserData,
            ),
            GradientButton(
              text: 'Reset Password',
              onPressed: resetPassword,
            ),
            GradientButton(
              text: 'Sign Out',
              onPressed: _authController.signOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
