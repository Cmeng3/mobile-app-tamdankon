import 'package:flutter/material.dart';

class ParentAttendanceScreen extends StatefulWidget{
  const ParentAttendanceScreen({super.key});

  @override
  State<ParentAttendanceScreen> createState() => _ParentAttendanceScreenState();
}

class _ParentAttendanceScreenState extends State<ParentAttendanceScreen> {
  var index = 0;
  @override
  Widget build(context) {
    return Center(
      child: Column(children: [
        Text('$index'),
        OutlinedButton(onPressed: (){
          setState(() {
            index++;
          });
        }, child: Text('press here'))
      ],),
    );
  }
}