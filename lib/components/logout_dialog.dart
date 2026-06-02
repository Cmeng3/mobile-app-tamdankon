import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/composable/logout_user.dart';

Future<void> logoutDialog(BuildContext context, Function onRootScreenChange) async{
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: AppText("Do you want to logout?", color: Colors.black, fontSize: 18,),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Close"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              logoutUser(onRootScreenChange);
            },
            child: Text("Logout"),
          ),
        ],
      );
    },
  );
}