import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class UserService {
  UserService({
    required this.userId,
    required this.updateData,
    required this.updateField,
  });
  // field used for query the user-info
  final String userId;
  final String updateData;
  final String updateField;
  //
  String? error;
  String? responseBody;

  Future<bool> getUpdateUser() async {
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
  void onGetError(String e) {
    error = e;
  }
  //
  void onGetResponse(String? response) {
    responseBody = response!;
  }
  //
  void getResponseParse() {

  }
}
