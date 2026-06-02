import 'package:flutter/material.dart';

class DriverBottomNavbar extends StatelessWidget{
  const DriverBottomNavbar({
    super.key, 
    required this.onDriverScreenChange,
    required this.currentScreen
  });
  // trigger the parent-screen to change to the destination screen
  final Function(int index) onDriverScreenChange;
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
            onDestinationSelected: onDriverScreenChange,
            // specify the current Nav destination
            selectedIndex: currentScreen,
            // all parent-screens destinations
            destinations: const [
              NavigationDestination(
                icon:Icon(Icons.pin_drop,), 
                label: 'route',
              ),
              NavigationDestination(
                icon: Icon(Icons.escalator_warning), 
                label: 'students',
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