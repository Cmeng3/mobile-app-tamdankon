import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamdan_kon_mobile_flutter/services/user_service.dart';

class ParentMyAccountScreenModel {
  ParentMyAccountScreenModel({
    required this.userId,
    required this.onTriggerParentScreenSnackbar,
    required this.onUpdateAppbarUsername,
    required this.onParentStateChange,
    required this.onUpdateParentStateInfo,
    required this.formKey,
    this.editUsername = false,
    this.editEmail = false,
    this.editPassword = false,
    this.editPhoneNumber = false
  });
  //
  final String userId;
  // isEditing design to allow and lock the UI from editing at the same-time
  bool isEditingLock = false;
  String currentEditing = '';

  // control what field is editing
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

  // store the error message
  String? error;
  //
  bool isLoading = false;
  // update the parent-state after the parent-info change
  final void Function(String data, String currentEditField) onUpdateParentStateInfo;
  //update parent-screen appbar-username
  final void Function(String username) onUpdateAppbarUsername;
  // trigger parent-screen snackbar
  final void Function(String message, Color color) onTriggerParentScreenSnackbar;
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
  void handleEditing() async{
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // we will implement this in future
      // after we finish api-endpoint implementation
      UserService userService = UserService(
        userId: userId,
        updateField: currentEditing,
        updateData: getCurrentUpdateData(),
      );

      if(await userService.getUpdateUser()){
        // we will write the edit data to the local storage
        // also trigger the change in parent-screen and parent-my-account-screen
        // instantiate the sharedpreferences object
        // purpose: write new edit value to locat-storage
        SharedPreferences pref = await SharedPreferences.getInstance();
        // checking which field need to update
        // purpose: update the local-storage and current parent-my-account-screen state
        // note: for password we don't need to update on locat-storage or parent-my-account-screen state
        if(editUsername) {
          // trigger parent-screen to change appbar
          onUpdateAppbarUsername(username!);
          // write the new update info to local storage and reflect change in model-screen
          pref.setString('username', username!);
          onUpdateParentStateInfo(username!, currentEditing);
        } else if (editEmail){
           // write the new update info to local storage and reflect change in model-screen
          pref.setString('user_email', email!);
          onUpdateParentStateInfo(email!, currentEditing);
        } else if (editPassword) {
          // show success snackbar instead of reflecting the update in parent-my-account-screen
          onTriggerParentScreenSnackbar('password updated', Colors.green);
        }
        else if (editPhoneNumber){
           // write the new update info to local storage and reflect change in model-screen
          pref.setString('phone_number', phoneNumber!);
          onUpdateParentStateInfo(phoneNumber!, currentEditing);
        }
        
      } else {
        error = userService.error!;
        onTriggerParentScreenSnackbar(error!, Colors.red);
      }
      // after confirm the editing, let invoke this function to make screen back to normal
      getCancelEditing();
    }
    
  }
  void getConfirmPassword(String? cnfPass) {
    confirmPassword = cnfPass;
  }
  // get the editing information
  // purpose: store it in attribute-data
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

  String getCurrentUpdateData() {
    // get the current edit data
    if(currentEditing == 'username') {
      return username!;
    } else if(currentEditing == 'email') {
      return email!;
    } else if(currentEditing == 'password') {
      return password!;
    } else if(currentEditing == 'phoneNumber') {
      return phoneNumber!;
    }
    return '';
  }
}