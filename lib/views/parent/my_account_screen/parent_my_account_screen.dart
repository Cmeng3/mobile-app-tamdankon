import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/user_avatar.dart';
import 'package:tamdan_kon_mobile_flutter/composable/logout_user.dart';
import 'package:tamdan_kon_mobile_flutter/models/parent_my_account_screen_model.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/my_account_screen/account_info_tile.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/my_account_screen/account_password_tile.dart';

class ParentMyAccountScreen extends StatefulWidget {
  const ParentMyAccountScreen({
    super.key,
    required this.user,
    required this.onRootScreenChange,
  });

  // get the user information
  final Map<String, String> user;
  // root-screen-switcher
  final void Function(String rootScreen) onRootScreenChange;
  @override
  State<ParentMyAccountScreen> createState() =>
      _ParentMyAccountScreenState();
}

class _ParentMyAccountScreenState extends State<ParentMyAccountScreen> {
  // formkey
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // obscure text
  bool obscureText = true;
  //
  void changeObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }
  // let child trigger a change in parent-state
  void changeParentState() {
    setState(() {});
  }
  //
  late ParentMyAccountScreenModel parentMyAccountScreenModel = ParentMyAccountScreenModel(
    formKey: _formkey,
    onParentStateChange: changeParentState,
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          // this make the space for the elements inside fo the singleChildScrollView()
          padding: const EdgeInsets.all(20),
          // Column 1#: layout all the parent my-account-screen elements
          child: Column(
            children: [
              // Container 1#: Card of that hold parent-avatar image
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 74, 144, 226),
                      Color.fromARGB(255, 53, 122, 189),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // make the card 1# border a little bit rounded
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(64, 33, 150, 243),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                // Column 2#: list elements such as avata in the card 1# 
                child: Column(
                  children: [
                    // display the user avata
                    const UserAvatar(),
                    const SizedBox(height: 16),
                    AppText(
                      (widget.user['username']) as String,
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: true,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Parent Account',
                      style: TextStyle(
                        color: const Color.fromARGB(210, 255, 255, 255),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // align the title to start-position of the parent
              // Accoun-Information title
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  'Account Information',
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: true,
                ),
              ),
              const SizedBox(height: 18),
              // buildInfoTile style the user Account-Information
              AccountInfoTile(
                icon: Icons.person_outline,
                title: (widget.user['username']) as String,
                value: 'Kunnarak',
                editLock: parentMyAccountScreenModel.isEditingLock,
                formKey: parentMyAccountScreenModel.formKey,
                isEditing: parentMyAccountScreenModel.editUsername,
                onCancelEditing: parentMyAccountScreenModel.getCancelEditing,
                onConfirmEditing: parentMyAccountScreenModel.handleEditing,
                onValidateInput: parentMyAccountScreenModel.validateField,
                onSavedEditing: parentMyAccountScreenModel.getEditInfo,
                onEditingInformation:() {
                   parentMyAccountScreenModel.clickEditingInformation('username');
                },
              ),
              AccountInfoTile(
                icon: Icons.email_outlined,
                title: 'Email',
                value: (widget.user['email']) as String,
                editLock: parentMyAccountScreenModel.isEditingLock,
                formKey: parentMyAccountScreenModel.formKey,
                isEditing: parentMyAccountScreenModel.editEmail,
                onCancelEditing: parentMyAccountScreenModel.getCancelEditing,
                onConfirmEditing: parentMyAccountScreenModel.handleEditing,
                onValidateInput: parentMyAccountScreenModel.validateField,
                onSavedEditing: parentMyAccountScreenModel.getEditInfo,
                onEditingInformation: () {
                  parentMyAccountScreenModel.clickEditingInformation('email');
                },
              ),
              AccountPasswordTile(
                icon: Icons.lock_outline,
                title: 'Password',
                isEditing: parentMyAccountScreenModel.editPassword,
                formKey: parentMyAccountScreenModel.formKey,
                editLock: parentMyAccountScreenModel.isEditingLock,
                onParentStateChange: changeObscureText,
                obscureText: obscureText,
                onCancelEditing: parentMyAccountScreenModel.getCancelEditing,
                onConfirmEditing: parentMyAccountScreenModel.handleEditing,
                onValidateInput: parentMyAccountScreenModel.validateField,
                onSavedEditing: parentMyAccountScreenModel.getEditInfo,
                onSavedConfirmPassword: parentMyAccountScreenModel.getConfirmPassword,
                onEditingInformation: () {
                  parentMyAccountScreenModel.clickEditingInformation('password');
                },
              ),
              AccountInfoTile(
                icon: Icons.phone_outlined,
                title: 'Phone Number',
                value: (widget.user['phone_number']) as String,
                editLock: parentMyAccountScreenModel.isEditingLock,
                formKey: parentMyAccountScreenModel.formKey,
                isEditing: parentMyAccountScreenModel.editPhoneNumber,
                onCancelEditing: parentMyAccountScreenModel.getCancelEditing,
                onConfirmEditing: parentMyAccountScreenModel.handleEditing,
                onValidateInput: parentMyAccountScreenModel.validateField,
                onSavedEditing: parentMyAccountScreenModel.getEditInfo,
                onEditingInformation: () {
                  parentMyAccountScreenModel.clickEditingInformation('phoneNumber');
                },
              ),
              const SizedBox(height: 10),
              // SizedBox 1#: force the child-element(button) size to fit the it dimension
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // logout user
                    logoutUser(widget.onRootScreenChange, 'login-screen');
                  },
                  icon: const Icon(Icons.logout),
                  label: const AppText(
                    'Logout',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: true,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}