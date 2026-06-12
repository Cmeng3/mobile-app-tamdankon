import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_students_screen/student_info_tile.dart';

class DriverStudentsDetailScreen extends StatefulWidget {
  const DriverStudentsDetailScreen({
    super.key,
    required this.studentName,
    required this.studentId,
    required this.gender,
    required this.parentName,
    required this.phoneNumber,
    required this.isLocationSet,
    required this.locationSettings,
    required this.onUpdateLocation,
    required this.onGetLatestStudent,
  });

  final String studentName;
  final int studentId;
  final String gender;
  final String parentName;
  final String phoneNumber;
  final bool isLocationSet;
  final LocationSettings locationSettings;
  final void Function(int studentId, String latlng) onUpdateLocation; 
  final void Function() onGetLatestStudent;

  @override
  State<DriverStudentsDetailScreen> createState() => _DriverStudentsDetailScreenState();
}

class _DriverStudentsDetailScreenState extends State<DriverStudentsDetailScreen> {
  //
  bool isLoading = true;
  //
  late Position busCurrentLocation;
  // loading the location
  void getCurrentLocation() async {
    busCurrentLocation = await Geolocator.getCurrentPosition(locationSettings: widget.locationSettings);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? const Center(child: CircularProgressIndicator(),) : Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      // Padding 1#: give a space for all element inside the Container 1#
      child: Padding(
        padding: const EdgeInsets.all(20),
        // Column 1#: layout all the student-information in form on student-tile
        child: Column(
          children: [
            // Container 2#: Drag Handle
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            // Show student Avatar: Student Avatar
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            // AppText 1#: show student name
            AppText(
              widget.studentName,
              color: Colors.black,
              fontSize: 22,
              fontWeight: true,
            ),
            const SizedBox(height: 24),
            // Expanded: let the ListView take up the full space
            // purpose: show student-info in form of studentInfoTile
            Expanded(
              child: ListView(
                children: [
                  StudentInfoTile(
                    icon: Icons.person_outline,
                    title: "Gender",
                    value: widget.gender == 'M' ? 'Male' : 'Female',
                  ),
                  StudentInfoTile(
                    icon: Icons.location_on_outlined,
                    title: "Pickup Location",
                    value: "Phnom Penh, Cambodia",
                    trailing: IconButton(
                      icon:  widget.isLocationSet ? Icon(Icons.edit, color: Colors.green) : Icon(Icons.edit, color: Colors.red),
                      onPressed: () {
                        // Edit location
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: AppText('Do you want to update ${widget.studentName} location?', color: Colors.black, fontSize: 18, fontWeight: true,),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText('Location: ${busCurrentLocation.latitude}, ${busCurrentLocation.longitude}', color: Colors.green, fontWeight: true,),
                                SizedBox(height: 10),
                                Image(image: AssetImage('assets/images/green_marker.png'), width: 30),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: AppText("close", color: const Color.fromARGB(255, 3, 3, 80)),
                              ),
                              TextButton(
                                onPressed: () async{
                                  widget.onUpdateLocation(widget.studentId, '${busCurrentLocation.latitude}, ${busCurrentLocation.longitude}');
                                  widget.onGetLatestStudent();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: AppText("Update", color:  const Color.fromARGB(255, 76, 175, 80),
                              ),
                            )
                            ],
                          );
                        });
                      },
                    ),
                  ),
                  StudentInfoTile(
                    icon: Icons.family_restroom,
                    title: "Parent",
                    value: widget.parentName,
                  ),

                  StudentInfoTile(
                    icon: Icons.phone,
                    title: "Phone Number",
                    value: widget.phoneNumber,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                label: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}