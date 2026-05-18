import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/parent_attendance_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/parent_chat_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/parent_map_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/my_account_screen/parent_my_account_screen.dart';

class UserModel {
  UserModel({
    required this.onParentScreenChange,
    required this.onTriggerUserAppSnackBar,
    required this.onRootScreenChange
  }){
    // invoke this to get user credential from local-storage asyncronizely
    getUserInfo();
  }
  // user's information
  int? id;
  String? username;
  String? email;
  String? role;
  String? phoneNumber;
  List<Widget>? parentScreens;
  // method that control the parent-screen
  final void Function() onParentScreenChange;
  // method that allow user-app sub-screen to trigger it parent snackbar to show their error
  final void Function(String error) onTriggerUserAppSnackBar;
  //
  final void Function(String rootScreen) onRootScreenChange;

  // method that fetching user's information from local-storage
  Future<void> getUserInfo() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    
    id = pref.getInt('user_id');
    username = pref.getString('username');
    email = pref.getString('user_email');
    role = pref.getString('user_role');
    phoneNumber = pref.getString('phone_number');
    // get the parent screen with initail value
    getParentScreens();
    // trigger parent-screen to update 
    onParentScreenChange();
  }
  // get the parent screen with initial value
  void getParentScreens() {
     parentScreens = [
      ParentMapScreen(
        parentId: id!,
        onTriggerParentAppSnackbar: onTriggerUserAppSnackBar,
      ),
      ParentAttendanceScreen(parentId: id!),
      ParentChatScreen(),
      ParentMyAccountScreen(
        user: userParse(),
        onRootScreenChange: onRootScreenChange,
      ),
    ];
  }

  Map<String, String> userParse() {
    Map<String, String> data = {
      'username' :username!,
      'email' : email!,
      'phone_number' : phoneNumber!,
    };
    return data;
  }

}