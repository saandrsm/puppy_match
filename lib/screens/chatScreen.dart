import 'package:PuppyMatch/model/chatData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_route/deep_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../model/messageData.dart';
import '../model/userData.dart';
import '../services/database.dart';
import 'chatUserProfile.dart';

class ChatScreen extends StatefulWidget {
  final ChatData chat;
  const ChatScreen({Key? key, required this.chat}) : super(key: key); //necesita un dato de tipo chat para ejecutarse
  static final routeName = '/chat'; //ruta de la página

  @override
  State<ChatScreen> createState() => _ChatScreenState(chat);
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatData chat;

  _ChatScreenState(this.chat);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance; //instancia de auth de firebase
  final FirebaseFirestore firebaseFire = FirebaseFirestore.instance; //instancia de la base de datos
  late String? userId;
  late bool isShelter;
  bool isLoading = true;
  late String? userChattedId = "";
  late String? profilePicture;
  late String? name;
  final TextEditingController _messageController = TextEditingController();
  late Stream<QuerySnapshot<MessageData>> messagesSnapshot; //variable que contiene los mensajes del chat
  late FocusNode myFocusNode; //objeto que controla el foco cuando se escribe un mensaje

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    userId = firebaseAuth.currentUser
        ?.uid; //obtiene el id del usuario que se le ha asignado al iniciar sesión (auth)
    UserData thisUserData;
    UserData chatUserData;
    DatabaseService(uid: userId).gettingUserData(userId).then((value) { //obtiene los datos del usuario
      setState(() {
        thisUserData = value;
        isShelter = thisUserData.isShelter!;
        if (isShelter) {
          userChattedId = chat.regularUserId;
        } //asigna el id de la persona con la que habla según el método lo haya llamado una protectora o un usuario
        else {
          userChattedId = chat.shelterId;
        }
      });
      Future.delayed(Duration.zero, () async {
        await DatabaseService(uid: userId).gettingUserData(userChattedId).then(( //obtiene los datos del usuario con el que habla
            value) async {
          setState(() {
            chatUserData = value;
            profilePicture = chatUserData.profilePicture;
            name = chatUserData.name;
          });
          await DatabaseService(uid: userId)
              .getAllMessagesFromChat(chat.chatId) //obtiene los mensajes del chat
              .then((value) {
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
    return isLoading //muestra el icono de carga o el resto de elementos
        ? Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.orangeAccent,
        size: 40,
      ),
    )
        : Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                if(isShelter){
                  DeepRoute.toNamed(ChatUserProfile.routeName, arguments: chat.regularUserId);
                } else { //accede al perfil de la persona con la que habla según
                  DeepRoute.toNamed(ChatUserProfile.routeName, arguments: chat.shelterId);
                }
              },
              child: CircleAvatar(
                radius: 22.0,
                backgroundImage: NetworkImage(profilePicture!), //foto de perfil del usuario/protectora con el que se está hablando
              ),
            ),
            const SizedBox(width: 13.0),
            Expanded(child: Text(name!)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            semanticLabel: 'logout',
          ),
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla de conversaciones
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<MessageData>>( //comprueba si hay cambios en el stream de datos y se reconstruye
                stream: messagesSnapshot,                       //es decir, si se envía un mensaje, actualiza en tiempo real los datos
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    Navigator.pop(context);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) { //muestra el icono de carga mientras se actualizan los datos
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                    );
                  }
                  List<MessageData>? messageList = snapshot.data?.docs //guarda los mensajes en una lista
                      .map((doc) => doc.data() as MessageData)
                      .toList();
                  // Agrupa los mensajes por día
                  Map<String, List<MessageData>> groupedMessages =
                  groupMessagesByDay(messageList);
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: groupedMessages.length, //muestra tantos elementos como grupos de mensajes haya
                    reverse: true,
                    itemBuilder: (context, index) {
                      String day = groupedMessages.keys.toList()[index]; //recoge el día de los mensajes
                      List<MessageData> messages = groupedMessages[day]!; //guarda los mensajes
                      return Column(
                        children: [
                          _buildDayDivider(day),
                          ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              MessageData message = messages[index]; //asigna cada mensaje en la variable
                              final isSentMessage = message.senderId == userId; //comrpueba si el mensaje lo ha enviado o recibido el usuario
                              final messageTime = message.time != null
                                  ? DateFormat('HH:mm').format(
                                message.time!.toDate(), //le da formato al timestamp del envío
                              )
                                  : '';
                              return Align(
                                alignment: isSentMessage //alinea el mensaje según lo haya enviado el usuario o no
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: isSentMessage
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: isSentMessage
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0, vertical: 8.0),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 6.0, vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: isSentMessage //color según se ha enviad o recibido
                                                  ? Colors.blueGrey
                                                  : Colors.orangeAccent,
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: Text(
                                              softWrap: true,
                                              message.text!, //texto del mensaje
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                color: isSentMessage
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.0),
                                    Align( //alinea la hora del mensaje
                                      alignment: isSentMessage
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: isSentMessage ? 0 : 10,
                                          right: isSentMessage ? 10 : 0,
                                        ),
                                        child: Text(
                                          messageTime,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                children: [
                  Expanded( //widget de la estructura para enviar un mensaje
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
                  IconButton(
                    onPressed: () { //guarda el mensaje en la base de datos, vacía el texto escrito y pierde el foco
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

  // Método para agrupar los mensajes por día
  Map<String, List<MessageData>> groupMessagesByDay(List<MessageData>? messages) {
    Map<String, List<MessageData>> groupedMessages = {};

    if (messages != null) {
      for (MessageData message in messages) {
        // Obtiene la fecha del mensaje en formato "yyyy-MM-dd"
        String day = DateFormat('dd-MM-yyyy').format(
          message.time!.toDate().add(Duration(hours: 2)),
        );

        if (groupedMessages.containsKey(day)) {
          // Si ya existe una lista de mensajes para ese día, la actualiza
          groupedMessages[day]!.add(message);
        } else {
          // Si no existe una lista de mensajes para ese día, la crea
          groupedMessages[day] = [message];
        }
      }
    }
    return groupedMessages;
  }

  // Método para construir el separador de días
  Widget _buildDayDivider(String day) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(181, 181, 181, 1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          alignment: Alignment.center,
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}


