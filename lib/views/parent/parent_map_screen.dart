import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/check_tile.dart';
import 'package:tamdan_kon_mobile_flutter/components/info_tile.dart';

class ParentMapScreen extends StatefulWidget{
  const ParentMapScreen({
    super.key, 
    required this.googleMap
  });
  // property that take the GoogleMap widget
  final GoogleMap googleMap;
  @override
  State<ParentMapScreen> createState() => _ParentMapScreenState();
}

class _ParentMapScreenState extends State<ParentMapScreen>{
  @override
  Widget build(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Container 1#: display the GoogleMap widget
            Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 4,
                color: const Color.fromARGB(25, 0, 0, 0),
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            margin: EdgeInsets.all(3),
            height: 350,
            child: widget.googleMap
          ),
          
          // Container #2 is the student-information's card section
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 8,
            ),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: const Color.fromARGB(25, 0, 0, 0),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: Colors.blue,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    AppText(
                      'Student Information',
                      color: Colors.black,
                      fontWeight: true,
                      fontSize: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // the student information
                InfoTile(
                  icon: Icons.person,
                  title: 'Student',
                  value: 'Kunnarak',
                ),
                InfoTile(
                  icon: Icons.badge,
                  title: 'Student ID',
                  value: '1',
                ),
                InfoTile(
                  icon: Icons.wc,
                  title: 'Sex',
                  value: 'Male',
                ),
                // Attendance check-tile
                CheckTile(label: 'Attendance', status: 'Present'),
                InfoTile(
                  icon: Icons.drive_eta,
                  title: 'Driver',
                  value: 'Sombat Thy',
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}