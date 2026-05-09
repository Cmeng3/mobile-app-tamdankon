import 'package:flutter/material.dart';

class ParentAttendanceScreen extends StatefulWidget{
  const ParentAttendanceScreen({super.key});

  @override
  State<ParentAttendanceScreen> createState() => _ParentAttendanceScreenState();
}

class _ParentAttendanceScreenState extends State<ParentAttendanceScreen> {

  @override
  Widget build(context) {
    return Center(
      child: Text('Attendance screen'),
    );
  }
}