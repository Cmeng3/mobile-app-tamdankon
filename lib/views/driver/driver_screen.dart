import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/style_app_bar.dart';
import 'package:tamdan_kon_mobile_flutter/composable/logout_user.dart';
import 'package:tamdan_kon_mobile_flutter/models/driver_screen_model.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_screen_components/driver_bottom_nav_bar.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key, required this.onRootScreenChange});

  // onRootScreenChange method, design to take a root-app screen switcher's call-back function
  // that be able to trigger it root-app setState() to change to specific main-screen
  final void Function(String currentRootScreen) onRootScreenChange;

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  // control the current children-screen
  int currentScreen = 0;
  // trigger driver-screen to navigate to their children-screen
  void onDriverScreenChange(int screenIndex) {
    setState(() {
      currentScreen = screenIndex;
    });
  }

  //
  void onDriverScreenStateChange() {
    // will implement this later
    setState(() {});
  }

  // driverScreenModel control driver-screen all its logic and data
  late DriverScreenModel driverScreenModel = DriverScreenModel(
    // we will implement essential parameter here
    onUpdateDriverState: onDriverScreenStateChange,
  );

  @override
  void initState() {
    super.initState();
    // start instantiat the driverScreenModel to set-up all essectial data
    driverScreenModel;
  }

  @override
  Widget build(context) {
    return driverScreenModel.isLoading
        ? Scaffold(body: const Center(child: CircularProgressIndicator()))
        : Scaffold(
          appBar: StyleAppBar(
            username: driverScreenModel.username!,
            role: driverScreenModel.role!,
          ),
          body: IndexedStack(
            // all List<driver_screens>
            index: currentScreen,
            children: driverScreenModel.driverScreens,
          ),
          bottomNavigationBar: DriverBottomNavbar(
            onDriverScreenChange: onDriverScreenChange,
            currentScreen: currentScreen,
          ),
          floatingActionButton: IconButton(
            onPressed: () {
              logoutUser(widget.onRootScreenChange);
            },
            style: IconButton.styleFrom(backgroundColor: Colors.red),
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        );
  }
}
