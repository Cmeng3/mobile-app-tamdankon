import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdan_kon_mobile_flutter/composable/checking_location_permission.dart';
import 'package:tamdan_kon_mobile_flutter/services/bus_service.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_chat_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_my_account_screen/driver_my_account_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_route_screen/driver_route_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_students_screen.dart';

class DriverScreenModel {
  DriverScreenModel({
    required this.triggerDriverSnackBar,
    required this.onUpdateDriverState,
    required this.onRootScreenChange,
  }){
    // invoke this to get user credential from local-storage asyncronizely
    getUserInfo();
  }
  // user's information
  int? id;
  int busId = 0;
  String? username;
  String? email;
  String? role;
  String? phoneNumber;
  List<Widget> driverScreens = [];

  // property that control the state of driver-screen
  // problem screen index, use for temporary navigate to temporary error screen
  int temScreenIndex = 0;
  // method that trigger the driver-screen snackbar
  final void Function(String message, Color color) triggerDriverSnackBar;
  // trigger to updated the driver-screen state
  final void Function() onUpdateDriverState;
  // trigger the root-app to change the main-screen
  final void Function(String rootScreen) onRootScreenChange;
  // isloading for preparing data
  bool isLoading = true;

  // method that fetching user's information from local-storage
  Future<void> getUserInfo() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    
    id = pref.getInt('user_id');
    username = pref.getString('username');
    email = pref.getString('user_email');
    role = pref.getString('user_role');
    phoneNumber = pref.getString('phone_number');
    // instantiat the BusService to get the bus id
    // purpose: to get the bus id associate with this driver
    BusService busService = BusService();
    if(await busService.getBusId(id!)){
      Map<String, dynamic> res = busService.getResponseParse();
      busId = res['bus_id'];
    } else {
      triggerDriverSnackBar(busService.error!, Colors.red);
    }
    // checking the user location-service and location-permission
    // promt them to turn location-permission on if it not enable
    // later in future, we will handle the app to another temporary screen, if user location-service and location-permission isn't enable
    // plus(future work): continues checking for location-service during user using the app
    await checkingLocationPermission();
    // get the parent screen with initail value
    getDriverScreens();
    isLoading = !isLoading;
    onUpdateDriverState();
  }
  // get the parent screen with initial value
  void getDriverScreens() {
     driverScreens = [
      DriverRouteScreen(
        triggerDriverSnackBar : triggerDriverSnackBar,
        busId : busId,
        driverId : id!,
      ),
      DriverStudentsScreen(),
      DriverChatScreen(
        driverId: id!,
        triggerDriverSnackBar: triggerDriverSnackBar,
      ),
      DriverMyAccountScreen(
        user: userParse(),
        triggerDriverSnackBar : triggerDriverSnackBar,
        onRootScreenChange: onRootScreenChange
      )
    ];
  }
  // parse the driver-information into Map<String, String> format
  Map<String, String> userParse() {
    Map<String, String> data = {
      'id' : id.toString(),
      'username' :username!,
      'email' : email!,
      'phone_number' : phoneNumber!,
    };
    return data;
  }
}