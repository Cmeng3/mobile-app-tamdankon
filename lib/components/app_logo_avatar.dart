import 'package:flutter/material.dart';

// AppLogoAvatar is designed for framing the app logo in circular-look
class AppLogoAvatar extends StatelessWidget{
  const AppLogoAvatar({super.key});

  @override
  Widget build(context) {
    return ClipOval(
      child: Image(
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        image: AssetImage('assets/images/tamdan_kon_logo.jpg')
      ),
    );
  }
}