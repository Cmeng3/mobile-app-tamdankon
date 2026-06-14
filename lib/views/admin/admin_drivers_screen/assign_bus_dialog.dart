import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';

class AssignBusDialog extends StatefulWidget{
  const AssignBusDialog({
    super.key, 
    required this.onGetBuses,
    required this.onAssignDriverABus,
    required this.driverId,
    required this.driverBusId,
    required this.name
  });

    // on get all buses
    final Future<List<dynamic>> Function() onGetBuses;
    final void Function(int driverId, int driverBusId) onAssignDriverABus;
    final int driverId;
    final int driverBusId;
    final String name;




  @override
  State<AssignBusDialog> createState() => _AssignBusDialogState();
}

class _AssignBusDialogState extends State<AssignBusDialog> {
  late int? selectedBus = widget.driverBusId == 0 ? null : widget.driverBusId;
  //
  List<dynamic> buses = [];
  //
  bool isLoading = true;
  //
  void getAllBus() async{
    buses = await widget.onGetBuses();

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllBus();
  }

  @override
  Widget build(context) {
    return isLoading ? const Center(child: CircularProgressIndicator(),) :AlertDialog(
      title: Text(
        "Assign bus: ${widget.name}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 450,
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: buses.length,
                itemBuilder: (context, index) {
                  final bus = buses[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: RadioListTile<int>(
                      value: bus['id'] as int,
                      groupValue: selectedBus,
                      onChanged: (value) {
                        setState(() {
                          selectedBus = value!;
                        });
                      },
                      title: Text(
                        'bus ${bus['id']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: bus['driver_id'] != 0 ? AppText('already assign', color: Colors.grey,) : AppText('not assign', color: Colors.grey,),
                      secondary: bus['driver_id'] != 0? const CircleAvatar(
                        backgroundColor: Color.fromARGB(37, 76, 175, 80),
                        child: Icon(
                          color: Colors.green,
                          Icons.directions_bus,
                        ),
                      ) :  CircleAvatar(
                        backgroundColor: Color.fromARGB(37, 244, 67, 54),
                        child: Icon(
                          color: Colors.red,
                          Icons.directions_bus,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton.icon(
          onPressed: selectedBus == null
              ? null
              : () {
                  widget.onAssignDriverABus(widget.driverId, selectedBus!);
                  print(
                    "Assigned Bus: $selectedBus to this driver id: ${widget.driverId}",
                  );

                  Navigator.pop(context);
                },
          icon: const Icon(Icons.check),
          label: const Text("Assign"),
        ),
      ],
    );
  }
}