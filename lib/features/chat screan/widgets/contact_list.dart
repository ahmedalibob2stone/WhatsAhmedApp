import 'package:whatsapp/model/contact/chat_contact.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/Loeading.dart';
import '../../../constant.dart';
import '../../../model/group/group.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../conrroller/chat_controller.dart';

class ContactList extends ConsumerWidget {
  const ContactList({
    Key? key,
    required this.searchName,
    required this.isShowUser,
  }) : super(key: key);

  final String searchName;
  final bool isShowUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 600;

        double avatarRadius = isMobile ? 24 : 36;
        double titleFontSize = isMobile ? 16 : 22;
        double subtitleFontSize = isMobile ? 12 : 16;
        double timeFontSize = isMobile ? 11 : 14;

        return Padding(
          padding: EdgeInsets.only(top: isMobile ? 10.0 : 20.0),
          child: SingleChildScrollView(
            child: isShowUser
                ? _buildUserList(ref, avatarRadius, titleFontSize, subtitleFontSize, timeFontSize, context)
                : _buildGroupList(ref, avatarRadius, titleFontSize, subtitleFontSize, timeFontSize, context),
          ),
        );
      },
    );
  }

  Widget _buildUserList(
      WidgetRef ref,
      double avatarRadius,
      double titleFontSize,
      double subtitleFontSize,
      double timeFontSize,
      BuildContext context,
      ) {
    return StreamBuilder<List<ChatContact>>(
      stream: ref.watch(chatControllerProvider.notifier).search(searchName: searchName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loeading();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No contacts available'));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final chatContact = snapshot.data![index];
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  PageConst.mobileChatScrean,
                  arguments: {
                    'name': chatContact.name,
                    'uid': chatContact.contactId,
                    'isGroupChat': false,
                    'profilePic': chatContact.prof,
                  },
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.withValues(),
                  radius: avatarRadius,
                  backgroundImage: chatContact.prof.isNotEmpty
                      ? CachedNetworkImageProvider(chatContact.prof)
                      : null,
                  child: chatContact.prof.isEmpty
                      ? const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  )
                      : null,
                ),
                title: Text(
                  chatContact.name,
                  style: TextStyle(fontSize: titleFontSize),
                ),
                subtitle: Text(
                  chatContact.lastMassge,
                  style: TextStyle(fontSize: subtitleFontSize),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    DateFormat.Hm().format(chatContact.time),
                    style: TextStyle(fontSize: timeFontSize, color: Colors.black),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGroupList(
      WidgetRef ref,
      double avatarRadius,
      double titleFontSize,
      double subtitleFontSize,
      double timeFontSize,
      BuildContext context,
      ) {
    return Column(
      children: [
          StreamBuilder<List<Group>>(
            stream: ref.watch(chatControllerProvider.notifier).chatGroups(),
            builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loeading();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No groups available'));
            }
            return _buildGroupListView(snapshot, avatarRadius, titleFontSize, subtitleFontSize, timeFontSize, ref, context);
          },
        ),
        StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider.notifier).chatListContact(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loeading();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No contacts available'));
            }
            return _buildUserListView(snapshot, avatarRadius, titleFontSize, subtitleFontSize, timeFontSize, ref, context);
          },
        ),
      ],
    );
  }

  Widget _buildGroupListView(
      AsyncSnapshot<List<Group>> snapshot,
      double avatarRadius,
      double titleFontSize,
      double subtitleFontSize,
      double timeFontSize,
      WidgetRef ref,
      BuildContext context,
      ) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final groupData = snapshot.data![index];
        int unreadCount = groupData.unreadMessageCount[FirebaseAuth.instance.currentUser!.uid] ?? 0;

        return Column(
          children: [
            InkWell(
              onLongPress: () => _showDeleteGroupDialog(context, groupData, ref),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  PageConst.mobileChatScrean,
                  arguments: {
                    'name': groupData.name,
                    'uid': groupData.groupId,
                    'isGroupChat': true,
                    'profilePic': groupData.groupPic,
                  },
                );
                ref.read(chatControllerProvider.notifier).openGroupChat(groupData.groupId);
              },
              child: ListTile(
                title: Text(
                  groupData.name,
                  style: TextStyle(fontSize: titleFontSize),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text(
                        groupData.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: subtitleFontSize, color: Colors.black54),
                      ),
                    ),
                    unreadCount > 0
                        ? CircleAvatar(
                      backgroundColor: kkPrimaryColor,
                      radius: 12,
                      child: Text(
                        unreadCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.withValues(),
                  radius: avatarRadius,
                  backgroundImage: groupData.groupPic.isNotEmpty
                      ? CachedNetworkImageProvider(groupData.groupPic)
                      : null,
                  child: groupData.groupPic.isEmpty
                      ? const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  )
                      : null,
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(top: 22.5),
                  child: Text(
                    DateFormat.Hm().format(groupData.timeSent),
                    style: TextStyle(fontSize: timeFontSize, color: Colors.black),
                  ),
                ),
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget _buildUserListView(
      AsyncSnapshot<List<ChatContact>> snapshot,
      double avatarRadius,
      double titleFontSize,
      double subtitleFontSize,
      double timeFontSize,
      WidgetRef ref,
      BuildContext context,
      ) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final chatContact = snapshot.data![index];
        int unreadCount = chatContact.unreadMessageCount;

        return Column(
          children: [
            InkWell(
              onLongPress: () => _showDeleteChatDialog(context, chatContact, ref),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  PageConst.mobileChatScrean,
                  arguments: {
                    'name': chatContact.name,
                    'uid': chatContact.contactId,
                    'isGroupChat': false,
                    'profilePic': chatContact.prof,
                  },
                );
                ref.watch(chatControllerProvider.notifier).markMessagesAsSeen(chatContact.contactId, chatContact.reciverId);
              },
              child: ListTile(
                title: Row(
                  children: [
                    Text(chatContact.name, style: TextStyle(fontSize: titleFontSize)),
                    SizedBox(width: 10),
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: chatContact.isOnline == 'Online' ? Colors.green : Colors.red,
                    ),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.withValues(),
                  radius: avatarRadius,
                  backgroundImage: chatContact.prof.isNotEmpty
                      ? CachedNetworkImageProvider(chatContact.prof)
                      : null,
                  child: chatContact.prof.isEmpty
                      ? const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  )
                      : null,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text(
                        chatContact.lastMassge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: subtitleFontSize, color: Colors.black54),
                      ),
                    ),
                    ( unreadCount > 0 && chatContact.reciverId!=chatContact.contactId || chatContact.isSeen)
                        ? CircleAvatar(
                      backgroundColor: kkPrimaryColor,
                      radius: 12,
                      child: Text(
                        unreadCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ],
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(top: 22.5),
                  child: Text(
                    DateFormat.Hm().format(chatContact.time),
                    style: TextStyle(fontSize: timeFontSize, color: Colors.black),
                  ),
                ),
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }

  void _showDeleteGroupDialog(BuildContext context, Group groupData, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text('Are you sure you want to delete this group?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Yes'),
              onPressed: () {
                ref.read(chatControllerProvider.notifier).deletChatMassageGroup(context, groupData.groupId);
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteChatDialog(BuildContext context, ChatContact chatContact, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text('Are you sure you want to delete this chat?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Yes'),
              onPressed: () {
                ref.read(chatControllerProvider.notifier).deletChatMassage(context, chatContact.contactId);
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}


