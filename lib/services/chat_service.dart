import 'dart:convert';

import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class ChatService {
  ChatService({required this.userId});

  final int userId;
  String? error;
  String? responseBody;

  // get the parent and driver message
  Future<bool> getParentAndDriverMessages() async {
    Map<String, String> data = {'userId': userId.toString()};
    // return the response
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: onGetResponse,
      prefix: 'chat',
      data: data,
    );
  }

  // store parent and driver message to the database
  Future<bool> storeParentAndDriverMessage(String message) async {
    Map<String, String> data = {
      'userId': userId.toString(),
      'message': message,
    };
    // we will implement later in future
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: onGetResponse,
      prefix: 'chat/store',
      data: data,
    );
  }

  // elevator method
  void getError(String e) {
    error = e;
  }

  void onGetResponse(String? response) {
    responseBody = response;
  }

  // get parse the message
  Map<String, dynamic> getResponseParse() {
    return jsonDecode(responseBody!);
  }
}
