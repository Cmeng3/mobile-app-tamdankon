import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/parent_bottom_navbar.dart';
import 'package:tamdan_kon_mobile_flutter/components/style_app_bar.dart';
import 'package:tamdan_kon_mobile_flutter/composable/logout_user.dart';
import 'package:tamdan_kon_mobile_flutter/models/parent_screen_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/parent_attendance_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/parent_chat_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/parent_map_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/parent_my_account_screen.dart';

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
  final GoogleMap googleMap = GoogleMap(
    initialCameraPosition: CameraPosition
    (
      target: LatLng(11.587098, 104.844813),
      zoom: 18
    ),
    markers: {
      Marker(markerId: MarkerId('home'), position: LatLng(11.587098, 104.844813)),
  });
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
  late ParentScreenModel parentScreenModel = ParentScreenModel(onParentScreenChange: triggerParentState);

  @override
  void initState() {
    super.initState();
    // expicit calling parentScreenModel to instanciate it
    // becuase property mark as late, won't initialize until first use of it
    // even though we initial it during it first place
    parentScreenModel;
    // list of parent screen
    parentScreens = [
      ParentMapScreen(googleMap: googleMap),
      ParentAttendanceScreen(),
      ParentChatScreen(),
      ParentMyAccountScreen(),
    ];
  }

  @override
  Widget build(context) {
    return Scaffold(
      // styleAppBar() is the current app style tool-bar
      appBar:
          isLoading
              ? StyleAppBar(username: 'username', role: 'role')
              : StyleAppBar(
                username: parentScreenModel.username!,
                role: parentScreenModel.role!,
              ),
      // pre-render all screensstore in _screens
      body:  IndexedStack(
        index: currentParentScreenIndex,
        children: parentScreens,
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
