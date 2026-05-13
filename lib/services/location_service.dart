import 'dart:async';
import 'dart:convert';
import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class LocationService {
  LocationService({required this.busNumber});

  final int busNumber;
  String? error;
  String? responseBody;
  // get bus location
  Future<bool> getLocation() async {
    //specific bus number
    final Map<String, String> data = {'busId': busNumber.toString()};
    // fetch that specific bus number location
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'bus/location',
      data: data,
    );
  }

  Future<bool> getBusStatus() async {
    //specific bus number
    final Map<String, String> data = {'busId': busNumber.toString()};
    // fetch specific bus status
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'bus/status',
      data: data,
    );
  }

  void getResponse(String? response) {
    responseBody = response;
  }

  void getError(String e) {
    error = e;
  }
  Map<String, dynamic> getResponseParse() {
    return jsonDecode(responseBody!);
  }
}
