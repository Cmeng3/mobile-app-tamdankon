import 'package:flutter/material.dart';

// AppText is designed for general use of overall app text
// It has predifine color, side, and font-weight
class AppText extends StatelessWidget {
  const AppText(
    this.data,
    {
      super.key,
      this.fontSize = 14,
      this.fontWeight = false
    }
  );

  final String data;
  final double fontSize;
  final bool fontWeight;
  
  @override
  Widget build(context) {
    return Text(
      data,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight? FontWeight.bold : null,
      )
    );
  }
}