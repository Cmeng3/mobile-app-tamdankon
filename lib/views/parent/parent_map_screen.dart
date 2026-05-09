import 'package:flutter/material.dart';

class ParentMapScreen extends StatefulWidget{
  const ParentMapScreen({super.key});

  @override
  State<ParentMapScreen> createState() => _ParentMapScreenState();
}

class _ParentMapScreenState extends State<ParentMapScreen> {
  var value = 1;
  @override
  Widget build(context) {
    return Center(
      child: Column(children: [
        Text('map screen: $value'),
        OutlinedButton(onPressed: () {
          setState((){
            value++;
          });
        }, child: Text('press here'))
      ],),
    );
  }
}