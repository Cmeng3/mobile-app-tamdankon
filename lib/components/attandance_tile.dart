import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class AttandanceTile extends StatelessWidget {
  const AttandanceTile({super.key, required this.label, required this.status});
  // label indicate what we checking about
  final String label;
  // status indicate what status should be name

  final String status;
  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // container 1# is about attendance status icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  status == 'present'
                      ? const Color.fromARGB(25, 76, 175, 80)
                      : const Color.fromARGB(35, 158, 72, 66),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                status == 'present'
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                    : const Icon(Icons.close, color: Colors.red, size: 20),
          ),
          // give a spacing between icon and information
          const SizedBox(width: 12),
          // information part
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(label, color: Colors.grey.shade600, fontSize: 13),
                const SizedBox(height: 4),
                // container 2# is about the status part, which is styling in badge form
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        status == 'present'
                            ? const Color.fromARGB(35, 76, 175, 80)
                            : const Color.fromARGB(35, 158, 72, 66),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AppText(
                    status,
                    color: status == 'present' ? Colors.green : Colors.red,
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
