import 'dart:convert';

import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class UserService {
  UserService();
  //
  String? error;
  String? responseBody;
  //
  Future<bool> getAllParents() async {
    return await handlePostRequest(
      onGetError: onGetError,
      onGetResponse: onGetResponse,
      prefix: 'parent',
      data: {},
    );
  }

  // get update the user-info
  Future<bool> getUpdateUser(
    String userId,
    String updateData,
    String updateField,
  ) async {
    Map<String, String> data = {
      'userId': userId,
      'updateData': updateData,
      'updateField': updateField,
    };
    // doing the http-post-request
    return await handlePostRequest(
      onGetError: onGetError,
      onGetResponse: onGetResponse,
      prefix: 'user/update',
      data: data,
    );
  }

  //
  Future<bool> createParentAccount(Map<String, String> data) async {
    return await handlePostRequest(
      onGetError: onGetError,
      onGetResponse: onGetResponse,
      prefix: 'parent/create',
      data: data,
    );
  }

  //
  void onGetError(String e) {
    error = e;
  }

  //
  void onGetResponse(String? response) {
    responseBody = response!;
  }

  //
  Map<String, dynamic> getResponseParse() {
    return jsonDecode(responseBody!);
  }
}
