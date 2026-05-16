import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/parent_bottom_navbar.dart';
import 'package:tamdan_kon_mobile_flutter/components/style_app_bar.dart';
import 'package:tamdan_kon_mobile_flutter/composable/logout_user.dart';
import 'package:tamdan_kon_mobile_flutter/models/user_model.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key, required this.onRootScreenChange});

  // onRootScreenChange method, design to take a root-app screen switcher's call-back function
  // that be able to trigger it root-app setState() to change to specific main-screen
  final void Function(String currentRootScreen) onRootScreenChange;

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  // currentParentScreenIndex design to control parent-screens
  var currentParentScreenIndex = 0;
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

  // _screens store the list of parent screens
  // purpose: to use in IndexedStack, which pre-render all the screen during execution of IndexedSstack()
  late final List<Widget> parentScreens;
  // get parent-screen model, which design to hold datas and logic of parent-screen
  late UserModel parentScreenModel = UserModel(
    onParentScreenChange: triggerParentState,
  );

  @override
  void initState() {
    super.initState();
    // expicit calling parentScreenModel to instanciate it
    // becuase property mark as late, won't initialize until first use of it
    // even though we initial it during it first place
    parentScreenModel;
  }

  @override
  Widget build(context) {
    return isLoading
        ? Scaffold(body: const Center(child: CircularProgressIndicator()))
        : Scaffold(
          // styleAppBar() is the current app style tool-bar
          appBar: StyleAppBar(
            username: parentScreenModel.username!,
            role: parentScreenModel.role!,
          ),
          // pre-render all screensstore in _screens
          body: IndexedStack(
            index: currentParentScreenIndex,
            children: parentScreenModel.parentScreens!,
          ),
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
