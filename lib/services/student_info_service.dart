import 'dart:async';
import 'dart:convert';
import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class StudentInfoService {
  StudentInfoService();
  // store the parentId for query student info

  String? error;
  String? responseBody;
  // get student information
  Future<bool> getStudentInfo(int parentId) async {
    //specific bus number
    final Map<String, String> data = {'parentId': parentId.toString()};
    // handlePostRequest is the Future<bool> function that handle the http-post request
    // fetch the current student-information
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponseBody,
      prefix: 'student',
      data: data,
    );
  }

  //get a studentId
  Future<bool> getStudentId(int parentId) async {
    final Map<String, String> data = {'parentId': parentId.toString()};

    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponseBody,
      prefix: 'student/id',
      data: data,
    );
  }

  //
  Future<bool> getStudentsInfoInBus(int driverId) async {
    final Map<String, String> data = {'driverId': driverId.toString()};

    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponseBody,
      prefix: 'student/bus',
      data: data,
    );
  }

  // this 2 below function we pass a reference to the handlePostRequest() function
  // purpose: to get update on responseBody and error, StudentInfoService propery
  void getResponseBody(String? response) {
    responseBody = response;
  }

  void getError(String e) {
    error = e;
  }

  Map<String, Object?> getResponseParse() {
    // jsonDecode will convert json_string to Map<String, dynamic> or Map<String, Object?>
    return jsonDecode(responseBody!);
  }
}
