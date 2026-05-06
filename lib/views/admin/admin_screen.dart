import 'package:flutter/material.dart';

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

  @override
  Widget build(context) {
    return Scaffold(
      body: Text('admin'),
    );
  }
}