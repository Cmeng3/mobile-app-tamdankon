import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/parent_bottom_navbar.dart';
import 'package:tamdan_kon_mobile_flutter/components/style_app_bar.dart';
import 'package:tamdan_kon_mobile_flutter/composable/get_screen_parse.dart';
import 'package:tamdan_kon_mobile_flutter/composable/logout_user.dart';
import 'package:tamdan_kon_mobile_flutter/models/parent_screen_model.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key, required this.onRootScreenChange});

  // onRootScreenChange method, design to take a root-app screen switcher's call-back function
  // that be able to trigger it root-app setState() to change to specific main-screen
  final void Function(String currentRootScreen) onRootScreenChange;

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  // get parent-screen model, which design to hold datas and logic of parent-screen
  late ParentScreenModel parentScreenModel = ParentScreenModel(onParentScreenChange: triggerParentState);
  // currentParentScreenIndex design to control parent-screens
  var currentParentScreenIndex = 0;
  // currentParentScreen store current parent screen widget
  late Widget currentParentScreen;
  // method for changing the parent-screen
  void changeParentAppScreen(int index) {
    setState(() {
      currentParentScreenIndex = index;
    });
  }

  bool isLoading = true;
  void triggerParentState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    // get the current parent-screen
    currentParentScreen = getParentScreenParse(currentParentScreenIndex);
    return Scaffold(
      // styleAppBar() is the current app style tool-bar
      appBar:
          isLoading
              ? StyleAppBar(username: 'username', role: 'role')
              : StyleAppBar(
                username: parentScreenModel.username!,
                role: parentScreenModel.role!,
              ),
      body: currentParentScreen,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          logoutUser(widget.onRootScreenChange, 'login_screen');
        },
        child: Icon(Icons.logout, color: Colors.white),
      ),
      // ParentBottomNavbar() is current style parent bottom nav-bar
      bottomNavigationBar: ParentBottomNavbar(
        onParentScreenChange: changeParentAppScreen,
        currentScreen: currentParentScreenIndex,
      ),
    );
  }
}
