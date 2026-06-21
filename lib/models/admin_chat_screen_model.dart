import 'dart:async';

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
  List<Map<String, dynamic>> currentGroupList = [];

  // property that use for query
  final int adminId;
  BusService busService = BusService();
  ChatService chatService = ChatService();

  // property that control the screen state
  late Timer getGroupChatTimer;
  bool isLoading = true;
  final void Function() onScreenStateChange;
  final void Function(String message, Color color) onTriggerSnackBar;

  void loadScreenInfo() async {
    await getAllGroupChat();
    getGroupChatTimer = Timer.periodic(Duration(seconds: 7), getStreamOfGroupChat);
    isLoading = false;
    onScreenStateChange();
  }

  void getStreamOfGroupChat(Timer? timer) async{
    await getAllGroupChat();
    isLoading = false;
    onScreenStateChange();
  }

  Future<void> getAllGroupChat() async{
    if(await busService.getAllBus()) {
      Map<String, dynamic> res = busService.getResponseParse();
      groupList = List<Map<String, dynamic>>.from(res['buses'].map((bus) => {
        'group_name' : 'Bus #${bus['id']} - Group',
        'chatId' : bus['id'],
      }));
      currentGroupList = groupList;
    } else {
      onTriggerSnackBar(busService.error!, Colors.red);
    }
  }

  void searchFilter(String? input) {
    if(input == ''){
      currentGroupList = groupList;
    } else {
      currentGroupList = List<Map<String, dynamic>>.from(groupList.where((group) => group['group_name'].contains(input)));
    }
    onScreenStateChange();
  }
}