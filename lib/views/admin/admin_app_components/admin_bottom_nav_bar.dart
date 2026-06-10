import 'package:flutter/material.dart';

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({
    super.key,
    required this.currentScreenIndex,
    required this.onAdminScreenChange,
  });

  final int currentScreenIndex;
  final void Function(int screenIndex) onAdminScreenChange;

  @override
  Widget build(context) {
    var bottomNavScreenIndex = 2;
    if(currentScreenIndex <= 4) {
      bottomNavScreenIndex = currentScreenIndex;
    }

    return NavigationBar(
      // trigger the parent to change screen
      onDestinationSelected: onAdminScreenChange,
      // specify the current Nav destination
      selectedIndex: bottomNavScreenIndex,
      // all parent-screens destinations
      destinations: const [
        NavigationDestination(
          icon:Icon(Icons.escalator_warning,), 
          label: 'parents',
        ),
        NavigationDestination(
          icon: Icon(Icons.people), 
          label: 'drivers',
        ),
        NavigationDestination(
          icon: Icon(Icons.search), 
          label: 'menu',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat), 
          label: 'chat',
        ),
        NavigationDestination(
          icon: Icon(Icons.list), 
          label: 'attendance',
        ),
      ]
    );
  }
}