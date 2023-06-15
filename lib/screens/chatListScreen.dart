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
  late List<ChatData> chats; //variable donde se van a guardar los datos de los chats
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
      body: isLoading //muestra el icono de carga o el resto de elementos
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
          itemCount: chats.length, //muestra tantos chats como la longitud de la variable
          itemBuilder: (context, index) {
            final chat = chats[index]; //asigna a la variable los datos de cada chat
            return ChatListItem( //genera un chat con la estructura del widget ChatListItem
              chat: chat,
              onTap: () async {
                 await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(chat: chat), //te envía a la pantalla del chat pasando los datos como argumento
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
              isShelter: isShelter, //pasa la variable para cambiar el comportamiento del widget según qué reciba
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
      DatabaseService(uid: userId).gettingUserData(userId).then((value) { //obtiene los datos del usuario
        userData = value;
        isShelter = userData.isShelter!;
        Future.delayed(Duration.zero, () async {
          if(isShelter){
            await DatabaseService(uid: userId).getAllShelterChats().then((value) { //obtiene todos los chats de la protectora
              setState(() {
                chats = value;
                isLoading = false;
              });
            });
          }
          else{
            await DatabaseService(uid: userId).getAllRegularUserChats().then((value) { //obtiene todos los chats del usuario
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

class ChatListItem extends StatefulWidget { //widget utilizado para constuir cada chat que se muestra
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

  String formatTimestamp(Timestamp timestamp) { //metodo para formatear el timeStamp de firestore
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
    } //asigna el id de la persona con la que habla según el método lo haya llamado una protectora o un usuario
    else{
      userChattedId = chat.shelterId;
    }
    DatabaseService(uid: userId).gettingUserData(userChattedId).then((value){ //recibe y asigna los datos de la persona
      setState(() {
        userData = value;
        profilePicture = userData.profilePicture;
        name = userData.name;
      });
      DatabaseService(uid: userId).getLastMessageDataFromChat(chat.chatId).then((value) { //recibe el último mensaje para mostrarlo
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
    return isLoading //muestra el icono de carga o el resto de elementos
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
                  image: NetworkImage(profilePicture!), //imagen del perfil del usuario
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
                    name!, //nombre del usuario
                    style: theme.textTheme.titleLarge,
                  ),
              const SizedBox(height: 8),
              Text(
                lastMessageData.text!, //último mensaje
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formatTimestamp(lastMessageData.time!), //timestamp formateado
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