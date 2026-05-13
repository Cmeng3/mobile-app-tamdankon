// we will implement the function to do a request and handle the error properly
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<bool> handlePostRequest(
  {
    required void Function(String res) onGetError,
    required void Function(String? res) onGetResponse, 
    required String prefix, 
    required Map<String, String> data
  }) async{
    
  try {
        var response = await http.post(
        Uri.parse('http://143.198.221.94/api/$prefix'),
        headers: {
          'Accept' : 'application/json',
        },
        body: data,
        );
        // if request is ok store it response body
        // and check for status code
        onGetResponse(response.body);
        if(response.statusCode >= 200 && response.statusCode < 300){
          return true;
        } 
        else if(response.statusCode == 400){
          // get the error message response string and decode it
          var error = jsonDecode(response.body);
          onGetError(error['error'] as String);
          return false;
        } else if(response.statusCode == 401){
          onGetError('Invalid Credential');
          return false;
        } else if(response.statusCode == 403){
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