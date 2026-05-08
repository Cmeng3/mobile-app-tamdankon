import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/parent_bottom_navbar.dart';
import 'package:tamdan_kon_mobile_flutter/components/style_app_bar.dart';
import 'package:tamdan_kon_mobile_flutter/composable/logout_user.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({
    super.key, 
    required this.onRootScreenChange
  });

  // onRootScreenChange method, design to take a root-app screen switcher's call-back function
  // that be able to trigger it root-app setState() to change to specific main-screen
  final void Function(String currentRootScreen) onRootScreenChange;

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  // currentScreen design to control parent-app screens
  var currentScreen = 0;
  // method for changing the parent-app screen
  void changeParentAppScreen(int index) {
    setState(() {
      currentScreen = index;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      // styleAppBar() is the current app style tool-bar 
      appBar: StyleAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          logoutUser(widget.onRootScreenChange, 'login_screen');
        },
        child:Icon(Icons.logout, color:Colors.white),
      ),
      // ParentBottomNavbar() is current style parent bottom nav-bar
      bottomNavigationBar: ParentBottomNavbar(
        onParentScreenChange: changeParentAppScreen, 
        currentScreen: currentScreen,
      ),
    );
  }
}