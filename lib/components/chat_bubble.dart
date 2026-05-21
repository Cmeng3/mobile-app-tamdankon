import 'package:flutter/material.dart';
import 'package:tamdan_kon_mobile_flutter/components/app_text.dart';
import 'package:tamdan_kon_mobile_flutter/components/user_avatar.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.isMe,
  });
  // field needed
  final String name;
  final String message;
  final String time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    // Give a inside-space to each bubble
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      // Column: layout the chat-bubble element
      // it take as much space as it can in horizental
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // give a padding the name
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: AppText(
              name,
              color: Colors.black54,
            ),
          ),

          // Row : layout the user-avatar and message-badge
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // if it not our text-message, we style positioning user-avata first
              // best-pratice: if we do a conditional rendering, and want to render multiple component
              // we can use if and spread-operator together instead of ternary-operator
              if (!isMe) ...[
                UserAvatar(width: 40, height: 40),
                const SizedBox(width: 10),
              ],
              // Flexible: make the the child of its child, dimension flexible
              // especially when its parent constrain the child
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(
                    // make the chat-badge have a miximum-size
                    // purpose: when the text width reaching that size, it will flexible and take a new line
                    maxWidth: 260,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.blue
                        : const Color.fromARGB(25, 33, 150, 243),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: AppText(
                    message,
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ),

              // layout the avatar and chat-badge when it was u
              if (isMe) ...[
                const SizedBox(width: 10),
                UserAvatar(width: 40, height: 40),
              ],
            ],
          ),
          // Padding 2#: display the time
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: AppText(
              time,
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}