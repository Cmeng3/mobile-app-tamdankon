import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tamdan_kon_mobile_flutter/composable/get_location_setting.dart';
import 'package:tamdan_kon_mobile_flutter/services/student_info_service.dart';

class DriverStudentsScreenModel {
  DriverStudentsScreenModel({
    required this.onScreenStateChange,
    required this.driverId,
    required this.triggerDriverSnackBar,
  });
  // property use to display in driver-students-screen
  late List<Map<String, dynamic>> students;
  late List<Map<String, dynamic>> filterStudentsList;

  // property use for query data
  final int driverId;
  final void Function(String message, Color color) triggerDriverSnackBar;
  final StudentInfoService studentInfoService = StudentInfoService();
  late LocationSettings locationSetting;
  
  // property use for controling driver-students-screen state
  // hold the state while there are an data fetching in the background
  bool isLoading = true;
  // trigger the state-change in driver-students-screen
  final void Function() onScreenStateChange;

  // loading every essentail data for driver-student-screen
  void loadingScreenInfo() async{
    isLoading = true;
    locationSetting = getLocationSetting();
    // fetching students information from specific bus
    if(await studentInfoService.getAllStudentOnBus(driverId)){
        Map<String, dynamic> res = studentInfoService.getResponseParse();
        filterStudentsList = students = List<Map<String, dynamic>>.from(res['students']);
    } else {
      triggerDriverSnackBar(studentInfoService.error!, Colors.red);
    }

    isLoading = false;
    onScreenStateChange();
  }
  // filter the students with the search-key-word
  void getSearchAndFilter(String search) {
    if(search.isEmpty) {
      filterStudentsList = students;
    } else{
      filterStudentsList = students.where((student) => student['name'].contains(search)).toList();
    }
    onScreenStateChange();
  }
  // update student location
  void updateStudentLocation(int studentId, String latlng) async {
      if(await studentInfoService.updateStudentLocation(studentId, latlng)){
        triggerDriverSnackBar('student location update successful', Colors.green);
      } else {
        triggerDriverSnackBar(studentInfoService.error!, Colors.red);
      }
  }

  void getLatestStudenInfo() async{
    if(await studentInfoService.getAllStudentOnBus(driverId)){
        Map<String, dynamic> res = studentInfoService.getResponseParse();
        filterStudentsList = students = List<Map<String, dynamic>>.from(res['students']);
    } else {
      triggerDriverSnackBar(studentInfoService.error!, Colors.red);
    }

    onScreenStateChange();
  }
}