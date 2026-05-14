import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class BooleanBadge extends StatelessWidget {
    const BooleanBadge(this.text, {
    super.key,
    this.isTrue = false,
  });
  //
  final bool isTrue;
  final String text;
  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isTrue
            ? Colors.green.shade50
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(30),
      ),
      child: AppText(
        text,
        color: isTrue
            ? Colors.green
            : Colors.red,
        fontSize: 12,
        fontWeight: true,
      ),
    );
  }
}