import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class StyleTitleTextLogo extends StatelessWidget {
  const StyleTitleTextLogo(this.text, {
    super.key,
    this.iconColor = Colors.blue,
    this.iconColorShade = const Color.fromARGB(25, 33, 150, 243),
    this.icon = Icons.edit_calendar_rounded,
  });

  final String text;
  final Color iconColor;
  final Color iconColorShade;
  final IconData icon;
  @override
  Widget build(context) {
    return Row(
      children: [
        // Row 1#: display the title Logo
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColorShade,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        AppText(
          text,
          color: Colors.black,
          fontSize: 22,
          fontWeight: true,
        ),
      ],
    );
  }
}