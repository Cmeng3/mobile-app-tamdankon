import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/services/bus_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/student_info_service.dart';

class AdminManageRouteScreenModel {
    AdminManageRouteScreenModel({
      required this.onScreenStateChange,
      required this.onTriggerSnackBar,
    });
    // property that use for display in the screen
    List<Map<String, dynamic>> busList = [];
    List<Map<String, dynamic>> currentBusList = [];

    // property that use for query
    BusService busService = BusService();
    StudentInfoService studentInfoService = StudentInfoService();

    // property that control the screen state
    bool isLoading = true;
    late Timer getBusesInfoTimer;
    final void Function() onScreenStateChange;
    final void Function(String message, Color color) onTriggerSnackBar;

    // load screen info
    void loadScreenInfo() async{
       await getAllBus(); 
       getBusesInfoTimer = Timer.periodic(Duration(seconds: 7), getStreamOfBusesInfo);

      isLoading = false;
      onScreenStateChange();
    }
    // get all bus
    Future<void> getAllBus() async {
      if(await busService.getAllBusesAndDrivers()){
        Map<String, dynamic> res = busService.getResponseParse();
        busList = List<Map<String, dynamic>>.from(
          res['data'].map((bus) => {
            'id' : bus['id'],
            'bus_name' : bus['bus_name'],
            'driver' : bus['driver_name'],
            'driver_id' : bus['driver_id'],
            'status' : bus['is_active'] == 0 ? 'Inactive' : 'Active',
          })
        );
        currentBusList = busList;
      } else {
        onTriggerSnackBar(busService.error!, Colors.red);
      }
    }
    // get stream of bus information update
    void getStreamOfBusesInfo(Timer timer) async{
      await getAllBus();

      isLoading = false;
      onScreenStateChange();
      
    }
    // get all students info on specific bus
    Future<List<Map<String, dynamic>>> getAllStudentOnBus(int busId) async {
      if(await studentInfoService.getAllStudentOnBus(busId)){
        Map<String, dynamic> res = studentInfoService.getResponseParse();
        return List<Map<String, dynamic>>.from(
          res['students'].map((student) => {
            'id' : student['id'],
            'name' : student['name'],
            'sex' : student['sex'],
            'parent' : student['parent_name'],
            'latitude' : student['latlng'] != null ? double.tryParse(student['latlng'].split(',')[0]) : 0.0,
            'longitude' : student['latlng'] != null ? double.tryParse(student['latlng'].split(',')[1]) : 0.0,
          })
        );
      } else {
        onTriggerSnackBar(studentInfoService.error!, Colors.red);
        return [];
      }
    }
    //
    void searchFilter(String? input) {
      if(input == '') {
        currentBusList = busList;
      } else {
        currentBusList = List<Map<String, dynamic>>.from(busList.where((bus) => bus['driver'].contains(input)));
      }
      isLoading = false;
      onScreenStateChange();
    }
    // create bus
    void createBus(String? busName) async {
      isLoading = true;
      onScreenStateChange();
      if(await busService.createBus(busName)) {
        onTriggerSnackBar('bus create successful', Colors.green);
        await getAllBus();
      } else {
        onTriggerSnackBar(busService.error!, Colors.red);
      }
      isLoading = false;
      onScreenStateChange();
    }
    // update student a bus
    Future<void> updateStudentABus(int studentId, int busId) async {
      if(await studentInfoService.updateStudentABus(studentId, busId)) {
         onTriggerSnackBar('student bus update successfully', Colors.green);
      } else {
        onTriggerSnackBar(studentInfoService.error!, Colors.red);
      }
    }
}