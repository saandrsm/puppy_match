import 'package:PuppyMatch/model/messageData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../model/chatData.dart';
import '../model/userData.dart';
import '../services/database.dart';
import 'chatScreen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen();

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int selectedIndex = 0;
  late String? userId;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance; //instancia de la base de datos
  final FirebaseFirestore firebaseFire = FirebaseFirestore.instance; //instancia de la base de datos
  late bool isShelter = false; //variable que define el tipo de usuario
  bool isLoading = true;
  late List<ChatData> chats;
  int update = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversaciones',
          style: theme.textTheme.titleLarge,
        ),
          leading: IconButton(
            //icono a la izquierda (principio) del texto para cerrar sesión
            icon: const Icon(
              Icons.arrow_back,
              semanticLabel: 'logout',
            ),
            onPressed: () {
              //al presionar vuelve hacia LoginPage
              Navigator.pop(context);
            },
          )
      ),
      body: isLoading
          ? Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.orangeAccent,
          size: 40,
        ),
      )
      : Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
        ),
        child: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return ChatListItem(
              chat: chat,
              onTap: () async {
                 await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(chat: chat),
                  ),
                ).then((value) { //espera a que se haga el navigator.pop del chat y sustituye la pantalla por una actualizada
                   Navigator.pushReplacement(
                     context,
                     MaterialPageRoute(
                       builder: (context) => ChatListScreen(),
                     ),
                   );
                 });
              },
              isShelter: isShelter,
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    try {
      userId = firebaseAuth.currentUser?.uid; //obtiene el id del usuario que se le ha asignado al iniciar sesión (auth)
      UserData userData;
      DatabaseService(uid: userId).gettingUserData(userId).then((value) {
        userData = value;
        isShelter = userData.isShelter!;
        Future.delayed(Duration.zero, () async {
          if(isShelter){
            await DatabaseService(uid: userId).getAllShelterChats().then((value) {
              setState(() {
                chats = value;
                isLoading = false;
              });
            });
          }
          else{
            await DatabaseService(uid: userId).getAllRegularUserChats().then((value) {
              setState(() {
                chats = value;
                isLoading = false;
              });
            });
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }
}

class ChatListItem extends StatefulWidget {
  final ChatData chat;
  final VoidCallback onTap;
  final bool isShelter;
  const ChatListItem({Key? key, required this.chat, required this.onTap, required this.isShelter}) : super(key: key);

  @override
  State<ChatListItem> createState() => _ChatListItemState(this.chat, this.onTap, this.isShelter);
}

class _ChatListItemState extends State<ChatListItem> {
  final ChatData chat;
  final VoidCallback onTap;
  late bool isShelter;
  _ChatListItemState(this.chat, this.onTap, this.isShelter);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late String? userId;
  late String? profilePicture;
  late String? name;
  late bool isLoading = true;
  late String? userChattedId;
  late MessageData lastMessageData;

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime localDateTime = dateTime.toLocal(); // Convierte a la zona horaria local del dispositivo
    DateTime now = DateTime.now();

    if (now.year == localDateTime.year &&
        now.month == localDateTime.month &&
        now.day == localDateTime.day) {
      // Es del día actual, mostrar solo la hora
      String formattedTime = DateFormat('HH:mm').format(localDateTime);
      return formattedTime;
    } else {
      // Es de otro día, mostrar día y hora
      String formattedDateTime = DateFormat('d MMM, HH:mm').format(localDateTime);
      return formattedDateTime;
    }
  }


  @override
  void initState() {
    super.initState();
    UserData userData;
    userId = firebaseAuth.currentUser?.uid;
    if(isShelter) {
      userChattedId = chat.regularUserId;
    }
    else{
      userChattedId = chat.shelterId;
    }
    DatabaseService(uid: userId).gettingUserData(userChattedId).then((value){
      setState(() {
        userData = value;
        profilePicture = userData.profilePicture;
        name = userData.name;
      });
      DatabaseService(uid: userId).getLastMessageDataFromChat(chat.chatId).then((value) {
        setState(() {
          lastMessageData = value;
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return isLoading
        ? Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.orangeAccent,
        size: 40,
      ),
    )
    :InkWell(
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
                  image: NetworkImage(profilePicture!),
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
                    name!,
                    style: theme.textTheme.titleLarge,
                  ),
              const SizedBox(height: 8),
              Text(
                lastMessageData.text!,
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formatTimestamp(lastMessageData.time!),
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