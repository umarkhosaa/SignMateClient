
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signmate/screens/help/help_screen.dart';
import 'package:signmate/screens/home/home_screen.dart';
import 'package:signmate/screens/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  static String routeName="/homeScreen";
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int screenIndex=0;
  List screenList=[
     HomeScreen(),
     HelpScreen(),
     ProfileScreen(),
    // FollowingVideoScreen(),
    // ProfileScreen(uid: authController.user.uid,),
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            screenIndex=index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        // selectedItemColor: Colors.black,
        // unselectedItemColor: Colors.black12,
        // currentIndex: screenIndex,
        selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          currentIndex: screenIndex,
        items:const [
          BottomNavigationBarItem(icon:Icon(Icons.home, size: 30,),label: 'Home'),
          BottomNavigationBarItem(icon:Icon(Icons.search, size: 30,),label: 'Help'),
          // BottomNavigationBarItem(icon:Icon(Icons.inbox_sharp, size: 30,),label: 'Following'),
          BottomNavigationBarItem(icon:Icon(Icons.person, size: 30,),label: 'Me'),
        ],

      ),
      body:screenList[screenIndex],
    );
  }
}
