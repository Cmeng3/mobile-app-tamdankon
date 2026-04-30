import 'package:flutter/material.dart';

class AppThemeData{
  
  ThemeData getThemeData() {
    return ThemeData(
          inputDecorationTheme: InputDecorationTheme(
          // styling the spacing inside each form input
          contentPadding: EdgeInsets.symmetric(   
            horizontal: 16,
            vertical: 14,
          ),
          // make the form input's border visible
          // justify it border side and color
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color.fromARGB(255, 38, 38, 38)),
          ),
          // styling the input's border when user focus on it
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          // style the input's border when the input is invalid
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
          // style the input's border when the invalid input is focus
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          // styling the label text
          labelStyle: TextStyle(
            color: Colors.black
          ),
          // styling the hint text
          // display inside the input
          hintStyle: TextStyle(color: Colors.grey.shade400),
          // styling the error text
          // display under the input
          errorStyle: TextStyle(color: Colors.red),
        ),
        
        // styling the overall foundation of app-elevated button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // text color is white
            foregroundColor: Colors.white,
            // background color is app primary-color
            backgroundColor: const Color.fromARGB(255, 3, 3, 80),
            // spacing inside
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            )
          )
        ),

        // predefine the icon theme data
        iconTheme: const IconThemeData(
          color:  Color.fromARGB(255, 3, 3, 80),
        ),

        // predefine the icon-button theme data
        iconButtonTheme:  IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: Color.fromARGB(255, 3, 3, 80),
          )
        )
      );
  }
}