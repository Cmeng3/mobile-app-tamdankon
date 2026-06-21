import 'dart:convert';
import 'package:http/http.dart';
import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class ChatService {
  ChatService();

  String? error;
  String? responseBody;

  // get the parent and driver message
  Future<bool> getParentAndDriverMessages(int userId) async {
    Map<String, String> data = {'userId': userId.toString()};
    // return the response
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: onGetResponse,
      prefix: 'chat',
      data: data,
    );
  }

  // get the admin message
  Future<bool> getAdminMessages(int userId, int chatId) async {
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: onGetResponse,
      prefix: 'chat',
      data: {'userId': userId.toString(), 'chatId': chatId.toString()},
    );
  }

  // store parent and driver message to the database
  Future<bool> storeParentAndDriverMessage(int userId, String message) async {
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

  // store admin message
  Future<bool> storeAdminMessage(
    int adminId,
    int chatId,
    String message,
  ) async {
    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: onGetResponse,
      prefix: 'chat/store',
      data: {
        'userId' : adminId.toString(),
        'chatId' : chatId.toString(),
        'message' : message
      },
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
