import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({
    super.key, 
    required this.onRootScreenChange
  });

  // onRootScreenChange method, design to take a root-app screen switcher's call-back function
  // that be able to trigger it root-app setState() to change to specific main-screen
  final void Function(String currentRootScreen) onRootScreenChange;

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('parent screen')
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('user_id');
          prefs.remove('username');
          prefs.remove('user_role');
          prefs.remove('user_email');
          prefs.remove('phone_number');
          prefs.remove('user_token');

          widget.onRootScreenChange('login_screen');

        },
        child:AppText('Log out'),
      ),
    );
  }
}