import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/services/attendance_service.dart';

class AdminAttendanceScreenModel {
  AdminAttendanceScreenModel({
    required this.onScreenStateChange,
    required this.onTriggerSnackBar,
  });
  // property that use for display in the screen
  List<Map<String, dynamic>> attendanceRequests = [];
  List<Map<String, dynamic>> currentAttendanceRequests = [];

  // property that use for query data
  AttendanceService attendanceService = AttendanceService();

  // property that control the screen state
  bool isLoading = true;
  final void Function() onScreenStateChange;
  final void Function(String message, Color color) onTriggerSnackBar;

  void loadingScreenInfo() async {
    await getAllAttendanceRequest();
    isLoading = false;
    onScreenStateChange();
  }

  // get all attendance request
  Future<void> getAllAttendanceRequest() async {
    if (await attendanceService.getAllAttendanceRequest()) {
      Map<String, dynamic> res = attendanceService.getResponseParse();
      attendanceRequests = List<Map<String, dynamic>>.from(
        res['attendances_request'],
      );
      currentAttendanceRequests = attendanceRequests;
    } else {
      onTriggerSnackBar(attendanceService.error!, Colors.red);
    }
  }

  //
  void searchFilter(String? input) {
    if (input == '') {
      currentAttendanceRequests = attendanceRequests;
    } else {
      currentAttendanceRequests = List<Map<String, dynamic>>.from(
        attendanceRequests.where(
          (request) => request['student'].contains(input),
        ),
      );
    }
    onScreenStateChange();
  }

  // to approve the student attendance
  Future<void> approvedAttendanceRequest(int studentId) async {
    isLoading = true;
    onScreenStateChange();
    if (await attendanceService.confirmAttendanceRequest(studentId)) {
      onTriggerSnackBar('attendance is approve', Colors.green);
      await getAllAttendanceRequest();
    } else {
      onTriggerSnackBar(attendanceService.error!, Colors.red);
    }
    isLoading = false;
    onScreenStateChange();
  }
}
