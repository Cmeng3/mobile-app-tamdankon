import 'package:flutter/material.dart';

class AdminChatScreen extends StatefulWidget{
  const AdminChatScreen({super.key});

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {

  @override
  Widget build(context) {
    return const Center(child: Text('chat screen'));
  }
}