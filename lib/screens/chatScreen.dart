import 'package:PuppyMatch/model/chatData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../model/messageData.dart';
import '../model/userData.dart';
import '../services/database.dart';

class ChatScreen extends StatefulWidget {
  final ChatData chat;
  const ChatScreen({Key? key, required this.chat}) : super(key: key);
  static final routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState(chat);
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatData chat;
  _ChatScreenState(this.chat);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFire = FirebaseFirestore.instance;
  late String? userId;
  late bool isShelter;
  bool isLoading = true;
  late String? userChattedId = "";
  late String? profilePicture;
  late String? name;
  final TextEditingController _messageController = TextEditingController();
  late Stream<QuerySnapshot<MessageData>> messagesSnapshot;
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    userId = firebaseAuth.currentUser?.uid; //obtiene el id del usuario que se le ha asignado al iniciar sesión (auth)
    UserData thisUserData;
    UserData chatUserData;
    DatabaseService(uid: userId).gettingUserData(userId).then((value) {
      setState(() {
        thisUserData = value;
        isShelter = thisUserData.isShelter!;
        if(isShelter) {
          userChattedId = chat.regularUserId;
        }
        else{
          userChattedId = chat.shelterId;
        }
      });
      Future.delayed(Duration.zero, () async {
        await DatabaseService(uid: userId).gettingUserData(userChattedId).then((value) async {
          setState(() {
            chatUserData = value;
            profilePicture = chatUserData.profilePicture;
            name = chatUserData.name;
          });
          await DatabaseService(uid: userId).getAllMessagesFromChat(chat.chatId).then((value) {
            setState(() {
              messagesSnapshot = value;
              isLoading = false;
            });
          });
        });
      });
    });

  }
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return  isLoading
        ? Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.orangeAccent,
        size: 40,
      ),
    )
    :
    Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(profilePicture!),
            ),
            const SizedBox(width: 13.0),
            Text(name!),
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
              child: StreamBuilder<QuerySnapshot<MessageData>>(
                stream: messagesSnapshot,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    Navigator.pop(context);
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: snapshot.data?.docs.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      MessageData? message = snapshot.data?.docs[index].data() as MessageData?;
                      final isSentMessage = message?.senderId == userId;
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
                            message!.text!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isSentMessage ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                children: [
                   Expanded(
                    child: TextFormField(
                      focusNode: myFocusNode,
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 4.0),
                  // IconButton(
                  //   onPressed: () {
                  //
                  //   },
                  //   icon: const Icon(Icons.attach_file),
                  // ),
                  //const SizedBox(width: 0.0),
                  IconButton(
                    onPressed: () {
                      DatabaseService(uid: userId).sendMessageToChatroom(chat.chatId!, userId!, _messageController.text);
                      _messageController.clear();
                      myFocusNode.unfocus();

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
