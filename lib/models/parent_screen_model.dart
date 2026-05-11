import 'package:shared_preferences/shared_preferences.dart';

class ParentScreenModel {
  ParentScreenModel({required this.onParentScreenChange}){
    getUserInfo();
    print('hello');
  }
  // user's information
  int? id;
  String? username;
  String? email;
  String? role;
  String? phoneNumber;
  // method that control the parent-screen
  final Function() onParentScreenChange;

  // method that fetching user's information from local-storage
  Future<void> getUserInfo() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    
    id = pref.getInt('user_id');
    username = pref.getString('username');
    email = pref.getString('user_email');
    role = pref.getString('user_role');
    phoneNumber = pref.getString('phone_number');
    onParentScreenChange();
  }

}