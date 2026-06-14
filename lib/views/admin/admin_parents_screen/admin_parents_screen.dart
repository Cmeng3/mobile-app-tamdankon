import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/models/admin_parents_screen_model.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_parents_screen/create_parent_dialog.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_parents_screen/parent_detail_screen.dart';

class AdminParentsScreen extends StatefulWidget {
  const AdminParentsScreen({
    super.key, 
    required this.onTriggerSnackBar
  });

  final void Function(String message, Color color) onTriggerSnackBar;

  @override
  State<AdminParentsScreen> createState() => _AdminParentsScreenState();
}

class _AdminParentsScreenState extends State<AdminParentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  //
  void getStateChange(){
    setState(() {
      
    });
  }
  //
  late AdminParentsScreenModel adminParentsScreenModel = AdminParentsScreenModel(
    onScreenStateChange: getStateChange,
    onTriggerSnackBar: widget.onTriggerSnackBar,
  );
  
  @override
  void initState() {
    super.initState();
    adminParentsScreenModel.loadScreenInfo();
  }

  @override
  Widget build(BuildContext context) {
    return adminParentsScreenModel.isLoading? const Center(child: CircularProgressIndicator(),) : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              TextFormField(
                onChanged: adminParentsScreenModel.searchFilter,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search parent...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Create Parent Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to create parent screen
                    showDialog(context: context, builder: (context){
                      return CreateParentDialog(
                        formKey: adminParentsScreenModel.formKey,
                        onValidatedForm: adminParentsScreenModel.validateParentForm,
                        onCreateParentAccount: adminParentsScreenModel.createParentAccount,
                        onGetSave: adminParentsScreenModel.savingParentForm,
                        onGetAllBus: adminParentsScreenModel.getAllBus,
                      );
                    });
                  },
                  icon: const Icon(Icons.person_add),
                  label: const AppText(
                    'Create Parent Account',
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Parent List
              Expanded(
                child: ListView.builder(
                  itemCount: adminParentsScreenModel.currentParentsInfoList.length,
                  itemBuilder: (context, index) {
                    final parent = adminParentsScreenModel.currentParentsInfoList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            radius: 28,
                            child: Text(
                              'P${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: AppText(
                            parent['name'],
                            color: Colors.black,
                            fontWeight: true,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              AppText(
                                parent['phone_number'],
                                color: Colors.grey.shade700,
                                fontSize: 13,
                              ),
                              AppText(
                                'children: ${parent['student_name']}',
                                color: Colors.grey.shade700,
                                fontSize: 13,
                              ),
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
                                   showDialog(context: context, builder: (context) {
                                    return ParentDetailScreen(parent: parent,);
                                  });
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // Open parent detail
                            showDialog(context: context, builder: (context) {
                              return ParentDetailScreen(parent: parent,);
                            });
                          },
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