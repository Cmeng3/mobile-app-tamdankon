import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/chat_bubble.dart';
import 'package:tamdan_kon_mobile_flutter/composable/time_ago.dart';
import 'package:tamdan_kon_mobile_flutter/models/driver_chat_screen_model.dart';

class DriverChatScreen extends StatefulWidget{
  const DriverChatScreen({
    super.key, 
    required this.driverId,
    required this.triggerDriverSnackBar,
  });

  //
  final int driverId;
  //
  final void Function(String error, Color color) triggerDriverSnackBar;

  @override
  State<DriverChatScreen> createState() => _DriverChatScreenState();
}

class _DriverChatScreenState extends State<DriverChatScreen> {
  // textFormField controller
  final TextEditingController messageController = TextEditingController();
  // formkey to manage the chat-input form-state
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // allow child class or method, trigger update on parent-chat-screen
  void updateDriverState(){
    setState(() {});
  }
  // parentChatScreenModel handle parent-chat-screen logic and data
  late DriverChatScreenModel driverChatScreenModel = DriverChatScreenModel(
    driverId: widget.driverId,
    onUpdateDriverState: updateDriverState,
    onTriggerParentSnackbar: widget.triggerDriverSnackBar
  );

  @override
  void initState() {
    super.initState();
    driverChatScreenModel.getMessages();
  }

  @override
  void dispose() {
    driverChatScreenModel.getChatMessagesTimer.cancel();
    super.dispose();
  }
  @override
  Widget build(context) {
    return driverChatScreenModel.isLoading? const Center(child: CircularProgressIndicator()) :SafeArea(
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
                itemCount: driverChatScreenModel.messages.length,
                itemBuilder: (context, index) {
                  final message = driverChatScreenModel.messages[index];
                  return ChatBubble(
                    name: message['name'],
                    message: message['message'],
                    // we actually externally define the Datetime now instead of instantiat in function body
                    // purpose: to make the parent-chat-screen mark their state as dirty everytime, data-polling is complete
                    // that the reason we explicity define the now DateTime to make it change everytime
                    time: timeAgo(message['time'], driverChatScreenModel.now!),
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
                          driverChatScreenModel.storeMessage(msg, messageController);
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