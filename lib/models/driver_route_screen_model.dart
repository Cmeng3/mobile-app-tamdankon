import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/composable/extract_coordinate.dart';
import 'package:tamdan_kon_mobile_flutter/composable/get_location_setting.dart';
import 'package:tamdan_kon_mobile_flutter/composable/googlemap_polyline_decoder.dart';
import 'package:tamdan_kon_mobile_flutter/services/bus_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/location_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/route_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/student_info_service.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_route_screen/route_dialog.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_route_screen/student_status_tile.dart';

class DriverRouteScreenModel {
  DriverRouteScreenModel({
    required this.driverId,
    required this.onScreenStateChange,
    required this.triggerSnackBar,
    required this.context,
    this.busId,
  });

  // property use for querying and operating something
  final int driverId;
  int? busId;
  Timer? getStudentsInfoTimer;
  Timer? getBusPolylineTimer;
  // specify the location-setting base on specific device
  late LocationSettings locationSetting;
  // instantiate the studentInfo service to get students info on that bus
  StudentInfoService studentInfoService = StudentInfoService();
  // instantiate the BusService service to get bus status
  BusService busService = BusService();
  // instantiate the LocationService to update the bus latest location to backend
  LocationService locationService = LocationService();
  // instantiate the routeService to update and get the route polyline
  RouteService routeService = RouteService();

  // property use for display in driver-route-screen
  BitmapDescriptor greenMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor orangeMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor schoolMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor busMarkerIcon = BitmapDescriptor.defaultMarker;
  late Marker schoolLocation;
  late Marker busLocation;
  late Position busLatestLocation;
  late StreamSubscription<Position> positionStream;
  Set<Marker> studentLocations = {};
  List<StudentStatusTile> studentsStatusTile = [];
  Set<Polyline> polyline = {};

  // property that control the state of drive-route-screen
  bool isLoading = true;
  // use to mark, which sources that the system going to get the location from
  // driver-phone or Iot-device
  late String busLocationResource;
  // get the driver-route-screen build context, use for showing it dialog
  final BuildContext context;
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
    greenMarkerIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(30, 40)),
      'assets/images/green_marker.png',
    );
    // fetch the orange_marker image from app-asset storage
    orangeMarkerIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(50, 50)),
      'assets/images/orange_marker.png',
    );
    // fetch the orange_marker image from app-asset storage
    schoolMarkerIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(50, 50)),
      'assets/images/school_marker.png',
    );
    // fetch the orange_marker image from app-asset storage
    busMarkerIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(30, 30)),
      'assets/images/bus.png',
    );
    // start created the school marker
    schoolLocation = Marker(
      markerId: MarkerId('school'),
      infoWindow: InfoWindow(
        title: 'Paragon Internation School',
        snippet: 'Tap to get direction',
      ),
      icon: schoolMarkerIcon,
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: AppText(
                'Do you want to get school direct?',
                color: Colors.black,
                fontWeight: true,
                fontSize: 18,
              ),
              content: Image(
                image: AssetImage('assets/images/school_marker.png'),
                width: 50,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: AppText(
                    "close",
                    color: const Color.fromARGB(255, 3, 3, 80),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // here is where we must write the logic
                    // first get the polyline from google api
                    // second update polyline to the database
                    if (busLocationResource != 'none') {
                      routeService.updateBusPolyline(
                        busId: busId!,
                        studentLocation: [11.5824079, 104.895406],
                        busLocation: busLatestLocation,
                        direction: 'school',
                      );
                    } else {
                      triggerSnackBar(
                        'please start route first!',
                        Colors.orange,
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: AppText("Get Direction!", color: Colors.green),
                ),
              ],
            );
          },
        );
      },
      position: const LatLng(11.5823172, 104.898543),
    );
    // get the location-setting base on plateform
    locationSetting = getLocationSetting();
    // get the current-location of the bus
    busLatestLocation = await Geolocator.getCurrentPosition(
      locationSettings: locationSetting,
    );
    busLocation = Marker(
      markerId: MarkerId('driver'),
      icon: busMarkerIcon,
      position: LatLng(busLatestLocation.latitude, busLatestLocation.longitude),
    );
    // get bus status, and set bus location resource
    if(await busService.getBusStatus(busId!)) {
      Map<String, dynamic> res = busService.getResponseParse();
      if(res['bus_status'] == 1) {
        busLocationResource = 'driver';
      } else {
        busLocationResource = 'none';
      }
    } else {
      triggerSnackBar(busService.error!, Colors.red);
    }
    // activate the location stream, and it listener
    positionStream = Geolocator.getPositionStream(
      locationSettings: locationSetting,
    ).listen(getUpdateLocation);

    // start initialize fetching the student infomation from that specific bus, and show it in driver-route-screen
    Timer timer = Timer(Duration(), () {});
    await getAndExtractStudentsInfoOnBus(timer);
    // start create data polling:
    // 1: polling the bus-status, and update the studentsList-info when bus-status is (1)
    getStudentsInfoTimer = Timer.periodic(
      const Duration(seconds: 4),
      getAndExtractStudentsInfoOnBus,
    );
    // start create data polling for bus-polyine
    getBusPolylineTimer = Timer.periodic(
      const Duration(seconds: 2),
      getBusPolyline,
    );
    // make screen display as normal, when data ready finish
    isLoading = false;
    onScreenStateChange();
  }

  // get update the latest bus location
  void getUpdateLocation(Position? position) async {
    busLatestLocation = position ?? await Geolocator.getCurrentPosition();
    busLocation = Marker(
      markerId: MarkerId('driver'),
      icon: busMarkerIcon,
      position: LatLng(busLatestLocation.latitude, busLatestLocation.longitude),
    );
    // if the location-resource is gathering from driver phone, we will update-location to database
    // at this point we assume busLatestLocation, always success
    if (busLocationResource == 'driver') {
      if (await locationService.storeBusLocation(
        latitude: busLatestLocation.latitude,
        longitude: busLatestLocation.longitude,
        busId: busId!,
      )) {
        // location update successful
      } else {
        triggerSnackBar(locationService.error!, Colors.red);
      }
    }
    onScreenStateChange();
  }

  // get StudentsInfo
  // right-now we are current not using this function
  // reason: because we want student-status to update on map, even driver don't turn on the route button
  // we change from getStreamOfStudentsInfo to getStreamOfBusStatus
  void getStreamOfBusStatus(Timer timer) async {
    if (await busService.getBusStatus(busId!)) {
      //  get and extract the bus-status from response body
      // active (1) : the driver is ready to allow parent to see the bus on the map
      // inactive (0) : contrast from above statement
      Map<String, dynamic> statusData = busService.getResponseParse();
      int busStatus = statusData['bus_status'] as int;
      // check for bus-active-status and then fetching then start checking all students on bus
      // purpose: get the students info on the bus, only when the bus operate
      if (busStatus == 1) {}
    } else {
      triggerSnackBar(busService.error!, Colors.red);
    }
  }

  // update the bus status
  void updateBusStatus() async {
    if (await busService.updateBusStatus(driverId: driverId)) {
      if(await routeService.updateBusInformation(busId: busId!)) {
        triggerSnackBar('bus status update successful', Colors.green);
      } else {
        triggerSnackBar(busService.error!, Colors.red);
      }
    } else {
      triggerSnackBar(busService.error!, Colors.red);
    }
  }

  //
  void triggerBusInfoAlert(String alert) async{
    if(await routeService.updateBusInformation(busId: busId!, direction: alert)){
      triggerSnackBar('We alert to parents', Colors.blue);
    } else {
      triggerSnackBar(routeService.error!, Colors.red);
    }
  }


  // get stream of current polyline
  void getBusPolyline(Timer timer) async {
    if (busLocationResource == 'none') {
      polyline = {};
      onScreenStateChange();
    } else {
      if (await routeService.getBusPolyline(busId!)) {
        Map<String, dynamic> res = routeService.getResponseParse();
        String? encodedPolyline = res['polyline'];
        if (encodedPolyline != null) {
          polyline = {
            Polyline(
              polylineId: PolylineId('current-route'),
              color: Colors.blue,
              width: 7,
              points: googlemapPolylineDecoder(encodedPolyline),
            ),
          };
        } else {
          polyline = {};
        }
      } else {
        triggerSnackBar(routeService.error!, Colors.red);
      }
      onScreenStateChange();
    }
  }

  // fetching students from each specific bus
  Future<void> getAndExtractStudentsInfoOnBus(Timer timer) async {
    if (await studentInfoService.getStudentsInfoOnBusToday(driverId)) {
      // get the list of students from the response
      Map<String, dynamic> res = studentInfoService.getResponseParse();
      List<Map<String, dynamic>> studentsList = List<Map<String, dynamic>>.from(
        res['data'],
      );
      // loading the students marker
      studentLocations = {
        //maping the studentList into the list of map-marker, that soon will be display on map
        ...studentsList.map((student) {
          List<double> coordinate = extractCoordinate(student['latlng']);
          return Marker(
            markerId: MarkerId(student['id'].toString()),
            infoWindow: InfoWindow(
              title: student['name'],
              snippet: 'tap to get direction',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return RouteDialog(
                      tapFrom: 'studentMarker',
                      status: student['status'],
                      studentName: student['name'],
                      busStatus: busLocationResource,
                      getTriggerSnackbar: triggerSnackBar,
                      studentLocation: coordinate,
                      busLocation: busLatestLocation,
                      direction: student['id'].toString(),
                      busId: busId!,
                      getAndUpdateBusPolyline: routeService.updateBusPolyline,
                    );
                  },
                );
              },
            ),
            icon:
                student['status'] == 'present'
                    ? greenMarkerIcon
                    : (student['status'] == 'pending'
                        ? orangeMarkerIcon
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
            busStatus: busLocationResource,
            getTriggerSnackbar: triggerSnackBar,
            studentLocation: coordinate,
            busLocation: busLatestLocation,
            studentId: student['id'],
            busId: busId!,
            getAndUpdateBusPolyline: routeService.updateBusPolyline,
          );
        }),
      ];
    } else {
      // trigger error if request to get student info is fail
      triggerSnackBar(studentInfoService.error!, Colors.red);
    }
  }
}
