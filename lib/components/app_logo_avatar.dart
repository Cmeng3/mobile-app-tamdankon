import 'package:flutter/material.dart';

// AppLogoAvatar is designed for framing the app logo in circular-look
class AppLogoAvatar extends StatelessWidget{
  const AppLogoAvatar({
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
        width: width,
        height: height,
        fit: BoxFit.cover,
        image: AssetImage('assets/images/tamdan_kon_logo.jpg')
      ),
    );
  }
}