import 'package:flutter/material.dart';

class ParentBottomNavbar extends StatelessWidget{
  const ParentBottomNavbar({
    super.key, 
    required this.onParentScreenChange,
    required this.currentScreen
  });
  // trigger the parent-screen to change to the destination screen
  final Function(int index) onParentScreenChange;
  // current parent-screen index
  final int currentScreen;
  @override
  Widget build(context) {
    return Container(
      // making space around bottom navbar
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      decoration: BoxDecoration(

      ),
      // make bottom navbar rounded
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: NavigationBar(
            // trigger the parent to change screen
            onDestinationSelected: onParentScreenChange,
            // specify the current Nav destination
            selectedIndex: currentScreen,
            // all parent-screens destinations
            destinations: const [
              NavigationDestination(
                icon:Icon(Icons.map,), 
                label: 'Map',
              ),
              NavigationDestination(
                icon: Icon(Icons.list), 
                label: 'attendance',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat), 
                label: 'chat box',
              ),
              NavigationDestination(
                icon: Icon(Icons.person), 
                label: 'my account',
              ),
            ]
          ),
      ),
    );
  }
}