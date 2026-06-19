import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/models/admin_manage_route_screen_model.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_manage_route_screen/create_bus_dialog.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_manage_route_screen/route_map_modal.dart';

class AdminManageRouteScreen extends StatefulWidget {
  const AdminManageRouteScreen({
    super.key, 
    required this.onTriggerSnackBar,
  });

  //
  final void Function(String message, Color color) onTriggerSnackBar;

  @override
  State<AdminManageRouteScreen> createState() => _AdminManageRouteScreenState();
}

class _AdminManageRouteScreenState extends State<AdminManageRouteScreen> {
  final TextEditingController searchController = TextEditingController();

  // 
  void getScreenStateChange() {
    setState(() {});
  }
  // screen model, that hold all logic and property
  late AdminManageRouteScreenModel adminManageRouteScreenModel = AdminManageRouteScreenModel(
    onScreenStateChange: getScreenStateChange,
    onTriggerSnackBar: widget.onTriggerSnackBar,
  );

  @override
  void initState() {
    super.initState();
    adminManageRouteScreenModel.loadScreenInfo();
  }

  @override
  void dispose() {
    adminManageRouteScreenModel.getBusesInfoTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return adminManageRouteScreenModel.isLoading? const Center(child: CircularProgressIndicator()) : Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Search Bar
            TextFormField(
              onChanged: adminManageRouteScreenModel.searchFilter,
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Bus...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Create Bus Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Show Create Bus Dialog
                  showDialog(context: context, builder: (context){
                    return CreateBusDialog(
                      onCreateBus: adminManageRouteScreenModel.createBus,
                    );
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text("Create Bus"),
              ),
            ),

            const SizedBox(height: 20),

            /// Bus List
            Expanded(
              child: ListView.builder(
                itemCount: adminManageRouteScreenModel.currentBusList.length,
                itemBuilder: (context, index) {
                  final bus = adminManageRouteScreenModel.currentBusList[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          /// Bus Info
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.directions_bus,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),

                              const SizedBox(width: 15),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'Bus: ${bus['id']}',
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: true,
                                    ),
                                    const SizedBox(height: 4),
                                    AppText(
                                      "Driver: ${bus['driver']}",
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      bus['status'] == 'Active'
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: AppText(
                                  bus['status'],
                                  color:
                                      bus['status'] == 'Active'
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// View Route Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                 showModalBottomSheet(
                                  context: context, 
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (context){
                                    return RouteMapModal(
                                      busList: adminManageRouteScreenModel.busList,
                                      driverName: bus['driver'],
                                      busId: bus['id'],
                                      onGetStudentsOnBus: adminManageRouteScreenModel.getAllStudentOnBus,
                                      onAssignStudentNewBus: adminManageRouteScreenModel.updateStudentABus,
                                    );
                                  });
                                // Navigate to route details
                              },
                              icon: const Icon(Icons.map),
                              label: const Text("View Route"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
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
