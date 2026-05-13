import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

// provide login services for login form submission
// services provided:
// 1. do an http request to login user-input credential:
// - handle exception during post-request
// - check for response status-code
// 2. parse the response from json-format to dart-object
// 3. parse the general response
class LoginService {
  LoginService({
    required this.username,
    required this.password,
  });
  // accept the username and password during instanciate
  final String username;
  final String password;
  //
  String? error;

  // store the response-body after successfully finishing request
  String? responseBody;
  String? token;
  // 1# do an http request to login user-input credential
  Future<bool> loginUser() async{
    final Map<String, String> data = {
      'username' : username,
      'password' : password
    };
    //  handle exceptions and unexpect response properly
    try {
        var response = await http.post(
        Uri.parse('http://143.198.221.94/api/login'),
        headers: {
          'Accept' : 'application/json',
        },
        body: data,
        );
        // if request is ok store it response body
        // and check for status code
        responseBody = response.body;
        if(response.statusCode >= 200 && response.statusCode < 300){
          return true;
        } else if(response.statusCode == 401){
          error = 'Invalid Credential';
          return false;
        } else if(response.statusCode == 403){
          error = 'Invalid action';
          return false;
        }
        // if the status code is bedise 200+, we assert it as error
        else {
          error = 'Something went wrong';
          return false;
        }
    // if there error occure during request, there could be some exception below
    } on SocketException {
        error = 'No Internet';
        return false;
    } on TimeoutException {
        error = 'Service too busy';
        return false;
    }    
  }
  // 2# parse the user-response from json-format to dart-object
  Map<String, Object?> getUser() {
    // parse the response json-string to dart object
    var responseData = jsonDecode(responseBody!);
    // storing the token
    token = responseData['token'];
    // return the user-info as Map<String, Object?>
    return responseData['user'] as Map<String, Object?>;
  }
  // 3# parse the general response
  Map<String, Object?> getResponseParse() {
    return jsonDecode(responseBody!) as Map<String, Object?>;
  }

}