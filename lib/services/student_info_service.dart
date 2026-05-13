import 'dart:async';
import 'dart:convert';
import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class StudentInfoService {
  StudentInfoService({
    required this.parentId,
  });
  // store the parentId for query student info
  final int parentId;

  String? error;
  String? responseBody;
  // get bus location
  Future<bool> getStudentInfo() async{
    //specific bus number
    final Map<String, String> data = {
      'parentId' : parentId.toString(),
    };
    // handlePostRequest is the Future<bool> function that handle the http-post request
    // fetch the current student-information
    return await handlePostRequest(
      onGetError: getError, 
      onGetResponse: getResponseBody, 
      prefix: 'student', 
      data: data
    );
  }
  // this 2 below function we pass a reference to the handlePostRequest() function
  // purpose: to get update on responseBody and error, StudentInfoService propery
  void getResponseBody(String? response){
    responseBody = response;
  }
  void getError(String e){
    error = e;
  }
  
  Map<String, Object?> getResponseParse(){
    // jsonDecode will convert json_string to Map<String, dynamic> or Map<String, Object?>
    return jsonDecode(responseBody!);
  }

}