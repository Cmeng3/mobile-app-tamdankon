import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor = Colors.black,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color valueColor;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(25, 33, 150, 243),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),

                const SizedBox(height: 2),

                AppText(
                  value,
                  color: valueColor,
                  fontWeight: true,
                  fontSize: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}