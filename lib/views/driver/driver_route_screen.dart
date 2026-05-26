import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class DriverRouteScreen extends StatefulWidget{
  const DriverRouteScreen({super.key});

  @override
  State<DriverRouteScreen> createState() => _DriverRouteScreenState();
}

class _DriverRouteScreenState extends State<DriverRouteScreen> {

  @override
  Widget build(context) {
    return Center(
      child: AppText('route screen', color: Colors.black),
    );
  }
}