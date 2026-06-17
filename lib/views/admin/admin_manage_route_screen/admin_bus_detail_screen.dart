import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_manage_route_screen/route_map_modal.dart';

class AdminBusDetailScreen extends StatefulWidget {
  final String busNumber;
  final String driverName;

  const AdminBusDetailScreen({
    super.key,
    required this.busNumber,
    required this.driverName,
  });

  @override
  State<AdminBusDetailScreen> createState() =>
      _AdminBusDetailScreenState();
}

class _AdminBusDetailScreenState extends State<AdminBusDetailScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> students = [
    {"name": "John Smith", "grade": "Grade 10", "pickup": "Street 2004"},
    {"name": "Emma Watson", "grade": "Grade 8", "pickup": "Russian Blvd"},
    {"name": "David Lee", "grade": "Grade 12", "pickup": "Tuol Kork"},
    {"name": "Sophia Kim", "grade": "Grade 9", "pickup": "Sen Sok"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: AppText(widget.busNumber, fontSize: 18, fontWeight: true,), 
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color.fromARGB(255, 31, 14, 215),
              const Color.fromARGB(255, 3, 3, 80),
            ])
          ),
        ),
        centerTitle: true
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context, 
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return Text('hello world');
            });
        },
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 3, 3, 80),
        icon: const Icon(Icons.map),
        label: const Text("View Map"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Bus Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.directions_bus,
                      size: 40,
                      color: Colors.blue,
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            widget.busNumber,
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: true,
                          ),
                          AppText(
                            "Driver: ${widget.driverName}",
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Search Student
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Student...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: AppText(
                "Assigned Students",
                color: Colors.black,
                fontSize: 18,
                fontWeight: true,
              ),
            ),

            const SizedBox(height: 12),

            /// Student List
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(student["name"]![0])),
                      title: Text(student["name"]!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student["grade"]!),
                          Text("Pickup: ${student["pickup"]}"),
                        ],
                      ),
              trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.visibility),
                                SizedBox(width: 8),
                                Text('View Detail'),
                              ],
                            ),
                            onTap: () {
                              
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
