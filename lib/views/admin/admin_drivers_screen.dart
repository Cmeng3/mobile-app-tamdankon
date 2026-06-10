import 'package:flutter/material.dart';

class AdminDriversScreen extends StatefulWidget{
  const AdminDriversScreen({super.key});

  @override
  State<AdminDriversScreen> createState() => _AdminDriverScreenState();
}

class _AdminDriverScreenState extends State<AdminDriversScreen> {

  @override
  Widget build(context) {
    return const Center(child: Text('drivers screen'));
  }
}