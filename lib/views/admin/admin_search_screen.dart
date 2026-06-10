import 'package:flutter/material.dart';

class AdminSearchScreen extends StatefulWidget {
  const AdminSearchScreen({
    super.key,
    required this.onGetCurrentScreen,
  });

  final void Function(int screenIndex) onGetCurrentScreen;

  @override
  State<AdminSearchScreen> createState() => _AdminSearchScreenState();
}

class _AdminSearchScreenState extends State<AdminSearchScreen> {
  final List<_SearchMenuItem> menus = [
    _SearchMenuItem(
      title: 'parents',
      subtitle: 'Search student information',
      icon: Icons.family_restroom,
      screenIndex: 0,
    ),
    _SearchMenuItem(
      title: 'drivers',
      subtitle: 'Search driver information',
      icon: Icons.drive_eta,
      screenIndex: 1,
    ),
    _SearchMenuItem(
      title: 'chat',
      subtitle: 'Search parent information',
      icon: Icons.chat,
      screenIndex: 3,
    ),
    _SearchMenuItem(
      title: 'attendance',
      subtitle: 'Search bus information',
      icon: Icons.list,
      screenIndex: 4,
    ),
    _SearchMenuItem(
      title: 'Manage route',
      subtitle: 'Search bus information',
      icon: Icons.route,
      screenIndex: 5,
    ),
    _SearchMenuItem(
      title: 'my account',
      subtitle: 'Search bus information',
      icon: Icons.person,
      screenIndex: 6,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: menus.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            final menu = menus[index];

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                widget.onGetCurrentScreen(menu.screenIndex);
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        menu.icon,
                        size: 42,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        menu.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        menu.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
class _SearchMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final int screenIndex;

  _SearchMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.screenIndex,
  });
}