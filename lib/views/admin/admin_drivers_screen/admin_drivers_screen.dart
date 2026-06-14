import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/models/admin_drivers_screen_model.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_drivers_screen/assign_bus_dialog.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_drivers_screen/create_driver_dialog.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_drivers_screen/driver_detial_screen.dart';

class AdminDriversScreen extends StatefulWidget {
  const AdminDriversScreen({
    super.key, 
    required this.onTriggerSnackBar
  });

  //
  final void Function(String message, Color color) onTriggerSnackBar;

  @override
  State<AdminDriversScreen> createState() => _AdminDriverScreenState();
}

class _AdminDriverScreenState extends State<AdminDriversScreen> {
  final TextEditingController _searchController = TextEditingController();

  // set the screen-state
  void getStateChange(){
    setState(() {});
  }

  //
  late AdminDriversScreenModel adminDriversScreenModel = AdminDriversScreenModel(
    onScreenStateChange: getStateChange,
    onTriggerSnackBar: widget.onTriggerSnackBar,
  );


  @override
  void initState() {
    super.initState();
    adminDriversScreenModel.loadScreenInfo();
  }

  @override
  Widget build(BuildContext context) {
    return adminDriversScreenModel.isLoading? const Center(child: CircularProgressIndicator()) : Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Search Bar
            TextFormField(
              onChanged: adminDriversScreenModel.searchFilter,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search driver...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Create Driver Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(context: context, builder: (context){
                    return CreateDriverDialog(
                      onValidateForm: adminDriversScreenModel.validateDriverForm,
                      onSavedField: adminDriversScreenModel.getDriverInfoSave,
                      onGetBuses: adminDriversScreenModel.getBuses,
                      onCreateDriver: adminDriversScreenModel.createDriverAccount,
                    );
                  });
                  // Open Create Driver Dialog
                },
                icon: const Icon(Icons.person_add),
                label: const AppText('Create Driver Account'),
              ),
            ),

            const SizedBox(height: 16),

            /// Driver List
            Expanded(
              child: ListView.builder(
                itemCount: adminDriversScreenModel.currentDriverList.length,
                itemBuilder: (context, index) {
                  final driver = adminDriversScreenModel.currentDriverList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        showDialog(context: context, builder: (context) {
                          return DriverDetialScreen(driver: driver);
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              driver['name'][0],
                            ),
                          ),
                      
                          title: AppText(
                            driver['name'],
                            color: Colors.black,
                            fontWeight: true,
                          ),
                      
                          subtitle: AppText(driver['phone'], color: Colors.black),
                      
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Bus Status
                              Tooltip(
                                message: driver['hasBus']
                                    ? "Bus Assigned"
                                    : "No Bus Assigned",
                                child: Icon(
                                  Icons.directions_bus,
                                  color: driver['hasBus']
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                      
                              const SizedBox(width: 8),
                      
                              /// Menu
                              PopupMenuButton<String>(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: () {
                                      showDialog(context: context, builder: (context){
                                        return DriverDetialScreen(driver: driver);
                                      });
                                    },
                                    value: 'view',
                                    child: Row(
                                      children: [
                                        Icon(Icons.visibility),
                                        SizedBox(width: 8),
                                        Text('View Detail'),
                                      ],
                                    ),
                                  ),
                                   PopupMenuItem(
                                    onTap: () {
                                      showDialog(context: context, builder: (context) {
                                        return AssignBusDialog(
                                          onGetBuses: adminDriversScreenModel.getBuses,
                                          onAssignDriverABus: adminDriversScreenModel.assignDriverABus,
                                          name: driver['name'],
                                          driverId: driver['id'],
                                          driverBusId: driver['busId'],
                                        );
                                      });
                                    },
                                    value: 'assign_bus',
                                    child: Row(
                                      children: [
                                        Icon(Icons.directions_bus),
                                        SizedBox(width: 8),
                                        Text('Assign Bus'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}