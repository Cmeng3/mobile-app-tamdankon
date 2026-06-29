
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/attandance_tile.dart';
import 'package:tamdan_kon_mobile_flutter/components/boolean_info_tile.dart';
import 'package:tamdan_kon_mobile_flutter/components/info_tile.dart';
import 'package:tamdan_kon_mobile_flutter/components/style_title_text_logo.dart';
import 'package:tamdan_kon_mobile_flutter/models/parent_map_screen_model.dart';

class ParentMapScreen extends StatefulWidget {
  const ParentMapScreen({
    super.key, 
    required this.parentId,
    required this.onTriggerParentAppSnackbar,
  });
  // store the parent id
  // purpose: query parent corresponse data
  final int parentId;
  final void Function(String message, Color color) onTriggerParentAppSnackbar;

  @override
  State<ParentMapScreen> createState() => _ParentMapScreenState();
}

class _ParentMapScreenState extends State<ParentMapScreen> {
  // storing the current bus location
  late Set<Marker> currentBusMarkerLocation = {
    Marker(
      markerId: MarkerId('home'), 
      position: LatLng(11.5823794,104.8980497), 
      icon: parentMapScreenModel.busMarkerIcon
    ),
  };
  // method that trigger the bus new position update
  void getNewBusLocation(LatLng newLocation) {
    currentBusMarkerLocation.clear();

    setState(() {
      currentBusMarkerLocation.add(
        Marker(
          markerId: MarkerId('home'), 
          infoWindow: InfoWindow(
            title: 'School Bus'
          ),
          position: newLocation, 
          icon: parentMapScreenModel.busMarkerIcon
        ),
      );
    });
  } 
  // invoking these method will update parent-map-screen
  // purpose: allow their children to trigger updating there parent state
  void updateParentState() {
    setState(() {});
  }
  // return the snackBar 
  void getSnackBar(String alert, Color color, Duration? duration) {
    final snackBar = SnackBar(
            backgroundColor: color,
            duration: duration ?? Duration(seconds: 4),
            content: Center(child: AppText(alert)),
          );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // creating parentMapScreenModel, which take contol over logic and data in parent map-screen
  late ParentMapScreenModel parentMapScreenModel = ParentMapScreenModel(
    parentId: widget.parentId,
    onUpdateParentState: updateParentState,
    onUpdateBusLocation: getNewBusLocation,
    onTriggerSnackBar: widget.onTriggerParentAppSnackbar,
    context: context,
  );

  @override
  void initState() {
    super.initState();
    parentMapScreenModel.getStudentInfo();
  }

  @override
  void dispose() {
    super.dispose();
    parentMapScreenModel.getLocationTimer?.cancel();
    parentMapScreenModel.getBusDirectionStatusTimer!.cancel();
    if(parentMapScreenModel.getAttendanceStatusTimer != null){
      parentMapScreenModel.getAttendanceStatusTimer?.cancel();
    }
  }

  @override
  Widget build(context) {
    return parentMapScreenModel.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
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
                height: MediaQuery.of(context).size.height * 0.5,
                // displaying the goolge map view
                child: GoogleMap(
                  onMapCreated: (GoogleMapController mapController) {
                    parentMapScreenModel.mapController = mapController;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(11.5823794,104.8980497),
                    zoom: 16,
                  ),
                  polylines: parentMapScreenModel.polyline,
                  markers: {
                    Marker(
                      markerId: MarkerId('school'),
                      infoWindow: InfoWindow(
                        title: 'Paragon Internation School',
                      ),
                      position: LatLng(11.5823794,104.8980497),
                      icon: parentMapScreenModel.schoolMarkerIcon
                    ),
                    ...currentBusMarkerLocation
                  },
                ),
              ),

              // Container #2 is the student-information's card section
              Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                    // display the student-info title
                    StyleTitleTextLogo('Student Information'),
                    const SizedBox(height: 20),
                    // the student information
                    InfoTile(
                      icon: Icons.person,
                      title: 'Student',
                      value: parentMapScreenModel.studentName ?? 'Not available',
                    ),
                    InfoTile(icon: Icons.wc, title: 'Sex', value: parentMapScreenModel.sex ?? 'Not available'),
                    // Attendance check-tile
                    AttandanceTile(label: 'Attendance', status: parentMapScreenModel.attendanceStatus ?? 'Not available'),
                    BooleanInfoTile(
                      status: parentMapScreenModel.isBusActive,
                      icon: Icons.speed,
                      title: 'Speed',
                      value:'${parentMapScreenModel.busSpeed.toStringAsFixed(1)} km/h ',
                    ),
                    BooleanInfoTile(
                      status: parentMapScreenModel.isBusActive,
                      icon: Icons.bus_alert,
                      title: 'Bus number',
                      value: parentMapScreenModel.busId.toString(),
                    ),
                    InfoTile(
                      icon: Icons.drive_eta,
                      title: 'Driver',
                      value: parentMapScreenModel.driverName ?? 'Not available',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }
}
