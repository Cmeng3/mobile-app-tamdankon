import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tamdan_kon_mobile_flutter/composable/extract_coordinate.dart';
import 'package:tamdan_kon_mobile_flutter/services/location_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/student_info_service.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_route_screen/student_status_tile.dart';

class DriverRouteScreenModel {
  DriverRouteScreenModel({
    required this.driverId,
    required this.onScreenStateChange,
    required this.triggerSnackBar,
    this.busId,
  });

  // property use for querying
  final int driverId;
  int? busId;
  Timer? getStudentsInfoTimer;
  // instantiate the studentInfo service to get students info on that bus
  StudentInfoService studentInfoService = StudentInfoService();
  // instantiate the locationService service to bus status
  LocationService locationService = LocationService();


  // property use for display in driver-route-screen
  BitmapDescriptor greenMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor orangeMarker = BitmapDescriptor.defaultMarker;
  Set<Marker> studentMarkers = {};
  List<StudentStatusTile> studentsStatusTile = [];

  // property that control the state of drive-route-screen
  bool isLoading = true;
  // trigger the snackbar to show in whole driver-screen
  final void Function(String message, Color color) triggerSnackBar;
  // trigger driver state change
  final void Function() onScreenStateChange;
  // map controller
  late GoogleMapController googleMapController;

  // loading driver-route-screen essential infos
  void loadingScreenInfo() async {
    // start show progress indicator, during loading the data
    isLoading = true;
    // fetch the green_marker image from app-asset storage
    greenMarker = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(30, 40)),
      'assets/images/green_marker.png',
    );
    // fetch the orange_marker image from app-asset storage
    orangeMarker = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(50, 50)),
      'assets/images/orange_marker.png',
    );
    // start initialize fetching the student infomation from that specific bus, and show it in driver-route-screen
    await getAndExtractStudentsInfoOnBus();
    // start create data polling:
    // 1: polling the bus-status, and update the studentsList-info when bus-status is (1)
    getStudentsInfoTimer = Timer.periodic(const Duration(seconds: 4), getStreamOfStudentsInfo);
    // make screen display as normal, when data ready finish
    isLoading = false;
    onScreenStateChange();
  }
  // get StudentsInfo
  void getStreamOfStudentsInfo(Timer timer) async{
    if(await locationService.getBusStatus(busId!)) {
      //  get and extract the bus-status from response body
      // active (1) : the driver is ready to allow parent to see the bus on the map
      // inactive (0) : contrast from above statement
      Map<String, dynamic> statusData = locationService.getResponseParse();
      int busStatus = statusData['bus_status'] as int;
      // check for bus-active-status and then fetching then start checking all students on bus
      // purpose: get the students info on the bus, only when the bus operate
      if(busStatus == 1) {
        isLoading = true;
        // start fetching the students info on that bus
        await getAndExtractStudentsInfoOnBus();
        isLoading = false;
        onScreenStateChange();
      }
    } else {
      triggerSnackBar(locationService.error!, Colors.red);
    }
  }
  // fetching students from each specific bus
  Future<void> getAndExtractStudentsInfoOnBus() async{
    if (await studentInfoService.getStudentsInfoInBus(driverId)) {
      // get the list of students from the response
      Map<String, dynamic> res = studentInfoService.getResponseParse();
      List<Map<String, dynamic>> studentsList = List<Map<String, dynamic>>.from(
        res['data'],
      );
      // loading the students marker
      studentMarkers = {
        //maping the studentList into the list of map-marker, that soon will be display on map
        ...studentsList.map((student) {
          List<double> coordinate = extractCoordinate(student['latlng']);
          return Marker(
            markerId: MarkerId(student['id'].toString()),
            infoWindow: InfoWindow(
              title: student['name'],
              snippet: 'tap to get direction',
            ),
            icon:
                student['status'] == 'present'
                    ? greenMarker
                    : (student['status'] == 'pending'
                        ? orangeMarker
                        : BitmapDescriptor.defaultMarker),
            position: LatLng(coordinate[0], coordinate[1]),
          );
        }),
      };
      // maping the studentList into the list of student-tile, that soon will display in bottom-sheet
      studentsStatusTile = [
        ...studentsList.map((student) {
          List<double> coordinate = extractCoordinate(student['latlng']);
          return StudentStatusTile(
            name: student['name'],
            status: student['status'],
            latitude: coordinate[0],
            longitude: coordinate[1],
          );
        }),
      ];
    } else {
      // trigger error if request to get student info is fail
      triggerSnackBar(studentInfoService.error!, Colors.red);
    }
  }

}
