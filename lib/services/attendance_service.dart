import 'dart:convert';
import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class AttendanceService {
  AttendanceService({required this.studentId});
  //
  final int studentId;
  String? error;
  String? responseBody;

  // get the specific today attendance
  // the output could be 'absent' or 'present'
  Future<bool> getAttendanceStatus() async {
    // prepare request-body data to do post http request
    Map<String, String> data = {'studentId': studentId.toString()};
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'attendance',
      data: data,
    );
  }

  // get specific student-all-attendances record
  //
  Future<bool> getAttendances() async {
    // prepare request-body data to do post http request
    Map<String, String> data = {'studentId': studentId.toString()};
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'attendances',
      data: data,
    );
  }

  // get the today-attendance-request record
  // data will return 'confirm': when student is present or attendance-request is approve
  // data will return 'no_data': when student is absent or parent not asking for permission yet
  // data will return 'pending': when attendance-request is waiting for confirm
  Future<bool> getAttendanceRequestStatus() async {
    // prepare request-body data to do post http request
    Map<String, String> data = {'studentId': studentId.toString()};
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'attendance/request/status',
      data: data,
    );
  }

  //
  Future<bool> storeAttendanceRequestRecord(String reason) async {
    // prepare request-body data to do post http request
    Map<String, String> data = {
      'studentId': studentId.toString(),
      'reason': reason,
    };
    //
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'attendance/request/create',
      data: data,
    );
  }

  // getResponse and getError design to do elevator-connection between main class to another class or method
  // in our case: is to get the responseBody and error from handlPostRequest() method call
  void getResponse(String? response) {
    responseBody = response;
  }

  void getError(String e) {
    error = e;
  }

  //
  Map<String, dynamic> getResponseParse() {
    return jsonDecode(responseBody!);
  }
}
