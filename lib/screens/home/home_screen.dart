import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null, // Remove the default title
        flexibleSpace: Container(
          padding: const EdgeInsets.only(top: 20.0), // Adjust the top padding as needed
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
              'assets/images/Audiozic logo.png', // Replace with the path to your logo
              height: 35, // Adjust the height as needed
              fit: BoxFit.contain, // Preserve aspect ratio without stretching
            ),
          ),
        ),
        elevation: 3, // Adjust the elevation as needed
        shadowColor: Colors.black, // Set shadow color
      ),


      body: Stack(
        children: [
          // Image Container
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/figure.png'), // Replace with your image
                fit: BoxFit.cover,
              ),
            ),
            margin: const EdgeInsets.only(bottom: 55),
            child: const Center(
              child: Text(
                '', // Replace with video content logic
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),

          // Text Bar
          Positioned(
            bottom: 5,
            left: 10,
            right: 8,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Type to translate',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    size: 30,
                  ),
                  onPressed: () {
                    // Implement voice note functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'Account',
      //     ),
      //   ],
      //   selectedItemColor: Colors.pinkAccent,
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: 0,
      //   onTap: (index) {
      //     // Handle navigation item taps
      //     // You can implement navigation logic here
      //   },
      //   backgroundColor: Colors.white,
      // ),
    );
  }
}