import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/style_app_bar.dart';
import 'package:tamdan_kon_mobile_flutter/models/admin_screen_model.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_app_components/admin_bottom_nav_bar.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({
    super.key, 
    required this.onRootScreenChange
  });

  // onRootScreenChange method, design to take a root-app screen switcher's call-back function
  // that be able to trigger it root-app setState() to change to specific main-screen
  final void Function(String currentRootScreen) onRootScreenChange;

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int currentScreenIndex = 2;
  //
  void getScreenStateChange() {
    setState(() {});
  }
  // trigger to change admin screen through bottom-nav
  void changeAdminScreen(int screenIndex) {
    setState(() {
      currentScreenIndex = screenIndex;
    });
  }
  //
  void getSnackBar(String message, Color color) {
    final snackBar = SnackBar(
            backgroundColor: color,
            content: Center(child: AppText(message)),
          );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  // hold admin-screen logic and data
  late AdminScreenModel adminScreenModel = AdminScreenModel(
    onScreenStateChange:  getScreenStateChange,
    onTriggerSnackBar: getSnackBar,
    onGetCurrentScreen: changeAdminScreen,
    onRootScreenChange: widget.onRootScreenChange,
  );

  @override
  initState() {
    super.initState();
    adminScreenModel.getUserInfo();
  }

  @override
  Widget build(context) {
    return adminScreenModel.isLoading ? Scaffold(body: const Center(child: CircularProgressIndicator())) : Scaffold(
      appBar: StyleAppBar(username: '${adminScreenModel.username}', role: 'admin'),
      body: IndexedStack(
        index: currentScreenIndex,
        children: adminScreenModel.adminScreens,
      ),
      bottomNavigationBar: AdminBottomNavBar(
        currentScreenIndex: currentScreenIndex,
        onAdminScreenChange: changeAdminScreen,
      ),
    );
  }
}