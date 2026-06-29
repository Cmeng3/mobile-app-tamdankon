import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class RouteService {
  String? error;
  String? responseBody;
  Map<String, String>? routeResponse;

  // get the bus polyline in encoded string formate
  Future<bool> getBusPolyline(int busId) async {
    Map<String, String> data = {'busId': busId.toString()};
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponseBody,
      prefix: 'bus/polyline',
      data: data,
    );
  }

  // this function do 2 main thing:
  // (1): get the polyline from googlemap-api, by providing origin-position and destination-position
  // (2): store the polyline-encoded-string to database
  Future<bool> updateBusPolyline({
    required List<double> studentLocation,
    required Position busLocation,
    required int busId,
    required String direction,
  }) async {
    // get the polyline from google map
    if (await handleGoogleMapGetRouteHttpRequest(
      onGetError: getError,
      onGetResponse: getRouteResponse,
      studentLocation: studentLocation,
      busLocation: busLocation,
    )) {
      // encode the data that need to query, for updating the polyline to database
      Map<String, String> data = {
        'busId': busId.toString(),
        'direction': direction,
        'polyline': routeResponse!['polyline']!,
        'eta' : routeResponse!['eta']!,
      };
      print('eta: ${routeResponse!['eta']!}');
      // update the polyline to the database
      return await handlePostRequest(
        onGetError: getError,
        onGetResponse: getResponseBody,
        prefix: 'bus/polyline/update',
        data: data,
      );
      // return false if there an error occur during fetching polyline from google-map
    } else {
      return false;
    }
  }

  // elevation method, use for it children to trigger it parent-method
  // purpose: store the error and response from it children-function
  void getError(String e) {
    error = e;
  }
  void getResponseBody(String? response) {
    responseBody = response;
  }
  void getRouteResponse(Map<String, String>? data) {
    routeResponse = data;
  }
  // get response-body parse into dart object
  Map<String, dynamic> getResponseParse() {
    return jsonDecode(responseBody!);
  }
}
