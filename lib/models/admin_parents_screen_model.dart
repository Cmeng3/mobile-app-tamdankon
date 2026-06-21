import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/services/bus_service.dart';
import 'package:tamdan_kon_mobile_flutter/services/user_service.dart';

class AdminParentsScreenModel {
  AdminParentsScreenModel({
    required this.onScreenStateChange,
    required this.onTriggerSnackBar,
  });
  // property use for display in main-screen
  List<Map<String, dynamic>> parentsInfoList = [];
  List<Map<String, dynamic>> currentParentsInfoList = [];
  List<dynamic> busList = [];

  // property use for query
  String? parentName;
  String? email;
  String? phoneNumber;
  String? studentName;
  String? sex;
  String? busId;
  String? location;
  String? password;

  UserService userService = UserService();
  BusService busService = BusService();

  // property control the screen-state
  late Timer getParentsTimer;
  bool isLoading = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final void Function() onScreenStateChange;
  final void Function(String message, Color color) onTriggerSnackBar;


  void loadScreenInfo() async{
    await getAllParents();
    getParentsTimer = Timer.periodic(Duration(seconds: 60), getStreamOfParents);
    isLoading = false;
    onScreenStateChange();
  }
  //
  Future<void> getAllParents() async {
     if(await userService.getAllParents()){
      Map<String, dynamic> res = userService.getResponseParse();
      parentsInfoList = List<Map<String, dynamic>>.from(res['parents']);
      currentParentsInfoList = parentsInfoList;
      
    } else {
      onTriggerSnackBar(userService.error!, Colors.red);
    }
  }
  //
  void getStreamOfParents(Timer? timer) async {
    await getAllParents();
    isLoading = false;
    onScreenStateChange();
  }

  Future<List<dynamic>> getAllBus() async {
    if(await busService.getAllBus()){
      Map<String, dynamic> res = busService.getResponseParse();
      busList = res['buses'].map((bus) => bus['id']).toList();
      return busList;
    } else {
      onTriggerSnackBar(busService.error!, Colors.red);
      return [];
    }
  }
  //
  void searchFilter(String value) {
    if(value == '') {
      currentParentsInfoList = parentsInfoList;
    } else{
      currentParentsInfoList = List<Map<String, dynamic>>.from(parentsInfoList.where((parent) => parent['name'].contains(value)));
    }
    onScreenStateChange();
  }
  //
  void createParentAccount() async{
    Map<String, String> data = {
      'parent_name' : parentName!,
      'email' : email!,
      'phone_number' : phoneNumber!,
      'student_name' : studentName!,
      'location' : location!,
      'sex' : sex!,
      'bus_number' : busId!,
      'password' : password!,
    };

    if(await userService.createParentAccount(data)) {
      onTriggerSnackBar('user create successful', Colors.green);
      isLoading = true;
      onScreenStateChange();

      if(await userService.getAllParents()) {
        Map<String, dynamic> res = userService.getResponseParse();
        parentsInfoList = List<Map<String, dynamic>>.from(res['parents']);
        currentParentsInfoList = parentsInfoList;
      } else{
        onTriggerSnackBar(userService.error!, Colors.red);
      }

      isLoading = false;
      onScreenStateChange();

    } else {
      onTriggerSnackBar(userService.error!, Colors.red);
    }
  }
  //
  void savingParentForm(String? input, String field) {
    if(field == 'parent_name') {
        parentName = input;
    } else if(field == 'email') {
        email = input;
    } else if(field == 'phone_number') {
      phoneNumber = input;
    } else if(field == 'student_name') {
      studentName = input;
    } else if(field == 'sex') {
      sex = input;
    } else if(field == 'bus') {
      busId = input;
    }  
     else if(field == 'location') {
      location = input;
    } else if(field == 'password') {
      password = input;
    }
  }
  //
  String? validateParentForm(String? input, String field) {
    if(field == 'parent_name') {
      if(input == null || input.trim() ==  ''){
        return 'must fill name';
      }
    } else if(field == 'email') {
      if(input == null || input.trim() ==  ''){
        return 'must fill email';
      } else if(!EmailValidator.validate(input)){
        return 'please input valid email';
      }
      
    } else if(field == 'phone_number') {
      if(input == null || input.trim() ==  ''){
        return 'must fill phone number';
      }  else if(num.tryParse(input) == null) {
        return 'please input valid phone number';
      }
    } else if(field == 'student_name') {
      if(input == null || input.trim() ==  ''){
       return 'must fill student name';
      }  
    } else if(field == 'location') {

    } else if(field == 'password') {
      if(input == null || input.trim() ==  ''){
        return 'must fill password';
      } 
    }

    return null;
  }
}