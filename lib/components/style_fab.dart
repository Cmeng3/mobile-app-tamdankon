import 'package:flutter/material.dart';

class StyleFab extends StatelessWidget{
  const StyleFab({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: FloatingActionButton(
        heroTag: icon.toString(),
        backgroundColor: backgroundColor,
        elevation: 0,
        onPressed: onTap,
        child: Icon(
          icon,
          color: iconColor,
          size: 28,
        ),
      ),
    );
  }
}