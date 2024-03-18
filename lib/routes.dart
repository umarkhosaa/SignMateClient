import 'package:flutter/material.dart';
import 'package:signmate/screens/Authentication/Sign_In/login_Screen.dart';
import 'package:signmate/screens/Authentication/Sign_Up/signUp_screen.dart';
import 'screens/main_screen.dart';


final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  SignUpScreen.routeName: (context) =>const SignUpScreen(),
  MainScreen.routeName: (context) =>const  MainScreen(),
  // SignInPhone.routeName: (context) =>  SignInPhone(),
  // ForYouVideoScreen.routeName: (context) =>  ForYouVideoScreen(),
  // FollowingVideoScreen.routeName: (context) =>  FollowingVideoScreen(),
  // UploadVideoScreen.routeName: (context) =>  UploadVideoScreen(),
  // ProfileScreen.routeName: (context) =>  ProfileScreen(),

};
