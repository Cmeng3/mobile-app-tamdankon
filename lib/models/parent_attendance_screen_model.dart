import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/services/attendance_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/student_info_service.dart';

class ParentAttendanceScreenModel {
  ParentAttendanceScreenModel({
    required this.parentId,
    required this.formKey,
    required this.onUpdateParentState,
  });
  //
  final int parentId;
  // trigger parent-attendance-screen state
  // use to fetch the attendance relate service: request-status and attendance-status
  late AttendanceService attendanceService;
  //
  final void Function() onUpdateParentState;
  // store all student-attendance records
  List<Map<String, dynamic>> attendancesList = [];
  // store the attendance-request record status
  String attendanceRequestStatus = 'no_request';
  //
  String todayAttendance = 'absent';
  // store the attendance reason
  late String attendanceReason;
  // purpose: trigger parent-form-state from children class
  final GlobalKey<FormState> formKey;
  // error that might occure
  String error = '';
  
  //
  bool isLoading = true;
  // data control a polling-part
  Timer? todayAttendanceTimer;
  Timer? requestStatusTimer;

  // invoke when in formKey.currentState!.validate() is call
  String? validateReason(String? input) {
    // check the reason is fill or not
    if(input == null || input.trim() == ''){
      return 'Please give us the reason';
    }
    return null;
  }
  // it invoke when formKey.currentState!.save() is called
  // to store the input-reason after onSave function in parent-attendance-screen attendance-form invoke
  void getAttendanceReason(String? reason) {
    attendanceReason = reason!;
  }
  // handle the attendance-request submit form
  void handleSubmit() async{
    if(formKey.currentState!.validate()){
      // if validate passed, trigger the form to invoke the onSave call-back function
      formKey.currentState!.save();
      isLoading = true;
      onUpdateParentState();
      if(await attendanceService.storeAttendanceRequestRecord(attendanceReason)){
        attendanceRequestStatus = 'pending';
      } else {
        error = attendanceService.error!;
      }
      // let it delay around 1/4 of second
      Timer(Duration(milliseconds: 250), () {
        isLoading = false;
        onUpdateParentState();
       } );
      
    }
  }
  // get student attendances
  void getStudentAttendances() async{
    StudentInfoService studentInfoService = StudentInfoService();
    // doing api-called to get student id
    if(await studentInfoService.getStudentId(parentId)){
      // extract the student id from response body and store it in studentId
      Map<String, dynamic> res = studentInfoService.getResponseParse();
      int studentId = res['student_id'];
      // after getting studentId, now we instantiat the attendance-service
      // purpose: to get all attendances record of that specific student
      attendanceService = AttendanceService(studentId: studentId);
      if(await attendanceService.getAttendances()){
        Map<String, dynamic> res = attendanceService.getResponseParse();
        // extract specific  student-all-attendance-record to the attendancesList
        attendancesList = List<Map<String, dynamic>>.from(res['data']);
        // checking for the student-today-attendance
        if(await attendanceService.getAttendanceStatus()){
            // get the today-attendance
            todayAttendance = attendanceService.getResponseParse()['attendance_status'];
        } else{
            error = attendanceService.error!;
        }
        // if student present today, let mark attendanceRequestStatus as 'confirm' and end the function
        if(todayAttendance == 'present') {
          attendanceRequestStatus = 'confirm';
        // if not, let doing data polling
        // purpose: update real-time for attendance-request status and today-attendance scan
        } else {
          // calling this one, to retrieve the request-status to ealy update in parent-attendance-screen
          // because it can bet 'pending' or 'no_request'
          getStreamOfRequestStatus(null);
          todayAttendanceTimer = Timer.periodic(Duration(seconds: 2), getStreamOfTodayAttendance);
          // start checking for the request-status
          // if the request-status is 'no_data' or 'pending' 
          // it will keep polling it until student present or request is confirm
          requestStatusTimer = Timer.periodic(Duration(seconds: 4), getStreamOfRequestStatus);
          
        }
      } else{
        error = attendanceService.error!;
      }
    } else{
      error = studentInfoService.error!;
    }
    // trigger parent-state-to-changing here
    //
      isLoading = false;
      onUpdateParentState();
  }
  // if student not present yet, let check for student attendance-request-status
  // by default, it gonna be 'no_data' meaning no today-request-record
  void getStreamOfRequestStatus(Timer? timer) async{
    // checking for the attendance-request-status
    // if confirm, stop fetching and update-parent-state
    if(attendanceRequestStatus == 'confirm'){
      // we don't trigger the parent-attendance-state to update the attendance-request status becuase
      // getStreamOfTodayAttendance actually do it
      // because this two methods, actually checking for the same student-attendance-record
      requestStatusTimer!.cancel();
    }
    // fetching the status
    else if(await attendanceService.getAttendanceRequestStatus()){
      // when api-call success, let store the attendance-request-status
      attendanceRequestStatus = attendanceService.getResponseParse()['status'] as String;
    } else {
      error = attendanceService.error!; 
    }
    onUpdateParentState();
  }
  // stream-request to get the update-record
  void getStreamOfTodayAttendance(Timer? timer) async{
    // checking for student-today-attence
    // if present, we don't need any data-polling request
    if(todayAttendance == 'present') {
      // last fetch of the student-all-attendance record from today;
      if(await attendanceService.getAttendances()){
        Map<String, dynamic> res = attendanceService.getResponseParse();
        // extract specific  student-all-attendance-record to the attendancesList
        attendancesList = List<Map<String, dynamic>>.from(res['data']);
      } else {
        error = attendanceService.error!;
      }
      // after student present today, we cancel-out the data-polling
      // and update the parent-attendance-screen to reflect the latest list-of-student-attendances-record
      todayAttendanceTimer!.cancel();
      onUpdateParentState();
    }
    // we won't trigger update-state here, because we already calling this service one before in $this.getStudentAttendance()
    else if(await attendanceService.getAttendanceStatus()){
      // get the today-attendance
      todayAttendance = attendanceService.getResponseParse()['attendance_status'];
    } else{
      error = attendanceService.error!;
    }
  }
}