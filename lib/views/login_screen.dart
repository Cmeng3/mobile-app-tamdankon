import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_logo_avatar.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/models/login_model.dart';
import 'package:tamdan_kon_mobile_flutter/components/field_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onRootScreenChange});

  // onRootScreenChange method, design to take a root-app screen switcher's call-back function
  // that be able to trigger it root-app setState() to change to specific main-screen
  final void Function(String currentRootScreen) onRootScreenChange;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // defining _formKey, which is used to control the form-state and trigger TextFormField call-back function
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // obscureText property, design for managing the visibility of the password input text
  bool obscureText = true;
  bool isLoading = false;
  // loginStateChange() method design for elevator parttern
  // that allow children(form-model) to trigger it parents widget state(form-screen)
  void loginStateChange() {
    setState(() {
      isLoading = !isLoading;
    });
  }
  // getSnackBar() method design for it children to trigger the snackbar in parent-screen
  // we will styling this snack-bar to show error in the need commit
  void getSnackBar(String error) {
    final snackBar = SnackBar(
            content: Text(error),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  // loginForm is the instance of LoginForm class, which is the model of this login-screen
  // it encapsulate every method and feilds that login-screen used and need
  late LoginModel loginForm = LoginModel(
    formKey: _formKey,
    onLoginStateChange: loginStateChange,
    onTriggerSnackBar: getSnackBar,
    onRootScreenChange: widget.onRootScreenChange,
  );

  @override
  Widget build(context) {
    return Scaffold(
      // Container #1: coloring the background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 3, 3, 80),
              const Color.fromARGB(255, 31, 14, 215),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // Center : taking-up the whole screen space and align the child to the center of screen
        child: Center(
          // Column #1 : align app-logo-avatar, app-text, and form together horizentally
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App-Logo_Avata
              AppLogoAvatar(),
              const SizedBox(height: 20),
              // Display the specific screen name in AppText()
              const AppText('Login', fontWeight: true, fontSize: 24),
              // Container #2 : border styling, padding, margin the contents inside and align the form text field together
              Container(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 50),
                margin: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Form(
                  key: _formKey,
                  // Column #2 : list the form-field elements together horizentally
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // display the field-text
                      // isRequired property is managing styling the text of the field that is required
                      FieldText('username', isRequired: true),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Enter Username'),
                        validator: loginForm.validateUsername,
                        onSaved: loginForm.getUsername,
                      ),
                      const SizedBox(height: 10),
                      FieldText('password', isRequired: true),
                      TextFormField(
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(Icons.visibility),
                          ),
                        ),
                        validator: loginForm.validatePassword,
                        onSaved: loginForm.getPassword,
                      ),
                      const SizedBox(height: 20),
                      isLoading
                          ? const Center(
                            child: CircularProgressIndicator(value: 10),
                          )
                          : ElevatedButton(
                            onPressed: loginForm.submitHandler,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('Submit'),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
