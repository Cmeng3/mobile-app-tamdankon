import 'package:flutter/material.dart';

class StudentInfoTile extends StatelessWidget {
  StudentInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String value;
  Widget? trailing;

  @override
  Widget build(context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}