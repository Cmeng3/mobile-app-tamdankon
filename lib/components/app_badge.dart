import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class AppBadge extends StatelessWidget {
  const AppBadge(this.text, {
    super.key, 
    required this.color, 
    required this.shadeColor,
  });

  final Color color;
  final Color shadeColor;
  final String text;
  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: shadeColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: AppText(
        text,
        color: color,
        fontSize: 12,
        fontWeight: true,
      ),
    );
  }
}