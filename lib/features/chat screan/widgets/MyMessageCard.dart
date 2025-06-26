
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../../common/enums/enum_massage.dart';
import '../../../constant.dart';
import '../conrroller/chat_controller.dart';
import 'DisplayTypeofMassage.dart';

class MyMessageCard extends ConsumerWidget {
  final String message;
  final String date;
  final EnumData type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final EnumData repliedMessageType;
  final String uid;
  final bool isSeen;
  final String reciveUserId;
  final String messageId;
  final String profileUrl;

  //CircleAvatar(
  //backgroundColor: Colors.grey.withOpacity(.3),
  //radius: 20,
  //backgroundImage: CachedNetworkImageProvider(proff),
  //),
  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.uid,
    required this.reciveUserId,
    required this.messageId,
    required this.isSeen,
    required this.profileUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReplying = repliedText.isNotEmpty;
    final width = MediaQuery.of(context).size.width;
    return SwipeTo(
      onLeftSwipe: (_) => onLeftSwipe(),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width * 0.8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildMessageCard(context, ref, isReplying),
              _buildProfileImage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context, WidgetRef ref, bool isReplying) {
    return InkWell(
      onLongPress: () => _onMessageLongPress(context, ref),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: messageCard,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Stack(
          children: [
            Padding(
              padding: type == EnumData.text
                  ? const EdgeInsets.fromLTRB(20, 5, 25, 20)
                  : const EdgeInsets.fromLTRB(5, 5, 5, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isReplying) _buildReplyMessage(context),
                  DisplayTypeofMassage(
                    message: message,
                    type: type,
                  ),
                ],
              ),
            ),
            _buildTimestampAndSeenIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: DisplayTypeofMassage(
            message: repliedText,
            type: repliedMessageType,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTimestampAndSeenIcon() {
    return Positioned(
      bottom: 4,
      right: 5,
      child: Row(
        children: [
          Text(
            date,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white60,
            ),
          ),
          const SizedBox(width: 1),
          Icon(
            isSeen ? Icons.done_all : Icons.done,
            size: 15,
            color: isSeen ? Colors.blue : Colors.white60,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: CircleAvatar(
        backgroundColor: Colors.grey.withValues(),
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(profileUrl),
      ),
    );
  }

  void _onMessageLongPress(BuildContext context, WidgetRef ref) {
    if (uid == FirebaseAuth.instance.currentUser!.uid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: const Text("Delete Message"),
                onPressed: () {
                  ref.read(chatControllerProvider.notifier).deletmassage(
                    context: context,
                    reciveUserId: reciveUserId,
                    messageId: messageId,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
