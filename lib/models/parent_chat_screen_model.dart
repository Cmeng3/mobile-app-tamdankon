import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/services/chat_service.dart';

class ParentChatScreenModel {
  ParentChatScreenModel({
    required this.parentId,
    required this.onUpdateParentState,
    required this.onTriggerParentSnackbar,
  });
  //
  final int parentId;
  String? error;
  late ChatService chatService = ChatService();
  List<Map<String, dynamic>> messages = [];

  // control the state of parent-chat-screen
  DateTime? now;
  bool isLoading = false;
  Timer? getChatMessagesTimer;
  final void Function() onUpdateParentState;
  final void Function(String message, Color color) onTriggerParentSnackbar;


  // fecting the api-end point to get messages
  void getMessages() async{
    // waiting for data-fetching ready
    isLoading = true;
    // start fetching the message
    if(await chatService.getParentAndDriverMessages(parentId)) {
      now = DateTime.now();
      // parsing the response into useable format
      Map<String, dynamic> res = chatService.getResponseParse();
      messages = List<Map<String, dynamic>>.from(res['data']);
      // we revers the List of message
      // purpose:  because we want the ListView.builder with reverse option, display the chat in the order from new-to-lastest message
      messages = messages.reversed.toList();
      // start data-polling here
      getChatMessagesTimer =  Timer.periodic(Duration(seconds: 1), getStreamMessages);
    } else {
      error = chatService.error!;
      onTriggerParentSnackbar(error!, Colors.red);
    }
    isLoading = false;
    onUpdateParentState();
  }
  // store the user input-message
  void storeMessage(String? msg, TextEditingController controller) async {
    // if there a message let store it to the database
    if(!(msg == null || msg.trim() == '')){
      if(await chatService.storeParentAndDriverMessage(parentId, msg)){
        controller.clear();
      } else {
        onTriggerParentSnackbar(chatService.error!, Colors.red);
      }
      onUpdateParentState();
    }
  }
  // get the stream of messages
  void getStreamMessages(Timer timer) async{
    if(await chatService.getParentAndDriverMessages(parentId)) {
      // store a new present current DateTime
      // force parent-chat-screen to update state
      now = DateTime.now();  
      // parsing the response into useable format
      Map<String, dynamic> res = chatService.getResponseParse();
      messages = List<Map<String, dynamic>>.from(res['data']);
      // we revers the List of message
      // purpose:  because we want the ListView.builder with reverse option, display the chat in the order from new-to-lastest message
      messages = messages.reversed.toList();

    } else {
      error = chatService.error!;
      onTriggerParentSnackbar(error!, Colors.red);
    }
    onUpdateParentState();
  }
}