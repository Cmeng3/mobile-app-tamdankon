import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/logout_dialog.dart';

class DriverMyAccountScreen extends StatefulWidget {
  const DriverMyAccountScreen({super.key, required this.onRootScreenChange});

  //
  final void Function(String rootScreen) onRootScreenChange;

  @override
  State<DriverMyAccountScreen> createState() => _DriverMyAccountScreenState();
}

class _DriverMyAccountScreenState extends State<DriverMyAccountScreen> {
  @override
  Widget build(context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          logoutDialog(context, widget.onRootScreenChange);
          
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: AppText('Logout'),
      ),
    );
  }
}
