import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/chat_bubble.dart';
import 'package:tamdan_kon_mobile_flutter/composable/time_ago.dart';
import 'package:tamdan_kon_mobile_flutter/models/admin_chat_detial_screen_model.dart';

class ChatDetailScreen extends StatefulWidget{
  const ChatDetailScreen({
    super.key, 
    required this.adminId,
    required this.chatId,
  });

  //
  final int adminId;
  //
  final int chatId;


  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  // textFormField controller
  final TextEditingController messageController = TextEditingController();
  // formkey to manage the chat-input form-state
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // allow child class or method, trigger update on parent-chat-screen
  void updateDriverState(){
    setState(() {});
  }
  //
  void triggerDriverSnackBar(String message, Color color) {
    final snackBar = SnackBar(
            backgroundColor: color,
            content: Center(child: AppText(message)),
          );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  // parentChatScreenModel handle parent-chat-screen logic and data
  late AdminChatDetialScreenModel adminChatDetailScreenModel = AdminChatDetialScreenModel(
    adminId: widget.adminId,
    chatId: widget.chatId,
    onTriggerSnackbar: triggerDriverSnackBar,
    onUpdateScreenState: updateDriverState
  );

  @override
  void initState() {
    super.initState();
    adminChatDetailScreenModel.getMessages();
  }

  @override
  void dispose() {
      adminChatDetailScreenModel.getChatMessagesTimer!.cancel();
    super.dispose();
  }
  @override
  Widget build(context) {
    return adminChatDetailScreenModel.isLoading? Scaffold(body: const Center(child: CircularProgressIndicator())) :Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText('Bus #${widget.chatId} - Group'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color.fromARGB(255, 31, 14, 215),
              const Color.fromARGB(255, 3, 3, 80),
            ])
          ),
        ),
      ),
      body: SafeArea(
        // Container 1#: coloring the whole background to almost perfect-white
        child: Container(
          color: const Color.fromARGB(255, 245, 245, 245),
          // Column 1#: laout the chat-section and chat-input
          child: Column(
            children: [
              // Expanded 1# (ListView.builder()): chat-section
              // purpose: layout all chat-bubble message
              Expanded(
                child: adminChatDetailScreenModel.messages.isEmpty? const Center(child: AppText('No Message', color: Color.fromARGB(100, 0, 0, 0)),) : ListView.builder(
                  // display the latest element in list first, and position the last-view at the button of list-item
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: adminChatDetailScreenModel.messages.length,
                  itemBuilder: (context, index) {
                    final message = adminChatDetailScreenModel.messages[index];
                    return ChatBubble(
                      name: message['name'],
                      message: message['message'],
                      // we actually externally define the Datetime now instead of instantiat in function body
                      // purpose: to make the parent-chat-screen mark their state as dirty everytime, data-polling is complete
                      // that the reason we explicity define the now DateTime to make it change everytime
                      time: timeAgo(message['time'], adminChatDetailScreenModel.now!),
                      isMe: message['isMe'],
                    );
                  },
                ),
              ),
              // Container 2#: is the chat-input part
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black12,
                    )
                  ],
                ),
                // Row 1#: layout the input-field and send-button
                child: Row(
                  children: [
                    // Expanded 2#: input-field part
                    Expanded(
                      child: Form(
                        key: _formkey,
                        child: TextFormField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          onSaved: (String? msg) {
                            adminChatDetailScreenModel.storeMessage(msg, messageController);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // CircleAvata: disp
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        onPressed: () {
                          _formkey.currentState!.save();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}