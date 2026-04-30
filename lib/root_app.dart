import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_theme_data.dart';
import 'package:tamdan_kon_mobile_flutter/composable/get_screen_parse.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  // currentRootScreen design to control 5 fundamental main-screen of the entire app 
  String currentRootScreen = 'splash_screen';

  // rootScreen store the current main-screen widget, for conditional rendering
  late Widget rootScreenWidget;

  // rootScreenSwitcer's method design to control the state of root-app widget
  // especially for main-screen switching
  void rootScreenSwitcher(String rootScreen) {
    setState(() {
      currentRootScreen = rootScreen;
    });
  }

  @override
  Widget build(context) {
    // getRootScreenParse is composable function, design for parsing String-like screen name to actual screen widget
    rootScreenWidget = getRootScreenParse(currentRootScreen, rootScreenSwitcher);
      
    return MaterialApp(
      // rendering the current app main-screen
      home: rootScreenWidget,
      //
      theme: AppThemeData().getThemeData(),
    );
  }
}