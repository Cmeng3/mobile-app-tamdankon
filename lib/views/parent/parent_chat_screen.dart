import 'package:flutter/material.dart';

class ParentChatScreen extends StatefulWidget{
  const ParentChatScreen({super.key});

  @override
  State<ParentChatScreen> createState() => _ParentChatScreenState();
}

class _ParentChatScreenState extends State<ParentChatScreen> {

  @override
  Widget build(context) {
    return Center(
      child: Text('Chat screen'),
    );
  }
}