import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/theme_configuration/app_theme_data.dart';
import 'package:tamdan_kon_mobile_flutter/composable/get_screen_parse.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  // currentRootScreen design to control 5 fundamental main-screen of the entire app 
  String currentRootScreenIndex = 'splash_screen';

  // rootScreen store the current main-screen widget, for conditional rendering
  late Widget currentRootScreen;

  // rootScreenSwitcer's method design to control the state of root-app widget
  // especially for main-screen switching
  void rootScreenSwitcher(String rootScreen) {
    setState(() {
      currentRootScreenIndex = rootScreen;
    });
  }

  @override
  Widget build(context) {
    // getRootScreenParse is composable function, design for parsing String-like screen name to actual screen widget
    currentRootScreen = getRootScreenParse(currentRootScreenIndex, rootScreenSwitcher);
      
    return MaterialApp(
      // rendering the current app main-screen
      home: currentRootScreen,
      //
      theme: AppThemeData().getThemeData(),
    );
  }
}