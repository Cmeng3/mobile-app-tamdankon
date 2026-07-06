import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tamdan_kon_mobile_flutter/composable/googlemap_polyline_decoder.dart';
import 'package:tamdan_kon_mobile_flutter/services/attendance_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/bus_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/location_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/route_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/student_info_service.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/parent_map_screen/bus_info_alert_dialog.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class ParentMapScreenModel {
  ParentMapScreenModel({
    required this.parentId,
    required this.onUpdateParentState,
    required this.onUpdateBusLocation,
    required this.onTriggerSnackBar,
    this.isBusActive = false,
    this.context,
  });
  // store the parent id, to query specific data
  final int parentId;
  
  final void Function() onUpdateParentState;
  // this method is user to trigger the parent-map screen to update the location on map
  final void Function(LatLng newLocation) onUpdateBusLocation;
  // store parent-map-screen on get snack-bar to trigger it later to show the error message
  final void Function(String message, Color color) onTriggerSnackBar;
  //
  BuildContext? context;
  // current bus direct
  String? busDirection;

  //
  late BitmapDescriptor busMarkerIcon;
  late BitmapDescriptor schoolMarkerIcon;
  // map controller
  late GoogleMapController mapController;
  // is loading
  bool isLoading = true;

  // busLocationStatus is design to check for avialable time to get the bus location
  // the avialable time to get bus-location is when driver tiggre start-route button
  bool busLocationStatus = false;
  int? studentId;
  String? studentName;
  String? sex;
  String? attendanceStatus;
  double busSpeed = 0;
  int? busId;
  String? driverName;
  String? error;
  Set<Polyline> polyline = {};
  bool isBusActive;

  // previous bus geocoding-location
  double preLatitude = 0;
  double preLongitude = 0;

  // Timer instant that later will use to cancel the stream of getting location
  Timer? getLocationTimer;
  Timer? getAttendanceStatusTimer;
  Timer? getBusDirectionStatusTimer;
  // we will insert the bus-number later during this implementation
  BusService busService = BusService();
  RouteService routeService = RouteService();
  late LocationService locationService;
  late AttendanceService attendanceService;
  // get Stream location function
  void getStreamLocation(Timer time) async{
    // checking for the bus status
    // active (1) : the driver is ready to allow parent to see the bus on the map
    // inactive (0) : contrast from above statement
    if(await busService.getBusStatus(busId!)){
      //  get and extract the bus-status from response body
      Map<String, dynamic> statusData = busService.getResponseParse();
      int busStatus = statusData['bus_status'] as int;
      // check for bus-active-status and then check for success of getLocation api-call
      if(busStatus == 1 && await locationService.getLocation(busId!)) {
        // if the above condition is pass, it mean bus is active
        // so we start to get the location from the bus
        isBusActive = true;
        // get and extract the latitude and longitude value from the api-call
        Map<String, dynamic> locationData = locationService.getResponseParse();

        // checking if previous location is not set yet
        if(preLatitude == 0 && preLongitude == 0) {
          preLatitude = double.parse(locationData['lat']);
          preLongitude == double.parse(locationData['lng']);
        }
        // get the current location
        double latitude = double.parse(locationData['lat']);
        double longitude = double.parse(locationData['lng']);
        // caculate the distance between that two geocoding
        double distanceInMeter = Geolocator.distanceBetween(preLatitude, preLongitude, latitude, longitude);
        busSpeed = calculateSpeed(distanceInMeter);

        // assign this current location value as previous location
        preLatitude = latitude;
        preLongitude = longitude;

        // create newLocation LatLng instance and new CameraPosition
        LatLng newLocation = LatLng(latitude, longitude);
        CameraPosition cameraPostion = CameraPosition(target: newLocation, zoom: 18);
        // trigger the parent-map-screen to make a map update a new pin and camera position
        onUpdateBusLocation(newLocation);
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(cameraPostion),
          duration: Duration(seconds: 1),
        );
      } else {
        busSpeed = 0.0;
        // is the bus-active-status is 0, it mean it is not the suitable time to get the location
        isBusActive = false;
        onUpdateParentState();
      }
    } else {
      // trigger the snackbar in parent-map-screen to show the get_bus_status error
      onTriggerSnackBar(locationService.error!, Colors.red);
    }
  }

  // calculate speed in km/h
  double calculateSpeed(double distanceInMeter) {
    double valocityInMeterOverSeconde = distanceInMeter / (3.5);
    return (valocityInMeterOverSeconde * 36) / 10;
  }

  // track the bus direction status
  void getStreamOfBusDirectionStatus(Timer? timer) async{
    if(await routeService.getBusPolyline(busId!)) {
      Map<String, dynamic> res = routeService.getResponseParse();
      List<String> directions = [
        studentId.toString(),
        'school',
        'arrived',
        'emergency',
      ];
      print(res);
      if(res['direction'] == studentId.toString() && busDirection != res['direction']) {
        showDialog(context: context!, builder: (context){
            return BusInfoAlertDialog(
              title: 'We going to pick-up your child',
              titleColor: Colors.green,
              content: 'we will arrive around ${res['eta']}',
              contentImage: Image(image: AssetImage('assets/images/home.png'), width: 120),
            );
        });
         polyline = {
            Polyline(
              polylineId: PolylineId('current-route'),
              color: Colors.green,
              width: 7,
              points: googlemapPolylineDecoder(res['polyline']),
            ),
          };
      } else if(res['direction'] == 'school' && busDirection != res['direction']) {
        showDialog(context: context!, builder: (context){
            return BusInfoAlertDialog(
              title: 'We are directing to the school',
              titleColor: Colors.green,
              content: 'we will arrive around ${res['eta']}',
              contentImage: Image(image: AssetImage('assets/images/school_marker.png'), width: 120),
            );
        });
        polyline = {
            Polyline(
              polylineId: PolylineId('current-route'),
              color: Colors.green,
              width: 7,
              points: googlemapPolylineDecoder(res['polyline']),
            ),
        };
      } else if(res['direction'] == 'arrived' && busDirection != res['direction']) {
        showDialog(context: context!, builder: (context){
            return BusInfoAlertDialog(
              title: 'Arrived School!',
              titleColor: Colors.green,
              content: 'we arrived school safe',
              contentImage: Icon(Icons.check, color: Colors.green, size: 60),
            );
        });
        polyline = {};
      } else if(res['direction'] == 'emergency' && busDirection != res['direction']) {
        showDialog(context: context!, builder: (context){
            return BusInfoAlertDialog(
              title: 'Bus meet some issue',
              titleColor: Colors.orange,
              content: 'we are currently fixing it',
              contentImage: Image(image: AssetImage('assets/images/fixed.png'), width: 120),
            );
        });
      } else if(!directions.contains(res['direction'])) {
        polyline = {};
      }

      busDirection = res['direction'];
    } else {
      onTriggerSnackBar(routeService.error!, Colors.red);
    }
  }

  void getStudentAttendanceStatus(Timer timer) async{
    
    if(await attendanceService.getAttendanceStatus(studentId!)){
      // 
      Map<String, dynamic> studentAttendance = attendanceService.getResponseParse();
      attendanceStatus = studentAttendance['attendance_status'] as String;
      if(attendanceStatus == 'present'){
        // distroy the timer-polling when student is present today
        getAttendanceStatusTimer!.cancel();
      } 

    } else {
      // trigger the snackbar in parent-map-screen to show the get_bus_status error
      onTriggerSnackBar(locationService.error!, Colors.red);
    }
  }

  // getStudentInfo, design to earlier fetching the essential information in parent-map-screen
  // those info will later use to fetch another information
  // such as, bus-status, bus-location and studentAttendance
  void getStudentInfo() async {
    StudentInfoService studentInfoService = StudentInfoService();
    // get the student-info by doing http request
    if(await studentInfoService.getStudentInfo(parentId)){
      Map<String, Object?> studentInfo = studentInfoService.getResponseParse();
      Map<String, dynamic> studnetData = studentInfo['data'] as Map<String, dynamic>;
      // get and extract student info from response string
      // and store it to the model attributes
      studentId = studnetData['id'] as int;
      studentName = studnetData['name'] as String;
      sex = studnetData['sex'] as String;
      busId = studnetData['bus_id'] as int;
      driverName = studentInfo['driver_name'] as String;
      attendanceStatus = studentInfo['attendance_status'] as String;
      // get bus marker Icon
      busMarkerIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(30, 30)),
      'assets/images/bus.png',
      );
      schoolMarkerIcon = schoolMarkerIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(50, 50)),
      'assets/images/school_marker.png',
    );
      // after student infomation fetch successfully, let open the timer-polling
      // purpose: to continue requesting bus-locations information and student-attendance status
      locationService = LocationService();
      attendanceService = AttendanceService();
      // store timer-polling object, to destroy it later, when parent-map-screen dispose
      getLocationTimer = Timer.periodic(Duration(seconds: 2), getStreamLocation);
      getAttendanceStatusTimer = Timer.periodic(Duration(seconds: 2), getStudentAttendanceStatus);
      getBusDirectionStatusTimer = Timer.periodic(Duration(seconds: 7), getStreamOfBusDirectionStatus);
    } else{
      error = studentInfoService.error;
      // trigger the snack-bar to get error message
      Timer(Duration(seconds: 2), (){
        onTriggerSnackBar(error!, Colors.red);
      });
    }

    // end the waiting and update the parent-state
    isLoading = false;
    onUpdateParentState();
 
  }
  // this function will vibrate the phone, when execute
  // but cuurently it doesn't working yet
  Future<void> vibratePhone() async {
    if(await Vibration.hasVibrator()) {
      Vibration.vibrate();
    } else {
    }
  }
}