import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_badge.dart';
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
          if(role == 'parent') AppBadge(
            role, 
            color: Colors.blue, 
            shadeColor: Colors.blue.shade50
          )
          // designing a badge that showing the user's role
          else if(role == 'driver') AppBadge(
            role, 
            color: const Color.fromARGB(255, 82, 187, 85), 
            shadeColor: const Color.fromARGB(135, 76, 175, 80)
          )
          else AppBadge(
            role, 
            color: const Color.fromARGB(255, 255, 255, 0), 
            shadeColor: const Color.fromARGB(135, 255, 255, 0)
          )
        ],
      );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(70);
}