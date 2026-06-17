import 'package:flutter/material.dart';

class CreateBusDialog extends StatefulWidget {
  const CreateBusDialog({
    super.key, 
    required this.onCreateBus
  });

  //
  final void Function(String busName) onCreateBus; 

  @override
  State<CreateBusDialog> createState() => _CreateBusDialogState();
}

class _CreateBusDialogState extends State<CreateBusDialog> {
  final TextEditingController busNameController = TextEditingController();

  String? selectedDriver;

  final List<String> drivers = ["John Doe", "David Smith", "Michael Lee"];

  @override
  Widget build(context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.directions_bus, color: Colors.blue),
          SizedBox(width: 10),
          Text("Create Bus"),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Bus Number
              TextField(
                controller: busNameController,
                decoration: InputDecoration(
                  labelText: "Bus Name",
                  hintText: "Enter bus name",
                  prefixIcon: const Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Driver Dropdown
              Image(image: AssetImage('assets/images/bus.png'), width: 60),
            ],
          ),
        ),
      ),
      actions: [
        /// Cancel Button
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        /// Create Button
        ElevatedButton.icon(
          onPressed: () {
            widget.onCreateBus(busNameController.text);

            Navigator.pop(context);
          },
          icon: const Icon(Icons.add),
          label: const Text("Create"),
        ),
      ],
    );
  }
}
