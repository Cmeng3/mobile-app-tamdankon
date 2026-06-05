import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class RouteDialog extends StatelessWidget {
  RouteDialog({
    super.key,
    this.tapFrom,
    required this.status,
    required this.studentName,

    // property need for get and update polyline
    required this.getTriggerSnackbar,
    required this.busStatus,
    required this.studentLocation,
    required this.busLocation,
    required this.direction,
    required this.busId,
    required this.getAndUpdateBusPolyline,
  });

  String? tapFrom;
  final String status;
  final String studentName;

  // property need for get and update polyline
  final void Function(String error, Color color) getTriggerSnackbar;
  final String busStatus;
  final List<double> studentLocation;
  final String direction;
  final int busId;
  final Position busLocation;
  final Future<bool> Function({
    required List<double> studentLocation,
    required Position busLocation,
    required int busId,
    required String direction,
  })
  getAndUpdateBusPolyline;
  @override
  Widget build(context) {
    return AlertDialog(
      title:
          status == 'present'
              ? AppText(
                "Student already pick up!",
                color: Colors.green,
                fontWeight: true,
                fontSize: 18,
              )
              : (status == 'pending'
                  ? AppText(
                    'Student won\'t attend school',
                    fontWeight: true,
                    color: Colors.orange,
                    fontSize: 18,
                  )
                  : AppText(
                    "Get the direction to $studentName home?",
                    fontWeight: true,
                    color: const Color.fromARGB(255, 3, 3, 80),
                    fontSize: 18,
                  )),
      content: Image(image: AssetImage('assets/images/student.png'), width: 40),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: AppText("close", color: const Color.fromARGB(255, 3, 3, 80)),
        ),
        const SizedBox(width: 10),
        if (status == 'absent')
          TextButton(
            onPressed: () {
              // here is where we must write the logic
              // first get the polyline from google api
              // second update polyline to the database
              if(busStatus != 'none') {
                getAndUpdateBusPolyline(
                  busId: busId,
                  studentLocation: studentLocation,
                  busLocation: busLocation,
                  direction: direction,
                );
              } else {
                getTriggerSnackbar('please start route first!', Colors.orange);
              }
              
              if (tapFrom == 'studentTile') {
                Navigator.pop(context);
              }
              Navigator.pop(context);
            },
            child: AppText("Get Direction!", color: Colors.green),
          ),
      ],
    );
  }
}
