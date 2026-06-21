import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_attendance_screen/admin_attendance_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_chat_screen/admin_chat_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_drivers_screen/admin_drivers_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_manage_route_screen/admin_manage_route_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_my_account_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_parents_screen/admin_parents_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_search_screen.dart';

class AdminScreenModel {
  AdminScreenModel({
    required this.onScreenStateChange,
    required this.onGetCurrentScreen,
    required this.onTriggerSnackBar,
    required this.onRootScreenChange,
  });

  // user's information
  int? id;
  String? username;
  String? email;
  String? role;
  String? phoneNumber;
  late List<Widget> adminScreens;

  // 
  bool isLoading = true;

  // control screen state
  final void Function() onScreenStateChange;
  final void Function(int screenIndex) onGetCurrentScreen;
  final void Function(String message, Color color) onTriggerSnackBar;
   // trigger to switching root-screen
  final void Function(String rootScreen) onRootScreenChange;

  // method that fetching user's information from local-storage
  Future<void> getUserInfo() async{

    isLoading = true;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    
    id = pref.getInt('user_id');
    username = pref.getString('username');
    email = pref.getString('user_email');
    role = pref.getString('user_role');
    phoneNumber = pref.getString('phone_number');

    getParentScreens();

    isLoading = false;
    onScreenStateChange();

  }

  // get the parent screen with initial value
  void getParentScreens() {
     adminScreens = [
      AdminParentsScreen(onTriggerSnackBar: onTriggerSnackBar,),
      AdminDriversScreen(onTriggerSnackBar: onTriggerSnackBar,),
      AdminSearchScreen(onGetCurrentScreen: onGetCurrentScreen,),
      AdminChatScreen(
        adminId: id!,
        onTriggerSnackBar: onTriggerSnackBar,
      ),
      AdminAttendanceScreen(onTriggerSnackBar: onTriggerSnackBar,),
      AdminManageRouteScreen(onTriggerSnackBar: onTriggerSnackBar),
      AdminMyAccountScreen(
        onRootScreenChange: onRootScreenChange,
      ),
    ];
  }

  Map<String, String> userParse() {
    Map<String, String> data = {
      'id' : id.toString(),
      'username' :username!,
      'email' : email!,
      'phone_number' : phoneNumber!,
    };
    return data;
  }
}