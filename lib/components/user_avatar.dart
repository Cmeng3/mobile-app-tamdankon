import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget{
  const UserAvatar({
    super.key, 
    this.width = 120,
    this.height = 120
  });

  final double width;
  final double height;

  @override
  Widget build(context) {
    return ClipOval(
      child: Image(
        image: AssetImage('assets/images/user.png'),
        width: width,
        height: height,
      ),
    );
  }
}