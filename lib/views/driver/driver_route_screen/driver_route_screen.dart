import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/style_fab.dart';
import 'package:tamdan_kon_mobile_flutter/models/driver_route_screen_model.dart';

class DriverRouteScreen extends StatefulWidget {
  const DriverRouteScreen({
    super.key,
    required this.driverId,
    required this.busId,
    required this.triggerDriverSnackBar,
  });

  // store the driver-id during instantiate this screen
  // purpose: query essential information
  final int driverId;
  // method use to trigger driver-screen snackbar
  final void Function(String message, Color color) triggerDriverSnackBar;
  // get the bus_Id for query the bus_status
  final int busId;

  @override
  State<DriverRouteScreen> createState() => _DriverRouteScreenState();
}

class _DriverRouteScreenState extends State<DriverRouteScreen> {

  final LatLng initialPosition = const LatLng(11.587098, 104.844813);

  // method for child-class to trigger driver-route-screen state change
  void getDriverStateChange() {
    setState(() {});
  }
  // instiantiate the driverRouteScreenModel, which hold all driver-route-screen logic and data
  late DriverRouteScreenModel driverRouteScreenModel = DriverRouteScreenModel(
    driverId: widget.driverId,
    onScreenStateChange: getDriverStateChange,
    triggerSnackBar: widget.triggerDriverSnackBar,
    busId: widget.busId
  );

  @override
  void initState(){
    super.initState();
    driverRouteScreenModel.loadingScreenInfo();
  }

  @override
  void dispose(){
    // cancel the polling-timer
    driverRouteScreenModel.getStudentsInfoTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stack, is the widget that allow the child widget to stack on each other and position at specific position from LTRB of screen
    // purpose: good to use for stacking the fixed position widget like FAB
    return driverRouteScreenModel.isLoading? const Center(child: CircularProgressIndicator(),) : Stack(
        children: [
          // GoogleMap, display the google map, which take up the whole driver-route-screen
          GoogleMap(
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 13,
            ),
            markers: driverRouteScreenModel.studentMarkers,
          ),
          // Position the FAB on bottom-left of the screen
          Positioned(
            right: 16,
            bottom: 25,
            // Column: layout the driver-route-screen FAB button
            child: Column(
              children: [
                // ToolTip 1#: wrape the student-list FAB button
                Tooltip(
                  message: 'Show students list',
                  // StyleFab 1#: is the customize style-student-list-FAB
                  // purpose: trigger to show ModalBottomSheet that display all student-list
                  child: StyleFab(
                    icon: Icons.groups_rounded,
                    backgroundColor: Colors.white,
                    iconColor: Colors.blue,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        showDragHandle: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                        ),
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20,0,20,20),
                              child: Column(
                                children: [
                                  // Modal-bottom-sheet title
                                  AppText(
                                    "Students List",
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: true,
                                  ),
                                  const SizedBox(height: 20),
                                  // children-attendance-status-list
                                  Expanded(
                                    child: ListView(
                                      children: driverRouteScreenModel.studentsStatusTile,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                // Tooltip 2#: wrap the start-route-navigation FAB button
                // purpose: start the route
                Tooltip(
                  message: 'Start route navigation',
                  child: StyleFab(
                    icon: Icons.play_arrow_rounded,
                    backgroundColor: Colors.blue,
                    iconColor: Colors.white,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
    );
  }
}