import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class ParentDetailScreen extends StatelessWidget {
  const ParentDetailScreen({
    super.key, 
    required this.parent
  });

  final Map<String, dynamic> parent;

  @override
  Widget build(context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Drag Handle
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            /// Student Avatar
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 12),

            AppText(
              parent['name'],
              color: Colors.black,
              fontSize: 22,
              fontWeight: true,
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView(
                children: [
                  _infoTile(
                    icon: Icons.email,
                    title: "email",
                    value: parent['email'],
                  ),

                  _infoTile(
                    icon: Icons.location_on_outlined,
                    title: "Pickup Location",
                    value: parent['location'] ?? 'no data',
                  ),

                  _infoTile(
                    icon: Icons.elevator,
                    title: "children",
                    value: parent['student_name'],
                  ),

                  _infoTile(
                    icon: Icons.bus_alert,
                    title: "bus number",
                    value: parent['bus_number'].toString(),
                  ),

                  _infoTile(
                    icon: Icons.phone,
                    title: "Phone Number",
                    value: parent['phone_number'],
                  ),
                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                label: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
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
    );
  }