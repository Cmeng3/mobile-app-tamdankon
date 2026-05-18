import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget{
  const UserAvatar({super.key});

  @override
  Widget build(context) {
    return ClipOval(
      child: Image(
        image: AssetImage('assets/images/user.png'),
        width: 120,
        height: 120,
      ),
    );
  }
}