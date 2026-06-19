import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/models/admin_attendance_screen_model.dart';
import 'package:intl/intl.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_attendance_screen/attendance_request_detail.dart';

class AdminAttendanceScreen extends StatefulWidget {
  const AdminAttendanceScreen({super.key, required this.onTriggerSnackBar});

  //
  final void Function(String message, Color color) onTriggerSnackBar;

  @override
  State<AdminAttendanceScreen> createState() => _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState extends State<AdminAttendanceScreen> {
  final List<Map<String, dynamic>> attendanceRequests = [
    {"student": "John Smith", "bus": "BUS-01", "time": "07:15 AM"},
    {"student": "Emma Johnson", "bus": "BUS-02", "time": "07:28 AM"},
    {"student": "Michael Brown", "bus": "BUS-03", "time": "07:35 AM"},
  ];
  //
  void getScreenStateChange() {
    setState(() {});
  }

  //
  late AdminAttendanceScreenModel adminAttendanceScreenModel =
      AdminAttendanceScreenModel(
        onScreenStateChange: getScreenStateChange,
        onTriggerSnackBar: widget.onTriggerSnackBar,
      );

  @override
  void initState() {
    super.initState();
    adminAttendanceScreenModel.loadingScreenInfo();
  }

  @override
  Widget build(BuildContext context) {
    return adminAttendanceScreenModel.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 3, 3, 80),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        "Attendance Requests",
                        fontSize: 18,
                        fontWeight: true,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        "${adminAttendanceScreenModel.attendanceRequests.length} Requests Today",
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// Search Field
                TextFormField(
                  onChanged: adminAttendanceScreenModel.searchFilter,
                  decoration: InputDecoration(
                    hintText: "Search student...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// List
                Expanded(
                  child:
                      adminAttendanceScreenModel.attendanceRequests.isEmpty
                          ? const Center(
                            child: AppText(
                              'No request today!',
                              color: Color.fromARGB(100, 0, 0, 0),
                            ),
                          )
                          : ListView.builder(
                            itemCount:
                                adminAttendanceScreenModel
                                    .currentAttendanceRequests
                                    .length,
                            itemBuilder: (context, index) {
                              final request =
                                  adminAttendanceScreenModel
                                      .currentAttendanceRequests[index];

                              return InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return AttendanceRequestDetail(
                                        requestDetail: request,
                                      );
                                    },
                                  );
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),

                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.blue,
                                      ),
                                    ),

                                    title: AppText(
                                      request["student"],
                                      color: Colors.black,
                                      fontWeight: true,
                                    ),

                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        AppText(
                                          "Bus: ${request["bus_id"]}",
                                          color: Colors.grey,
                                        ),
                                        AppText(
                                          "Requested: ${DateFormat('hh:mm a').format(DateTime.parse(request["created_at"]))}",
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),

                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// Approve
                                        IconButton(
                                          onPressed: () async{
                                            await adminAttendanceScreenModel.approvedAttendanceRequest(request['student_id']);
                                          },
                                          style: IconButton.styleFrom(
                                            backgroundColor:
                                                Colors.green.shade50,
                                          ),
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.green,
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
              ],
            ),
          ),
        );
  }
}
