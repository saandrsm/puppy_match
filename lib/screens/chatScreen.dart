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
              radius: 16.0,
              backgroundImage: AssetImage(chat.avatar),
            ),
            SizedBox(width: 8.0),
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
                padding: EdgeInsets.all(8.0),
                itemCount: chat.messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = chat.messages[index];
                  final isSentMessage = message.sender == 'Usuario 1';

                  return Align(
                    alignment: isSentMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isSentMessage ? Colors.blue : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        message.text,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSentMessage ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Write a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.attach_file),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.send),
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