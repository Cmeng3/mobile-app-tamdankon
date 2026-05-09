
import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// LoginForm is a model that is designed to manage the logics and data in login-screen
// It encapsulate those logics and data together
class LoginModel {
  LoginModel({
    required this.formKey,
    required this.onLoginStateChange,
    required this.onTriggerSnackBar,
    required this.onRootScreenChange,
  });

  // formKey is property that hold the FormState global key
  // It control the specific form-state with this specific key
  final GlobalKey<FormState> formKey;
  // fields in the form input
  String? username;
  String? password;
  // store the possible error
  String? error;
  // store the function that able to trigger form-screen state
  final void Function() onLoginStateChange;
  // store the function that able to trigger snackbar in form-screen state
  final void Function(String error) onTriggerSnackBar;
  // store the function to tricker the root-screen change
  final void Function(String rootScreen) onRootScreenChange;

  // validate the password of the input
  // it must not be empty and atleast 8 character
  String? validatePassword(String? password) {
    if(password == null || password == '' || password.trim() == ''){
      return 'password must be fill';
    }
    else if(password.length < 8) {
      return 'password must be atleas 8 character';
    }

    return null;
  }

  // validate the username of the input
  // it must not be empty
  String? validateUsername(String? username){
    if(username == null || username == '' || username.trim() == ''){
      return 'username must be fill';
    }
    return null;
  }

  // handle action when user press submit the field
  void submitHandler() async{
    // trigger every TextFormField onValidate call-back function and update the form state
     if(formKey.currentState!.validate()){
       // tra the form-screen state 
       onLoginStateChange();
      // trigger every TextFormField onSave call-back function
      formKey.currentState!.save();
      final loginService = LoginService(username: username!, password: password!);
      // invoking loginService.loginUser() to login user throught http request
      if(await loginService.loginUser()){
        // extract user and token from reponse in LoginService()
        final Map<String, Object?> user = loginService.getUser();
        // create an SharePreferences instance, for saving data to db
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        // save user informations to local-storage
        await prefs.setInt('user_id', user['id'] as int);
        await prefs.setString('username', user['name'] as String);
        await prefs.setString('user_role', user['role'] as String);
        await prefs.setString('user_email', user['email'] as String);
        await prefs.setString('phone_number', user['phone_number'] as String);
        await prefs.setString('user_token', loginService.token as String);
        

        // get the user back to splash-screen for a second welcome
        onRootScreenChange('splash_screen');

      } else {
        // if login user fail then store the error
        // It might be exception-error or assertion-error
        error = loginService.error;
        // trigger snackbar to pop-up error
        onTriggerSnackBar(error!);
      }
       onLoginStateChange();
    }
   
  }

  // update the password, in the onSave call-back function when validation is passed
  void getPassword(String? inputPassword) {
    password = inputPassword;
  }
  // update the username, in the onSave call-back function when validation is passed
  void getUsername(String? getUsername){
    username = getUsername;
  }

}