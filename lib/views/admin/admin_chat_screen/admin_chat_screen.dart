import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/models/admin_chat_screen_model.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_chat_screen/chat_detail_screen.dart';

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({
    super.key, 
    required this.adminId,
    required this.onTriggerSnackBar
  });

  //
  final int adminId;
  //
  final void Function(String message, Color color) onTriggerSnackBar;

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final TextEditingController _searchController =
      TextEditingController();
  //
  void getScreenStateChange() {
    setState(() {});
  }
  //
  late AdminChatScreenModel adminChatScreenModel = AdminChatScreenModel(
    adminId: widget.adminId,
    onTriggerSnackBar: widget.onTriggerSnackBar, 
    onScreenStateChange: getScreenStateChange,
  );

  @override
  void initState() {
    super.initState();
    adminChatScreenModel.loadScreenInfo();
  }

  @override
  void dispose() {
    adminChatScreenModel.getGroupChatTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return adminChatScreenModel.isLoading? const Center(child: CircularProgressIndicator()) : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 8),

              /// Search Bar
              TextFormField(
                onChanged: adminChatScreenModel.searchFilter,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search chat groups',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Group List
              Expanded(
                child: ListView.separated(
                  itemCount: adminChatScreenModel.currentGroupList.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final group = adminChatScreenModel.currentGroupList[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Navigate to chat detail screen
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ChatDetailScreen(adminId: widget.adminId, chatId: group['chatId']);
                        }));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(35, 0, 0, 0),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor:
                                  Colors.blue.shade50,
                              child: Icon(
                                Icons.groups,
                                color: Colors.blue,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    group['group_name'],
                                    color: Colors.black,
                                    fontWeight: true,
                                  ),
                                  // const SizedBox(height: 4),
                                  // AppText(
                                  //   group['message'],
                                  //   color: Colors.grey,
                                  //   fontSize: 13,
                                  // ),
                                ],
                              ),
                            ),

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                // AppText(
                                //   group['time'],
                                //   fontSize: 12,
                                //   color: Colors.grey,
                                // ),
                                Icon(Icons.arrow_right),
                              ],
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