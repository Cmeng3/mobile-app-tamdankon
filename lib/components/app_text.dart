import 'package:flutter/material.dart';

// AppText is designed for general use of overall app text
// It has predifine color, side, and font-weight
class AppText extends StatelessWidget {
  const AppText(
    this.data,
    {
      super.key,
      this.fontSize = 14,
      this.fontWeight = false,
      this.color = Colors.white
    }
  );

  final String data;
  final double fontSize;
  final bool fontWeight;
  final Color color;
  
  @override
  Widget build(context) {
    return Text(
      data,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight? FontWeight.bold : null,
      )
    );
  }
}