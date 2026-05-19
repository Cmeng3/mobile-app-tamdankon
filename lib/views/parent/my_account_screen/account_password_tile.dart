import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class AccountPasswordTile extends StatelessWidget {
  AccountPasswordTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onEditingInformation,
    required this.onCancelEditing,
    required this.onConfirmEditing,
    required this.onValidateInput,
    required this.onSavedEditing,
    required this.onSavedConfirmPassword,
    required this.onParentStateChange,
    this.isEditing = false,
    this.editLock = false,
    this.obscureText = true,
    required this.formKey,
  });

  //
  bool editLock;
  final IconData icon;
  final String title;
  //
  bool obscureText;
  // lock the editing 
  bool isEditing;
  final GlobalKey<FormState> formKey;
  // trigger edit-lock handler function
  final void Function() onEditingInformation;
  // trigger cancel-edit handler function
  final void Function() onCancelEditing;
  // trigger confirm-edit handler function
  final void Function() onConfirmEditing;
  // trigger to validate the input-field
  final String? Function(String? input)? onValidateInput;
  // trigger to save the input
  final void Function(String? data) onSavedEditing;
  // trigger to save the confirm-password
  final void Function(String? confirmPass) onSavedConfirmPassword;
  // trigger the parent-my-account-state
  final void Function() onParentStateChange;


  @override 
  Widget build(context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(2, 0, 0, 0),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Container 2#: display the logo-badge
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(31, 33, 150, 243),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: true,
                ),
                const SizedBox(height: 4),
                isEditing ?
                // display the form if it editing
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: 'New $title',
                          suffixIcon: IconButton(
                            onPressed: () {
                                obscureText = !obscureText;
                                onParentStateChange();
                            },
                            iconSize: 16,
                            icon: obscureText? Icon(Icons.visibility, color: Colors.blue) : Icon(Icons.visibility_off, color: Colors.blue),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          errorBorder:  UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          focusedErrorBorder:  UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: onValidateInput,
                        onSaved: onSavedEditing, 
                      ),
                      TextFormField(
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: 'Confirm new $title',
                          suffixIcon: IconButton(
                            onPressed: () {
                                obscureText = !obscureText;
                                onParentStateChange();
                            },
                            iconSize: 16,
                            icon: obscureText? Icon(Icons.visibility, color: Colors.blue) : Icon(Icons.visibility_off, color: Colors.blue)
                            ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          errorBorder:  UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          focusedErrorBorder:  UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: onValidateInput, 
                        onSaved: onSavedConfirmPassword,
                      ),
                    ],
                  ),
                ) :
                AppText(
                  '••••••••••',
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: true,
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          editLock
              ? 
              // Text here is just the placeholder
              const SizedBox(width: 0,) 
              // display the edit icon
              : IconButton(
                onPressed: onEditingInformation,
                icon: const Icon(Icons.edit_outlined, color: Colors.grey),
              ),
          
          isEditing? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onConfirmEditing,
                icon: const Icon(Icons.check),
                color: Colors.green,
                padding: EdgeInsets.zero
              ),
              IconButton(
                onPressed: onCancelEditing,
                icon: const Icon(Icons.close),
                color: Colors.red,
                padding: EdgeInsets.zero
              ),
            ],
          ) : SizedBox(width: 0)
        ],
      ),
    );
  }
}