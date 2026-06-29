// we will implement the function to do a request and handle the error properly
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

Future<bool> handlePostRequest({
  required void Function(String res) onGetError,
  required void Function(String? res) onGetResponse,
  required String prefix,
  required Map<String, String> data,
}) async {
  try {
    var response = await http.post(
      Uri.parse('http://143.198.221.94/api/$prefix'),
      headers: {'Accept': 'application/json'},
      body: data,
    );
    // if request is ok store it response body
    // and check for status code
    onGetResponse(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else if (response.statusCode == 400) {
      // get the error message response string and decode it
      var error = jsonDecode(response.body);
      onGetError(error['error'] as String);
      return false;
    } else if (response.statusCode == 401) {
      onGetError('Invalid Credential');
      return false;
    } else if (response.statusCode == 403) {
      onGetError('Invalid action');
      return false;
    }
    // if the status code is bedise 200+, we assert it as error
    else {
      onGetError('Something went wrong');
      return false;
    }
    // if there error occure during request, there could be some exception below
  } on SocketException {
    onGetError('No Internet');
    return false;
  } on TimeoutException {
    onGetError('Service too busy');
    return false;
  }
}

Future<bool> handleGoogleMapGetRouteHttpRequest({
  required void Function(String res) onGetError,
  required void Function(Map<String, String>? res) onGetResponse,
  required List<double> studentLocation,
  required Position busLocation,
}) async {
  // Function to get directions from Google Directions API
    final String apiKey = 'AIzaSyC4JQgf_FvMk8lUtzf_Tc2kyuf0MKFW3YY';
    final String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
    final String queryParam = '?origin=${busLocation.latitude},${busLocation.longitude}&destination=${studentLocation[0]},${studentLocation[1]}&key=$apiKey';
    final String url = baseUrl+queryParam;
    // start fetching polyline direction from google-api-endpoint
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // parse the responce
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        Map<String, String> routeResponseData = Map<String, String>.from({
          'polyline' : data['routes'][0]['overview_polyline']['points'],
          'eta' : data['routes'][0]['legs'][0]['duration']['text'],
        });
        // Extract polyline
        onGetResponse(
          routeResponseData
        );
        return true;
      } else{
        onGetError('there no data');
        return false;
      }
    } else {
      onGetError('there problem during get route');
      return false;
    }
  
  
}



