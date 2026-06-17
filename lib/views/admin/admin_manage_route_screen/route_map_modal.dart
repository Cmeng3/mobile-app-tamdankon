import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class RouteMapModal extends StatefulWidget {
  const RouteMapModal({
    super.key,
    required this.busList,
    required this.driverName,
    required this.busId,
    required this.onGetStudentsOnBus,
    required this.onAssignStudentNewBus,
  });

  // get all buses list
  final List<Map<String, dynamic>> busList;
  //
  final String driverName;
  //
  final int busId;
  //
  final Future<List<Map<String, dynamic>>> Function(int busId) onGetStudentsOnBus;
  //
  final Future<void> Function(int studentId, int busId) onAssignStudentNewBus;

  @override
  State<RouteMapModal> createState() => _RouteMapModalState();
}

class _RouteMapModalState extends State<RouteMapModal> {
  List<Map<String, dynamic>> students = [];
  Set<Marker> studentsLocation = {};
  late BitmapDescriptor studentMarkerIcon;
  //
  bool isLoading = true;
  //
  void getAllStudentsOnBus() async {
    students = await widget.onGetStudentsOnBus(widget.busId);
    studentMarkerIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(50, 50)),
      'assets/images/student.png',
    );
    studentsLocation = Set<Marker>.from(
      students.map(
        (student) => Marker(
          markerId: MarkerId(student['id'].toString()),
          infoWindow: InfoWindow(
            title: student['name'],
            snippet: 'parent: ${student['parent']}',
          ),
          icon: studentMarkerIcon,
          position: LatLng(student['latitude'], student['longitude']),
        ),
      ),
    );
    isLoading = false;
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    getAllStudentsOnBus();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
          height: MediaQuery.of(context).size.height * .90,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Bus Route Map",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              /// Map Area
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(11.586632, 104.845322),
                      zoom: 12,
                    ),
                    markers: studentsLocation,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Route Information
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.directions_bus, color: Colors.blue),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Bus ${widget.busId} - Driver ${widget.driverName}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Expanded(
                        child:
                            students.isEmpty
                                ? const Center(
                                  child: AppText(
                                    'No Students',
                                    color: Color.fromARGB(100, 0, 0, 0),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: students.length,
                                  itemBuilder: (context, index) {
                                    final student = students[index];

                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          child: Text(student["name"]![0]),
                                        ),
                                        title: Text(student["name"]!),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(student["sex"]!),
                                            Text(
                                              "Parent: ${student["parent"]}",
                                            ),
                                          ],
                                        ),
                                        trailing: PopupMenuButton<int>(
                                          onSelected: (value) async{
                                            isLoading = true;
                                            setState(() {});

                                            await widget.onAssignStudentNewBus(student['id'], value);
                                            students = await widget.onGetStudentsOnBus(widget.busId);

                                            studentsLocation = Set<Marker>.from(
                                            students.map(
                                              (student) => Marker(
                                                markerId: MarkerId(student['id'].toString()),
                                                infoWindow: InfoWindow(
                                                  title: student['name'],
                                                  snippet: 'parent: ${student['parent']}',
                                                ),
                                                icon: studentMarkerIcon,
                                                position: LatLng(student['latitude'], student['longitude']),
                                              ),
                                            ),
                                            );
                                            isLoading = false;
                                            setState(() {});
                                          },
                                          itemBuilder:
                                              (context) => [
                                                ...widget.busList.map(
                                                  (bus) => PopupMenuItem(
                                                    value: bus['id'],
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.directions_bus,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Bus ${bus['id']}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
