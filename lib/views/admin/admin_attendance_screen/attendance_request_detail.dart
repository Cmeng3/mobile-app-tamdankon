import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class AttendanceRequestDetail extends StatelessWidget {
  const AttendanceRequestDetail({
    super.key, 
    required this.requestDetail
  });

  //
  final Map<String, dynamic> requestDetail;

  @override
  Widget build(context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// Drag Handle
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            const AppText(
              'Attendance Request',
              color: Colors.black,
              fontSize: 20,
              fontWeight: true,
            ),

            const SizedBox(height: 24),

            _buildInfoTile(
              icon: Icons.person,
              title: 'Parent Name',
              value: requestDetail['parent'],
            ),

            const SizedBox(height: 16),

            _buildInfoTile(
              icon: Icons.directions_bus,
              title: 'Bus Number',
              value: 'BUS-${requestDetail['bus_id']}',
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      AppText(
                        'Reason',
                        color: Colors.black,
                        fontWeight:true,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  AppText(
                    '${requestDetail['reason']}',
                    color: Colors.black,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
                /// Approve Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                ),
                label: const Text(
                  'Close',
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
  }
}

Widget _buildInfoTile({
  required IconData icon,
  required String title,
  required String value,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius:
          BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                fontSize: 12,
                color: Colors.grey,
              ),
              const SizedBox(height: 4),
              AppText(
                value,
                color: Colors.black,
                fontWeight: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}