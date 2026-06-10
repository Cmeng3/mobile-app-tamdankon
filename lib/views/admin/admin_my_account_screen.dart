import 'package:flutter/material.dart';

class AdminMyAccountScreen extends StatefulWidget{
  const AdminMyAccountScreen({super.key});

  @override
  State<AdminMyAccountScreen> createState() => _AdminMyAccountScreenState();
}

class _AdminMyAccountScreenState extends State<AdminMyAccountScreen> {

  @override
  Widget build(context) {
    return const Center(child: Text('my account screen'));
  }
}