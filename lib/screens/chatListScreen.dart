import 'package:flutter/material.dart';
import 'chatScreen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen();

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Chat> chatData = [
      const Chat(
        avatar: 'assets/pup.jpg',
        name: 'Shelter 1',
        lastMessage: "Yes, I'm interested",
        lastMessageTime: '10:30 AM',
        messages: [
          Message(sender: 'Usuario 1', text: "Yes, I'm interested"),
          Message(sender: 'Usuario 2', text: 'Hola, estoy bien. ¿Y tú?'),
        ],
      ),
      const Chat(
        avatar: 'assets/pup.jpg',
        name: 'Shelter 2',
        lastMessage: "Hello user, I'm a shelter",
        lastMessageTime: '11:45 AM',
        messages: [
          Message(sender: 'Usuario 2', text: "Hello user, I'm a shelter"),
          Message(sender: 'Usuario 1', text: "Hello I'm a user"),
        ],
      ),
      const Chat(
        avatar: 'assets/pup.jpg',
        name: 'Shelter 3',
        lastMessage: "Can you come by at 7 o'clock?",
        lastMessageTime: 'Yesterday',
        messages: [
          Message(sender: 'Usuario 3', text: "Can you come by at 7 o'clock?"),
          Message(sender: 'Usuario 1', text: 'Estoy trabajando en un proyecto.'),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversations',
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
        ),
        child: ListView.builder(
          itemCount: chatData.length,
          itemBuilder: (context, index) {
            final chat = chatData[index];

            return ChatListItem(
              chat: chat,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(chat: chat),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatListItem({
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(chat.avatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    chat.lastMessage,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        chat.lastMessageTime,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
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