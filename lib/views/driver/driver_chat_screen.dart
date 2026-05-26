import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class DriverChatScreen extends StatefulWidget{
  const DriverChatScreen({super.key});

  @override
  State<DriverChatScreen> createState() => _DriverChatScreenState();
}

class _DriverChatScreenState extends State<DriverChatScreen> {

  @override
  Widget build(context) {
    return Center(
      child: AppText('chat screen', color: Colors.black),
    );
  }
}