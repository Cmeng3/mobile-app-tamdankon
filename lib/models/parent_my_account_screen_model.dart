import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class ParentMyAccountScreenModel {
  ParentMyAccountScreenModel({
    required this.onParentStateChange,
    required this.formKey,
    this.editUsername = false,
    this.editEmail = false,
    this.editPassword = false,
    this.editPhoneNumber = false
  });
  // isEditing design to allow and lock the UI from editing at the same-time
  bool isEditingLock = false;
  String currentEditing = '';
  //
  String? username;
  String? email;
  String? password;
  String? phoneNumber;
  String? confirmPassword;
  // field that control, which information is goint to edit
  bool editUsername;
  bool editEmail;
  bool editPassword;
  bool editPhoneNumber;

  // trigger parent-state-change
  final void Function() onParentStateChange;
  // control parent-form-state
  final GlobalKey<FormState> formKey;

  //
  void clickEditingInformation(String field) {
    // set the editing-lock to true
    // purpose: prevent other field from editing
    isEditingLock = true;
    currentEditing = field;
    // check with field we going to edit
    if(field == 'username') {
      editUsername = true;
    } else if(field == 'email') {
      editEmail = true;
    } else if(field == 'password') {
      editPassword = true;
    } else if(field == 'phoneNumber') {
      editPhoneNumber = true;
    }
    onParentStateChange();
  }
  // cancelling the editing
  void getCancelEditing() {
    // let diplay the back the information
    if(currentEditing == 'username') {
      editUsername = false;
    } else if(currentEditing == 'email') {
      editEmail = false;
    } else if(currentEditing == 'password') {
      editPassword = false;
    } else if(currentEditing == 'phoneNumber') {
      editPhoneNumber = false;
    }
    // unlock the editing
    isEditingLock = false;
    // after cancel, their is no current-editing
    currentEditing = '';
    // trigger parent-state
    onParentStateChange();
  }
  //
  void handleEditing() {
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // we will implement this in future
      // after we finish api-endpoint implementation
    }
    // unlock the editing
    isEditingLock = false;
    // after cancel, their is no current-editing
    currentEditing = '';
    // trigger parent-state
    onParentStateChange();
  }
  void getConfirmPassword(String? cnfPass) {
    confirmPassword = cnfPass;
  }
  // get the editing information
  void getEditInfo(String? data) {
    // checking which field is editing
    // purpose: to store the new editing information
    if(currentEditing == 'username') {
      username = data;
    } else if(currentEditing == 'email') {
      email = data;
    } else if(currentEditing == 'password') {
      password = data;
    } else if(currentEditing == 'phoneNumber') {
      phoneNumber = data;
    }
  }
  // validate the form
  String? validateField(String? input) {
    if(currentEditing == 'username') {
      // verify the uesrname
      if(input == null || input.trim() == '') {
        return 'username must be fill';
      }
      // verify the email
    } else if(currentEditing == 'email') {
      if(input == null || input.trim() == '') {
        return 'email must be fill';
      } else if(!EmailValidator.validate(input)) {
        return 'invalid email format';
      }
      // verify the password
    } else if(currentEditing == 'password') {
      if(input!.length < 8) {
        return 'password must be atleast 8 char';
      }

      if(input.trim() == '') {
        return 'password must be fill';
      }
      // trigger the save() form-state to get the confirm password and new password
      // purpose: to compare does it match
      formKey.currentState!.save();
      if(confirmPassword != password){
        return 'password must be match';
      }

      // verify the phonenumber
    } else if(currentEditing == 'phoneNumber') {
      if(input == null || input.trim() == '') {
        return 'phone-number must be fill';
      } else if(num.tryParse(input) == null) {
        return 'invalid phone-number';
      }
    }
    return null;
  }


}