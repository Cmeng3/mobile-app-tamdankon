import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class DriverStudentsScreen extends StatefulWidget{
  const DriverStudentsScreen({super.key});

  @override
  State<DriverStudentsScreen> createState() => _DriverStudentsScreenState();
}

class _DriverStudentsScreenState extends State<DriverStudentsScreen> {

  @override
  Widget build(context) {
    return Center(
      child: AppText('students screen', color: Colors.black),
    );
  }
}