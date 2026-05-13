import 'dart:convert';
import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class AttendanceService {
  AttendanceService({required this.studentId});
  //
  final int studentId;
  String? error;
  String? responseBody;

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
