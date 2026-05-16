import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_badge.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/boolean_badge.dart';
import 'package:tamdan_kon_mobile_flutter/components/field_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/logo_badge.dart';
import 'package:tamdan_kon_mobile_flutter/components/style_title_text_logo.dart';
import 'package:tamdan_kon_mobile_flutter/models/parent_attendance_screen_model.dart';

class ParentAttendanceScreen extends StatefulWidget {
  const ParentAttendanceScreen({super.key, required this.parentId});

  final int parentId;
  @override
  State<ParentAttendanceScreen> createState() => _ParentAttendanceScreenState();
}

class _ParentAttendanceScreenState extends State<ParentAttendanceScreen> {
  // create a formkey to take control over form-state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // elevation method
  // purpose: allow children class or methods to trigger parent-attendance-screen state change
  void updateParentState() {
    setState(() {});
  }
  // ParentAttendanceScreenModel control the logic and data of parent-attendance-screen
  late ParentAttendanceScreenModel parentAttendanceScreenModel =
      ParentAttendanceScreenModel(
        parentId: widget.parentId,
        formKey: _formKey,
        onUpdateParentState: updateParentState,
      );
  @override
  void initState() {
    super.initState();
    // starting api-call to get all student-attendance records
    parentAttendanceScreenModel.getStudentAttendances();
  }

  @override
  void dispose() {
    // if it not null, let cancel it out
    if(parentAttendanceScreenModel.requestStatusTimer != null) {
      parentAttendanceScreenModel.requestStatusTimer!.cancel();
      parentAttendanceScreenModel.todayAttendanceTimer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(context) {
    return parentAttendanceScreenModel.isLoading
    ? const Center(child: CircularProgressIndicator())
    : SafeArea(
      // Column 1#: layout all screen-element widgets
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
          key: _formKey,
          // Column 2#: display the Attendance-Request title and (form-field or Status sign)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1#: display the title of permission-form
              // we will out-source this title part later
              StyleTitleTextLogo('Attendance Request'),
              //
              const SizedBox(height: 24),
              // Column 3#: display form-field part and button
          parentAttendanceScreenModel.attendanceRequestStatus ==
                  'no_request'
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    validator:
                        parentAttendanceScreenModel.validateReason,
                    onSaved:
                        parentAttendanceScreenModel
                            .getAttendanceReason,
                  ),
                  const SizedBox(height: 20),
                  // styling the submit button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          parentAttendanceScreenModel.handleSubmit,
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
              )
              : (parentAttendanceScreenModel
                          .attendanceRequestStatus ==
                      'pending'
                  ? const Center(
                    child: LogoBadge(
                      color: Colors.orange,
                      shadeColor: Color.fromARGB(25, 255, 152, 0),
                      icon: Icons.pending,
                    ),
                  )
                  : const Center(
                    child: LogoBadge(
                      color: Colors.green,
                      shadeColor: Color.fromARGB(25, 76, 175, 80),
                      icon: Icons.check_circle,
                    ),
                  )),
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
                  '${parentAttendanceScreenModel.attendancesList.length} Records',
                  color: Colors.blue,
                  shadeColor: Colors.blue.shade50,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Expanded 1#: styling the student-lists attendance
          // purpose: to take up much space as it can
          // Attendance-Lists part
          Expanded(
            child:
              // If attendance-records is empty, let display the message 'No Records'
              // else display the list of record
                parentAttendanceScreenModel.attendancesList.isEmpty
                    ? const Center(
                      child: AppText(
                        'No records',
                        color: Color.fromARGB(50, 0, 0, 0),
                        fontWeight: true,
                      ),
                    )
            : ListView.builder(
              // insert the padding for children inside ListView
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount:
                  parentAttendanceScreenModel
                      .attendancesList
                      .length,
              //
              itemBuilder: (context, index) {
                // store each attendance record from attendanceList
                final attendance =
                    parentAttendanceScreenModel
                        .attendancesList[index];
                // store the bool value, from the comparision expression
                final bool isPresent = attendance['is_present'];
                // extract and create the right format of date-time using intl library
                DateTime dateTime = DateTime.parse(
                  attendance['created_at'],
                );
                String formatted = DateFormat(
                  'd MMMM yyyy',
                ).format(dateTime);
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
                          color:
                              isPresent
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          isPresent
                              ? Icons.check_circle
                              : Icons.cancel,
                          color:
                              isPresent ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Expanded 2#: display the attendance-date and attendance summary
                      // purpose: to prvent column from taking much space horizentally, that cuase render error
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            AppText(
                              formatted,
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
                        // attendance['status'],
                        'present',
                        isTrue: isPresent,
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
