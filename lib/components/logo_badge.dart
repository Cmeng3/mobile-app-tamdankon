import 'package:flutter/material.dart';

class LogoBadge extends StatelessWidget {
  const LogoBadge({
    super.key,
    required this.color,
    required this.shadeColor,
    required this.icon,
  });
  final Color color;
  final Color shadeColor;
  final IconData icon;
  
  @override
  Widget build(context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: shadeColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}