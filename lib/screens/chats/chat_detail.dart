import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portrait_click/provider/user_provider.dart';
import 'package:portrait_click/services/chat_service.dart';
import 'package:portrait_click/utils/utils.dart';
import 'package:portrait_click/widgets/chat_bubble.dart';
import 'package:portrait_click/widgets/customappbar.dart';
import 'package:provider/provider.dart';

class ChatDetail extends StatefulWidget {
  final String receiverUsername;
  final String receiverUserId;

  const ChatDetail(
      {super.key,
      required this.receiverUsername,
      required this.receiverUserId});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  void sendMessage(String senderPhoto) async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessageService(
          widget.receiverUserId, _messageController.text.trim(), senderPhoto);

      _messageController.clear();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.receiverUsername,
        // profile: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatService.getNewMessage(
                  widget.receiverUserId, userProvider.getUser.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  showSnackBar(context, "Something Went Wrong!");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                SchedulerBinding.instance.addPostFrameCallback((_) {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                });
                return ListView(
                  controller: scrollController,
                  children: snapshot.data!.docs
                      .map((documentSnapshot) =>
                          messageItem(documentSnapshot, userProvider))
                      .toList(),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Enter Message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () => sendMessage(userProvider.getUser.imageUrl),
                  icon: const FaIcon(FontAwesomeIcons.paperPlane)),
            ],
          ),
        ],
      ),
    );
  }
}

Widget messageItem(
    DocumentSnapshot documentSnapshot, UserProvider userProvider) {
  Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

  var alignment = (data['senderId'] == userProvider.getUser.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;

  return Container(
    alignment: alignment,
    child: Row(
      crossAxisAlignment: (data['senderId'] == userProvider.getUser.uid)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisAlignment: (data['senderId'] == userProvider.getUser.uid)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        (data['senderId'] == userProvider.getUser.uid)
            ? Row(
                children: [
                  ChatBubble(
                    message: data['message'],
                    userColorCheck: true,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      (data['senderPhoto']),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      (data['senderPhoto']),
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  ChatBubble(
                    message: data['message'],
                    userColorCheck: false,
                  )
                ],
              ),
      ],
    ),
  );
}
