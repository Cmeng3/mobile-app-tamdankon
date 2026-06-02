import 'dart:convert';

import 'package:tamdan_kon_mobile_flutter/composable/handle_http_request.dart';

class BusService {
  String? error;
  String? responseBody;

  Future<bool> getBusId(int driverId) async {
    Map<String, String> data = {'driverId': driverId.toString()};

    return await handlePostRequest(
      onGetError: getError,
      onGetResponse: getResponse,
      prefix: 'bus/id',
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
