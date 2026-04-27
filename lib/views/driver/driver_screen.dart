import 'package:flutter/material.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({
    super.key,
    required this.onRootScreenChange
  });

  // onRootScreenChange method, design to take a root-app screen switcher's call-back function
  // that be able to trigger it root-app setState() to change to specific main-screen
  final void Function(String currentRootScreen) onRootScreenChange;

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {

  @override
  Widget build(context) {
    return Scaffold(

    );
  }
}