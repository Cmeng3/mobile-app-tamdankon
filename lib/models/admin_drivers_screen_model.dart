import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/services/bus_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/user_service.dart';

class AdminDriversScreenModel {
  AdminDriversScreenModel({
    required this.onScreenStateChange,
    required this.onTriggerSnackBar
  });
  // property that display on the screen
  List<Map<String, dynamic>> driverList = [];
  List<Map<String, dynamic>> currentDriverList = [];

  // property that use for query
  String? name;
  String? email;
  String? phoneNumber;
  String? password;
  String? busId;
  UserService userService = UserService();
  BusService busService = BusService();

  // property that control the screen state
  bool isLoading = true;
  final void Function() onScreenStateChange;
  final void Function(String message, Color color) onTriggerSnackBar;

  // loading screen information
  void loadScreenInfo() async{
    await getAllDriver();
    isLoading = false;
    onScreenStateChange();
  }
  // get all drivers infomation and display on screen
  Future<void> getAllDriver() async{
    if(await userService.getAllDrivers()) {
      Map<String, dynamic> res = userService.getResponseParse();
      driverList = List<Map<String, dynamic>>.from(
                  res['data'].map((driver) => {
                  'id' : driver['id'],
                  'name' : driver['name'],
                  'email' :driver['email'],
                  'phone' : driver['phone_number'],
                  'hasBus' : driver['hasBus'],
                  'busId' : driver['busId'],
                })
      );
      currentDriverList = driverList;
    } else {
      onTriggerSnackBar(userService.error!, Colors.red);
    }
  }
  //
  void assignDriverABus( int driverId, int busId) async {
    isLoading = true;
    onScreenStateChange();
    if(await busService.assignDriverABus(driverId, busId)){
      onTriggerSnackBar('bus assign successfully', Colors.green);
      await getAllDriver();
    } else {
      onTriggerSnackBar(busService.error!, Colors.red);
    }
    isLoading = false;
    onScreenStateChange();
    
  }
  // filter the search
  void searchFilter(String? input) {
    if(input == '') {
      currentDriverList = driverList;
    } else {
      currentDriverList = List<Map<String, dynamic>>.from(driverList.where((driver) => driver['name'].contains(input)));
    }
    onScreenStateChange();
  }

  // loading all buses info
  Future<List<dynamic>> getBuses() async {
    if(await busService.getAllBus()) {
      Map<String, dynamic> res = busService.getResponseParse();
      return List<dynamic>.from(
        res['buses'].map((bus) => {
          'id' : bus['id'],
          'driver_id' : bus['driver_id'],
        })
      );
    } else {
      onTriggerSnackBar(busService.error!, Colors.red);
      return [];
    }
  }
  //
  void createDriverAccount() async{
    Map<String, String> data = {
      'name' : name!,
      'phone_number' : phoneNumber!,
      'email' : email!,
      'password' : password!,
      'busId' : busId!,
    };
    isLoading = true;
    onScreenStateChange();
    if(await userService.createDriverAccount(data)){
      onTriggerSnackBar('driver account create successfully', Colors.green);
      await getAllDriver();
    } else {
      onTriggerSnackBar(userService.error!, Colors.red);
    }
    isLoading = false;
    onScreenStateChange();
  }
  // valide the driverForm
  String? validateDriverForm(String? input, String field) {
    if(field == 'name') {
      if(input == null || input.trim() == '') {
        return 'name must be fill';
      }
    } else if(field == 'phone_number'){
      if(input == null || input.trim() == '') {
        return 'phone number must be fill';
      } else if(num.tryParse(input) == null) {
        return 'please input valid phone number';
      }
    } else if(field == 'email'){
      if(input == null || input.trim() == '') {
        return 'email must be fill';
      } else if(!EmailValidator.validate(input)){
        return 'please input valid email';
      }
    } else if(field == 'password'){
      if(input == null || input.trim() == '') {
        return 'password must be fill';
      }
    }

    return null;
  }
  // 
  void getDriverInfoSave(String? input, String field) {
    if(field == 'name') {
      name = input;
    } else if(field == 'phone_number'){
      phoneNumber = input;
    } else if(field == 'email'){
      email = input;
    } else if(field == 'password'){
      password = input;
    } else if(field == 'bus'){
      busId = input;
    }
  }

}