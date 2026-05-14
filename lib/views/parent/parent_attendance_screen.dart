import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_badge.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/boolean_badge.dart';
import 'package:tamdan_kon_mobile_flutter/components/field_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/style_title_text_logo.dart';

class ParentAttendanceScreen extends StatefulWidget{
  const ParentAttendanceScreen({super.key});
  @override
  State<ParentAttendanceScreen> createState() => _ParentAttendanceScreenState();
}

class _ParentAttendanceScreenState extends State<ParentAttendanceScreen> {
  final List<Map<String, dynamic>> attendanceList = [
    {
      "date": "12 May 2026",
      "status": "Present",
    },
    {
      "date": "11 May 2026",
      "status": "Absent",
    },
    {
      "date": "10 May 2026",
      "status": "Present",
    },
    {
      "date": "09 May 2026",
      "status": "Absent",
    },
  ];
  @override
  Widget build(context) {
    return SafeArea(
      child: Column(
        children: [
          // Container #1: display the form-card
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(20, 0, 0, 0),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            //
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1#: display the title of permission-form
                  // we will out-source this title part later
                  StyleTitleTextLogo('Attendance Request'),
                  const SizedBox(height: 24),
                  // display the label
                  FieldText('Reason', isRequired: true),
                  const SizedBox(height: 8),
                  // Reason-field part
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Tell us the reason...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // styling the submit button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        // elevation attribute, will make button elevated the shadow when press
                        elevation: 0,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: AppText(
                        'Submit Request',
                        color: Colors.white,
                        fontWeight: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Attendance header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            // Row 2#: display the Attendance header
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  'Attendance History',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: true,
                ),
                // Container #2: badge-style to show length of attendance record
                AppBadge(
                  '${attendanceList.length} Records', 
                  color: Colors.blue, 
                  shadeColor: Colors.blue.shade50
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Expanded 1#: styling the student-lists attendance
          // purpose: to take up much space as it can
          // Attendance-Lists part
          Expanded(
            child: ListView.builder(
              // insert the padding for children inside ListView
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: attendanceList.length,
              //
              itemBuilder: (context, index) {
                // store each attendance record from attendanceList
                final attendance = attendanceList[index];
                // store the bool value, from the comparision expression
                final bool isPresent =
                    attendance['status'] == 'Present';
                // Container 3#: display each element of attendance record
                return Container(
                  // insert the margin below each attendance record
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(20, 0, 0, 0),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  // Row 3#: styling student-attendance recored list
                  child: Row(
                    children: [
                      // Container 4# : styling the Status-Icon
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isPresent
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      child: Icon(
                          isPresent
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: isPresent
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Expanded 2#: display the attendance-date and attendance summary
                      // purpose: to prvent column from taking much space horizentally, that cuase render error
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              attendance['date'],
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: true,
                            ),
                            const SizedBox(height: 6),
                            AppText(
                              isPresent
                                  ? 'Student attended school'
                                  : 'Student was absent',
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ],
                        ),
                      ),
                      // Container 5#: display the status badge
                      BooleanBadge(
                        attendance['status'],
                        isTrue: attendance['status'] == 'Present',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}