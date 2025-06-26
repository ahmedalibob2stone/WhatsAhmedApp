import 'package:whatsapp/features/chat%20screan/widgets/MyMessageCard.dart';
import 'package:whatsapp/features/chat%20screan/widgets/senderMassage.dart';
import 'package:whatsapp/model/massage/massage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../common/Provider/Message_reply.dart';
import '../../../common/enums/enum_massage.dart';
import '../../../common/widgets/Loeading.dart';

import '../conrroller/chat_controller.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({
    Key? key,
    required this.isGroupChat,
    required this.reciverUserId,
  }) : super(key: key);

  final String reciverUserId;
  final bool isGroupChat;

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _messageController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void replyToMessage(String message, bool isMe, EnumData enumData) {
    ref.read(messageReplyProvider.notifier).state =
        MessageReply(message: message, isMe: isMe, messageDate: enumData);
  }

  @override
  Widget build(BuildContext context) {
    void _onMessageSwipe(String message, bool isMe, EnumData enumData) {
      ref.read(messageReplyProvider.notifier).state =
          MessageReply(message: message, isMe: isMe, messageDate: enumData);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return StreamBuilder<List<Message>>(
          stream: widget.isGroupChat
              ? ref.read(chatControllerProvider.notifier).groupchatstream(widget.reciverUserId)
              : ref.read(chatControllerProvider.notifier).chatstream(widget.reciverUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loeading();
            }

            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (_messageController.hasClients) {
                _messageController.jumpTo(
                  _messageController.position.maxScrollExtent,
                );
              }
            });

            return ListView.builder(
              controller: _messageController,
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final currentMessage = snapshot.data![index];
                final previousMessage =
                index > 0 ? snapshot.data![index - 1] : null;

                bool showDateHeader = false;
                if (previousMessage == null ||
                    currentMessage.time.day != previousMessage.time.day) {
                  showDateHeader = true;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: constraints.maxHeight * 0.01,
                        ),
                        child: Center(
                          child: Text(
                            DateFormat('EEEE, MMMM d, yyyy').format(
                              currentMessage.time,
                            ),
                            style: TextStyle(
                              fontSize: constraints.maxHeight * 0.02,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    if (currentMessage.senderId ==
                        FirebaseAuth.instance.currentUser!.uid)
                      MyMessageCard(
                        message: currentMessage.text,
                        date: DateFormat.Hm().format(currentMessage.time),
                        type: currentMessage.type,
                        repliedText: currentMessage.repliedMessage,
                        onLeftSwipe: () => _onMessageSwipe(
                          currentMessage.text,
                          true,
                          currentMessage.type,
                        ),
                        username: currentMessage.repliedTo,
                        repliedMessageType: currentMessage.repliedMessageType,
                        uid: currentMessage.senderId,
                        reciveUserId: currentMessage.recieverid,
                        messageId: currentMessage.messageId,
                        isSeen: currentMessage.isSeen,
                        profileUrl: currentMessage.prof,
                      )
                    else
                      SenderMessageCard(
                        message: currentMessage.text,
                        date: DateFormat.Hm().format(currentMessage.time),
                        type: currentMessage.type,
                        onRightSwipe: () => _onMessageSwipe(
                          currentMessage.text,
                          false,
                          currentMessage.type,
                        ),
                        username: currentMessage.repliedTo,
                        repliedMessageType: currentMessage.repliedMessageType,
                        repliedText: currentMessage.repliedMessage,
                        prof: currentMessage.prof,
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
