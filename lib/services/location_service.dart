import 'dart:async';
import 'dart:convert';
import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class LocationService {
  LocationService();

  String? error;
  String? responseBody;
  // get bus location
  Future<bool> getLocation(int busId) async {
    //specific bus number
    final Map<String, String> data = {'busId': busId.toString()};
    // fetch that specific bus number location
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'bus/location',
      data: data,
    );
  }
  // store the bus location
  Future<bool> storeBusLocation({
    required double latitude,
    required double longitude,
    required int busId,
  }) async {
    final Map<String, String> data = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'busId': busId.toString(),
    };

    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'bus/location/create',
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
