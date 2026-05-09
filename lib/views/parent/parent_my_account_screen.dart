import 'package:flutter/material.dart';

class ParentMyAccountScreen extends StatefulWidget{
  const ParentMyAccountScreen({super.key});

  @override
  State<ParentMyAccountScreen> createState() => _ParentMyAccountScreenState();
}

class _ParentMyAccountScreenState extends State<ParentMyAccountScreen> {

  @override
  Widget build(context) {
    return Center(
      child: Text('My account'),
    );
  }
}