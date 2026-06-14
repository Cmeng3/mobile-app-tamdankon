import 'dart:convert';

import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class BusService {
  String? error;
  String? responseBody;

  // get all bus information
  Future<bool> getAllBus() async {
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'bus/all',
      data: {},
    );
  }

  // get the current bus-Id
  Future<bool> getBusId(int driverId) async {
    Map<String, String> data = {'driverId': driverId.toString()};

    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'bus/id',
      data: data,
    );
  }

  // get the current bus-status
  Future<bool> getBusStatus(int busNumber) async {
    //specific bus number
    final Map<String, String> data = {'busId': busNumber.toString()};
    // fetch specific bus-status
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'bus/status',
      data: data,
    );
  }

  //
  Future<bool> assignDriverABus(int driverId, int busId) async {
    Map<String, String> data = {
      'busId': busId.toString(),
      'driverId': driverId.toString(),
    };
    
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'bus/assign',
      data: data,
    );
  }

  // update the bus-status
  // get the current bus-status
  Future<bool> updateBusStatus({required int driverId}) async {
    //specific bus number
    final Map<String, String> data = {'driverId': driverId.toString()};
    // fetch specific bus-status
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'bus/status/update',
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
