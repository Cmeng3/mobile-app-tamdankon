import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/chat_bubble.dart';
import 'package:tamdan_kon_mobile_flutter/composable/time_ago.dart';
import 'package:tamdan_kon_mobile_flutter/models/parent_chat_screen_model.dart';

class ParentChatScreen extends StatefulWidget{
  const ParentChatScreen({
    super.key, 
    required this.parentId,
    required this.onTriggerParentSnackbar
  });

  // get the parentId
  final int parentId;
  // get the parent snackbar tiggering method
  final void Function(String message, Color color) onTriggerParentSnackbar;

  @override
  State<ParentChatScreen> createState() => _ParentChatScreenState();
}

class _ParentChatScreenState extends State<ParentChatScreen> {
  // textFormField controller
  final TextEditingController messageController = TextEditingController();
  // formkey to manage the chat-input form-state
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // allow child class or method, trigger update on parent-chat-screen
  void updateParentState(){
    setState(() {});
  }
  // parentChatScreenModel handle parent-chat-screen logic and data
  late ParentChatScreenModel parentChatScreenModel = ParentChatScreenModel(
    parentId: widget.parentId,
    onUpdateParentState: updateParentState,
    onTriggerParentSnackbar: widget.onTriggerParentSnackbar
  );
  
  @override
  void initState() {
    super.initState();
    parentChatScreenModel.getMessages();
  }

  @override
  void dispose() {
    
      parentChatScreenModel.getChatMessagesTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(context) {
    return parentChatScreenModel.isLoading? const Center(child: CircularProgressIndicator()) :SafeArea(
      // Container 1#: coloring the whole background to almost perfect-white
      child: Container(
        color: const Color.fromARGB(255, 245, 245, 245),
        // Column 1#: laout the chat-section and chat-input
        child: Column(
          children: [
            // Expanded 1# (ListView.builder()): chat-section
            // purpose: layout all chat-bubble message
            Expanded(
              child: ListView.builder(
                // display the latest element in list first, and position the last-view at the button of list-item
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: parentChatScreenModel.messages.length,
                itemBuilder: (context, index) {
                  final message = parentChatScreenModel.messages[index];
                  return ChatBubble(
                    name: message['name'],
                    message: message['message'],
                    // we actually externally define the Datetime now instead of instantiat in function body
                    // purpose: to make the parent-chat-screen mark their state as dirty everytime, data-polling is complete
                    // that the reason we explicity define the now DateTime to make it change everytime
                    time: timeAgo(message['time'], parentChatScreenModel.now!),
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
                          parentChatScreenModel.storeMessage(msg, messageController);
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
    );
  }
}