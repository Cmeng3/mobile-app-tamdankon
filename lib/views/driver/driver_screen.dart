import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/style_app_bar.dart';
import 'package:tamdan_kon_mobile_flutter/models/driver_screen_model.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_screen_components/bus_unavailable_screen.dart';
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

  // trigger the driver-screen state to change
  void onDriverScreenStateChange() {
    // will implement this later
    setState(() {});
  }

  // get trigger parent-screen to show snackbar
  void getSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Center(child: AppText(message)),
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // driverScreenModel control driver-screen all its logic and data
  late DriverScreenModel driverScreenModel = DriverScreenModel(
    // we will implement essential parameter here
    triggerDriverSnackBar: getSnackBar,
    onUpdateDriverState: onDriverScreenStateChange,
    onRootScreenChange: widget.onRootScreenChange,
  );

  @override
  void initState() {
    super.initState();
    // start instantiat the driverScreenModel to set-up all essectial data
    driverScreenModel;
  }

  @override
  void dispose() {
    driverScreenModel.getBusAssociationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(context) {
    return driverScreenModel.isLoading
        ? Scaffold(body: const Center(child: CircularProgressIndicator()))
        : [
            Scaffold(
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
          ),
          BusUnavailableScreen(
            driverId: driverScreenModel.id!,
            onRootScreenChange: widget.onRootScreenChange,
            onTriggerParentSnackbar: getSnackBar,
            onUpdateDriverState: onDriverScreenStateChange,
          ),
        ][driverScreenModel.temScreenIndex];
  }
}
