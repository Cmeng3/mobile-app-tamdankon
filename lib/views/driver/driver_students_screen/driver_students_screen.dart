import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/models/driver_students_screen_model.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_students_screen/driver_students_detail_screen.dart';

class DriverStudentsScreen extends StatefulWidget {
  const DriverStudentsScreen({
    super.key,
    required this.driverId,
    required this.triggerDriverSnackBar,
  });

  //
  final int driverId;
  //
  final void Function(String message, Color color) triggerDriverSnackBar;
  @override
  State<DriverStudentsScreen> createState() => _DriverStudentsScreenState();
}

class _DriverStudentsScreenState extends State<DriverStudentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  //
  void getUpdateScreenState() {
    setState(() {});
  }

  // instaintiate driverStudentsScreenModel that store all screen logics and data
  late DriverStudentsScreenModel driverStudentsScreenModel =
      DriverStudentsScreenModel(
        onScreenStateChange: getUpdateScreenState,
        driverId: widget.driverId,
        triggerDriverSnackBar: widget.triggerDriverSnackBar,
      );

  @override
  initState() {
    super.initState();
    driverStudentsScreenModel.loadingScreenInfo();
  }

  @override
  Widget build(BuildContext context) {
    return driverStudentsScreenModel.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            // Column 1#: layout all driver-students-screen element
            child: Column(
              children: [
                // Row 1#: display the title of the screen
                Row(
                  children: [
                    const Icon(Icons.people, size: 30),
                    const SizedBox(width: 10),
                    AppText(
                      'My Students',
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // TextFormField, hold the search-bar
                TextFormField(
                  onChanged: driverStudentsScreenModel.getSearchAndFilter,
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search student...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Container 1#: display the second screen-title, which about the numbers of student on that bus
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.school, color: Colors.blue, size: 30),
                      const SizedBox(width: 10),
                      Text(
                        "${driverStudentsScreenModel.filterStudentsList.length} Students Assigned",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Expanded 1#: let the last element in Column 1# take up all available space
                //and ListView.builder: List all the students in form of Card
                Expanded(
                  child: ListView.builder(
                    itemCount: driverStudentsScreenModel.filterStudentsList.length,
                    itemBuilder: (context, index) {
                      final student = driverStudentsScreenModel.filterStudentsList[index];
                      // Card : hold each student-info in form of card
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async{
                            // Navigate to student detail screen
                            showDialog(context: context, builder: (context) {
                              // we will insert the essential parameter to this screen soon
                              return DriverStudentsDetailScreen(
                                studentName: student['name'],
                                studentId: student['id'],
                                gender: student['sex'],
                                parentName: student['parent_name'],
                                phoneNumber: student['phone_number'],
                                isLocationSet: student['latlng'] != null,
                                locationSettings: driverStudentsScreenModel.locationSetting,
                                onUpdateLocation: driverStudentsScreenModel.updateStudentLocation,
                                onGetLatestStudent: driverStudentsScreenModel.getLatestStudenInfo,
                              );
                            });
                            
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            // Row 2#: layout each student info in the Card
                            child: Row(
                              children: [
                                // CircleAvatar: display student's name first letter
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(
                                    student["name"][0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Expanded 2#: let the Column(student name and gender) wrape inside take all remaining space
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student["name"],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      student['sex'] == 'M'
                                          ? AppText('Male', color: Colors.black)
                                          : AppText(
                                            'Female',
                                            color: Colors.black,
                                          ),
                                    ],
                                  ),
                                ),
                                // Column 2#: layout the student-location icon
                                Column(
                                  children: [
                                    Icon(
                                      Icons.pin_drop,
                                      color:
                                          student["latlng"] != null
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student["latlng"] != null
                                          ? "already set"
                                          : "No data",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            student["latlng"] != null
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_ios, size: 16),
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
