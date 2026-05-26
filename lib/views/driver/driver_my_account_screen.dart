import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class DriverMyAccountScreen extends StatefulWidget{
  const DriverMyAccountScreen({super.key});

  @override
  State<DriverMyAccountScreen> createState() => _DriverMyAccountScreenState();
}

class _DriverMyAccountScreenState extends State<DriverMyAccountScreen> {

  @override
  Widget build(context) {
    return Center(
      child: AppText('my account screen', color: Colors.black),
    );
  }
}