
import 'package:flutter/material.dart';

// LoginForm is a model that is designed to manage the logics and data in login-screen
// It encapsulate those logics and data together
class LoginForm {
  LoginForm({required this.formKey});

  // formKey is property that hold the FormState global key
  // It control the specific form-state with this specific key
  final GlobalKey<FormState> formKey;
  // fields in the form input
  String? username;
  String? password;

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
  void submitHandler() {
    // trigger every TextFormField onValidate call-back function and update the form state
     if(formKey.currentState!.validate()){
      // trigger every TextFormField onSave call-back function
      formKey.currentState!.save();
      print('username: ${username}');
      print('password: ${password}');
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