import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_route_screen/route_dialog.dart';

class StudentStatusTile extends StatelessWidget {
  const StudentStatusTile({
    super.key,
    required this.name,
    required this.status,

    //
    required this.getTriggerSnackbar,
    required this.busStatus,
    required this.studentLocation,
    required this.busLocation,
    required this.studentId,
    required this.busId,
    required this.getAndUpdateBusPolyline,
  });

  final String name;
  final String status;

  //
  final void Function(String error, Color color) getTriggerSnackbar;
  final String busStatus;
  final List<double> studentLocation;
  final Position busLocation;
  final int studentId;
  final int busId;
  final Future<bool> Function({
    required List<double> studentLocation,
    required Position busLocation,
    required int busId,
    required String direction,
  })
  getAndUpdateBusPolyline;

  @override
  Widget build(context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return RouteDialog(
              tapFrom: 'studentTile',
              status: status,
              studentName: name,
              getTriggerSnackbar: getTriggerSnackbar,
              busStatus: busStatus,
              studentLocation: studentLocation,
              busLocation: busLocation,
              direction: studentId.toString(),
              busId: busId,
              getAndUpdateBusPolyline: getAndUpdateBusPolyline,
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  status == 'present'
                      ? const Color.fromARGB(38, 76, 175, 80)
                      : (status == 'absent'
                          ? const Color.fromARGB(38, 244, 67, 54)
                          : const Color.fromARGB(38, 255, 152, 0)),
              child: Icon(
                Icons.person,
                color:
                    status == 'present'
                        ? const Color.fromARGB(255, 76, 175, 80)
                        : (status == 'absent'
                            ? const Color.fromARGB(255, 244, 67, 54)
                            : const Color.fromARGB(255, 255, 152, 0)),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: AppText(
                name,
                color: Colors.black,
                fontSize: 16,
                fontWeight: true,
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    status == 'present'
                        ? const Color.fromARGB(38, 76, 175, 80)
                        : (status == 'absent'
                            ? const Color.fromARGB(38, 244, 67, 54)
                            : const Color.fromARGB(38, 255, 152, 0)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: AppText(
                status == 'pending' ? 'won\'t attend' : status,
                color:
                    status == 'present'
                        ? const Color.fromARGB(255, 76, 175, 80)
                        : (status == 'absent'
                            ? const Color.fromARGB(255, 244, 67, 54)
                            : const Color.fromARGB(255, 255, 152, 0)),
                fontSize: 12,
                fontWeight: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
