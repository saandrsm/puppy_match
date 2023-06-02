import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final Chat chat;

  const ChatScreen({required this.chat});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 22.0,
              backgroundImage: AssetImage(chat.avatar),
            ),
            const SizedBox(width: 13.0),
            Text(chat.name),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: chat.messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = chat.messages[index];
                  final isSentMessage = message.sender == 'Usuario 1';

                  return Align(
                    alignment: isSentMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isSentMessage ? Colors.blue : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        message.text,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSentMessage ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                children: [
                   Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Write a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 4.0),
                  IconButton(
                    onPressed: () {

                    },
                    icon: const Icon(Icons.attach_file),
                  ),
                  //const SizedBox(width: 0.0),
                  IconButton(
                    onPressed: () {

                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class Chat {
  final String avatar;
  final String name;
  final String lastMessage;
  final String lastMessageTime;
  final List<Message> messages;

  const Chat({
    required this.avatar,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.messages,
  });
}

class Message {
  final String sender;
  final String text;

  const Message({
    required this.sender,
    required this.text,
  });
}