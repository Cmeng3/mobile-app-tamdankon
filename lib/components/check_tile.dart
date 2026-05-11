import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class CheckTile extends StatelessWidget{
  const CheckTile({
    super.key,
    required this.label,
    required this.status,
  });
  // label indicate what we checking about
  final String label;
  // status indicate what status should be name

  final String status;
  @override
  Widget build(context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // attendance status icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(25, 76, 175, 80),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                AppText(
                  label,
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),

                const SizedBox(height: 4),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(35, 76, 175, 80),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AppText(
                    status,
                    color: Colors.green,
                    fontWeight: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}