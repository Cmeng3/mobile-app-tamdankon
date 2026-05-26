import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_chat_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_my_account_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_route_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_students_screen.dart';

class DriverScreenModel {
  DriverScreenModel({
    required this.onUpdateDriverState,
  }){
    // invoke this to get user credential from local-storage asyncronizely
    getUserInfo();
  }
  // user's information
  int? id;
  String? username;
  String? email;
  String? role;
  String? phoneNumber;
  List<Widget> driverScreens = [];

  // trigger to updated the driver-screen state
  final void Function() onUpdateDriverState;
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
    // get the parent screen with initail value
    getDriverScreens();
    isLoading = !isLoading;
    onUpdateDriverState();
  }
  // get the parent screen with initial value
  void getDriverScreens() {
     driverScreens = [
      DriverRouteScreen(),
      DriverStudentsScreen(),
      DriverChatScreen(),
      DriverMyAccountScreen()
    ];
  }
}