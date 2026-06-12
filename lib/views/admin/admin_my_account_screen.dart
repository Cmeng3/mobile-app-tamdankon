import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/logout_dialog.dart';

class AdminMyAccountScreen extends StatefulWidget{
  const AdminMyAccountScreen({
    super.key, 
    required this.onRootScreenChange
  });

  final void Function(String rootScreen) onRootScreenChange;

  @override
  State<AdminMyAccountScreen> createState() => _AdminMyAccountScreenState();
}

class _AdminMyAccountScreenState extends State<AdminMyAccountScreen> {

  @override
  Widget build(context) {
    return Center(child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
      onPressed: () {
        logoutDialog(context, widget.onRootScreenChange);
      }, 
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text('logout')),
    ));
  }
}