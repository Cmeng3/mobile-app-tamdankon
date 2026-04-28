import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onRootScreenChange});

  // onRootScreenChange method, design to take a root-app screen switcher's call-back function
  // that be able to trigger it root-app setState() to change to specific main-screen
  final void Function(String currentRootScreen) onRootScreenChange;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // isLoading is a splash-screen property,
  // design for managing the indicating of the process during data-fetching
  bool isLoading = true;
  // Down below propertys, are what need to store the retrieve credential from local storage
  String? username;
  String? userToken;
  String? userRole;

  void checkingUserExisting() async {
    // prefs is the instance of SharedPreferncecs,
    // use for CRUD operation on local storage
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // store the retrieval user's data
    username = prefs.getString('username');
    userToken = prefs.getString('user_token');
    userRole = prefs.getString('user_role');
    // wait 0.5s in the memory before executing the setState()
    // and change the isLoading value, when fetching process is end
    // we add up 0.5s more, to make user recognize fetching is processing
    // because actaully fetching is really fast to recognize
    Timer(Duration(milliseconds: 500), (){
      setState(() {
          isLoading = false;
      });
    });
    // wait 2s in memory before changing to appropriate screen
    Timer(Duration(seconds: 2), () {
      if (userToken == null) {
        widget.onRootScreenChange('login_screen');
      } else if (userRole == 'parent') {
        widget.onRootScreenChange('parent_screen');
      } else if (userRole == 'driver') {
        widget.onRootScreenChange('drive_screen');
      } else {
        widget.onRootScreenChange('admin_screen');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // invoke the function to perform user checking
    checkingUserExisting();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // This 2 colors linear gradient mixed, is the app-background primary color
            colors: [
              const Color.fromARGB(255, 31, 14, 215),
              const Color.fromARGB(255, 3, 3, 80),
            ],
            // mixed color up-screen until down-screen
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ClipOval widget is use for cut the Image widget or other widget edge in to circle shape
              ClipOval(
                child: Image(
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  // fetch logo image from assets/ folder
                  image: AssetImage('assets/images/tamdan_kon_logo.jpg'),
                ),
              ),
              // Adjust some height between Logo image and Welcome text
              const SizedBox(height: 20),
              // application welcome (will change to googlefont later)
              const Text(
                'Tamdan-Kon',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Adjust some height between Logo image and Welcome text
              const SizedBox(height: 10),
              isLoading
                  ? const CircularProgressIndicator()
                  : Text( // welcome user (will change to googlefont later) 
                    'Welcome ${username ?? 'User'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
