import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/services/bus_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/chat_service.dart';

class AdminChatScreenModel {
  AdminChatScreenModel({
    required this.adminId,
    required this.onTriggerSnackBar,
    required this.onScreenStateChange,
  });

  // property that use for display in the screen
  List<Map<String, dynamic>> groupList = [];

  // property that use for query
  final int adminId;
  BusService busService = BusService();
  ChatService chatService = ChatService();

  // property that control the screen state
  bool isLoading = true;
  final void Function() onScreenStateChange;
  final void Function(String message, Color color) onTriggerSnackBar;

  void loadScreenInfo() async {
    if(await busService.getAllBus()) {
      Map<String, dynamic> res = busService.getResponseParse();
      groupList = List<Map<String, dynamic>>.from(res['buses'].map((bus) => {
        'group_name' : 'Bus #${bus['id']} - Group',
        'chatId' : bus['id'],
      }));
      print(groupList);
    } else {
      onTriggerSnackBar(busService.error!, Colors.red);
    }
    isLoading = false;
    onScreenStateChange();
  }
}