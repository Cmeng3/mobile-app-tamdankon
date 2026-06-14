import 'dart:convert';

import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class UserService {
  UserService();
  //
  String? error;
  String? responseBody;
  // get all parents info
  Future<bool> getAllParents() async {
    return await handlePostRequest(
      onGetError: onGetError,
      onGetResponse: onGetResponse,
      prefix: 'parent',
      data: {},
    );
  }

  // get all driver info
  Future<bool> getAllDrivers() async {
    return await handlePostRequest(
      onGetError: onGetError,
      onGetResponse: onGetResponse,
      prefix: 'driver',
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

  // create the parent account
  Future<bool> createParentAccount(Map<String, String> data) async {
    return await handlePostRequest(
      onGetError: onGetError,
      onGetResponse: onGetResponse,
      prefix: 'parent/create',
      data: data,
    );
  }
  // 
  Future<bool> createDriverAccount(Map<String, String> data) async {
    return await handlePostRequest(
      onGetError: onGetError,
      onGetResponse: onGetResponse,
      prefix: 'driver/create',
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
