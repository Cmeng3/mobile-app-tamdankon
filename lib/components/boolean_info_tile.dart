import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class BooleanInfoTile extends StatelessWidget {
  const BooleanInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.status = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool status;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  status
                      ? const Color.fromARGB(25, 76, 175, 80)
                      : const Color.fromARGB(35, 158, 72, 66),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: status ? Colors.green : Colors.red,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, color: Colors.grey.shade600, fontSize: 13),

                const SizedBox(height: 2),

                AppText(
                  value,
                  color: status ? Colors.green : Colors.red ,
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
