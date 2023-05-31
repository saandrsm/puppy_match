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
          const Message(sender: 'Usuario 1', text: "Yes, I'm interested"),
          const Message(sender: 'Usuario 2', text: 'Hola, estoy bien. ¿Y tú?'),
        ],
      ),
      const Chat(
        avatar: 'assets/pup.jpg',
        name: 'Shelter 2',
        lastMessage: "Hello user, I'm a shelter",
        lastMessageTime: '11:45 AM',
        messages: [
          const Message(sender: 'Usuario 2', text: "Hello user, I'm a shelter"),
          const Message(sender: 'Usuario 1', text: "Hello I'm a user"),
        ],
      ),
      const Chat(
        avatar: 'assets/pup.jpg',
        name: 'Shelter 3',
        lastMessage: "Can you come by at 7 o'clock?",
        lastMessageTime: 'Yesterday',
        messages: [
          const Message(sender: 'Usuario 3', text: "Can you come by at 7 o'clock?"),
          const Message(sender: 'Usuario 1', text: 'Estoy trabajando en un proyecto.'),
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
            icon: Icon(Icons.search),
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
      bottomNavigationBar: BottomNavigationBar( //barra de navegación entre HomePage y ProfilePage
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.brown, //el icono del item seleccionado se hace marrón
        onTap: (value) { //cuando se pulsa se actualiza el estado
          setState(() {
            selectedIndex = value;
          });
        },
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
        padding: EdgeInsets.all(16),
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(chat.avatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    chat.lastMessage,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    chat.lastMessageTime,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
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