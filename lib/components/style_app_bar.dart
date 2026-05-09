import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_logo_avatar.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class StyleAppBar extends StatelessWidget implements PreferredSizeWidget{
  const StyleAppBar({
    super.key, 
    required this.username, 
    required this.role
  });

  // user information needed for display in app-bar
  final String username;
  final String role;
  @override
  Widget build(context) {
    return AppBar(
        toolbarHeight: 100,
        // we use container in flexibleSpace for coloring purpose
        // It allow us to do LinearGradient coloring
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
              const Color.fromARGB(255, 31, 14, 215),
              const Color.fromARGB(255, 3, 3, 80),
              ],
            )
          ),
        ),
        // in title part we use row widget, for displaying 2 main things:
        // - app-logo avatar
        // - username
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogoAvatar(
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Welcome',
                  fontWeight: true,
                   color: Color.fromARGB(255, 119, 119, 223),
                ),
                AppText(
                  username,
                  fontWeight: true,
                ),
              ],
            )
          ],
        ),
        // in action here, we styling a badge for indicate of user role
        actions: [
          // designing a badge that showing the user's role
          Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue.shade200,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue.shade50,
                  ),
                  child: AppText(
                    role,
                    fontSize: 12,
                    fontWeight: true,
                    color: Colors.blue.shade700
                  ),
                )
        ],
      );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(70);
}