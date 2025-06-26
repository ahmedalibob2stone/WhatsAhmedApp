import 'dart:io';

import 'package:whatsapp/model/contact/chat_contact.dart';
import 'package:whatsapp/model/massage/massage.dart';
import 'package:whatsapp/model/user_model/user_model.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../common/utils/utills.dart';

import '../../../model/group/group.dart';

import 'package:whatsapp/common/enums/enum_massage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:whatsapp/common/Provider/Message_reply.dart';
import '../../../storsge/repository.dart';


final chatRepositoryProvider =Provider(
    (ref) {
     return ChatRepository(fire: FirebaseFirestore.instance,auth: FirebaseAuth.instance, ref:ref);
    }

);

class ChatRepository {
  final FirebaseFirestore fire;
  final FirebaseAuth auth;
  final Ref ref;


  ChatRepository(  {required this.fire, required this.auth,required this.ref});

  Stream<List<ChatContact>> getDateChatContacts() {
    return fire.collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contactData = [];
      for (var doc in event.docs) {
        var chat = ChatContact.fromMap(doc.data());
        var userData = await fire.collection('users').doc(chat.contactId).get();
        var user = UserModel.fromMap(userData.data()!);

        // Query to count unread messages
        var unreadMessagesQuery = await fire.collection('users')
            .doc(auth.currentUser!.uid)
            .collection('chats')
            .doc(chat.contactId)
            .collection('messages')
            .where('isSeen', isEqualTo: false)
            .get();

        int unreadMessageCount = unreadMessagesQuery.docs.length;

        // Update unreadMessageCount to 0 if all messages are seen
        if (unreadMessageCount == 0) {
          await fire.collection('users')
              .doc(auth.currentUser!.uid)
              .collection('chats')
              .doc(chat.contactId)
              .update({'unreadMessageCount': 0});
        }

        contactData.add(ChatContact(
          name: user.name,
          prof: user.profile,
          contactId: chat.contactId,
          time: chat.time,
          lastMassge: chat.lastMassge,
          isOnline: user.isOnline,
          unreadMessageCount: unreadMessageCount,
          reciverId: chat.reciverId,
          isSeen: unreadMessageCount == 0,
        ));
      }
      return contactData;
    });
  }

  Stream<List<Message>> getStreamMassages(String reciveUserId) {
    return fire.collection('users').
    doc(auth.currentUser!.uid).collection('chats').doc(reciveUserId).collection(
        'messages')
        .orderBy('time')
        .snapshots().map((event) {
      List<Message> messages = [];
      for (var doc in event.docs) {
        messages.add(Message.fromMap(doc.data()));
      }
      return messages;
    });
  }


  void _saveDatatoContact(UserModel senderUserData,
      UserModel? reciverUserData,
      String text,
      DateTime time,
      String reciveUserId,

      bool isGroupChat) async {
    if (isGroupChat) {
      var groupDoc = fire.collection('groups').doc(reciveUserId);
      var groupSnapshot = await groupDoc.get();
      var groupData = Group.fromMap(groupSnapshot.data()!);

      Map<String, int> updatedUnreadCounts = Map.from(
          groupData.unreadMessageCount);

      for (var uid in groupData.membersUid) {
        if (uid != auth.currentUser!.uid) {
          updatedUnreadCounts[uid] = (updatedUnreadCounts[uid] ?? 0) + 1;
        }
      }


      await fire.collection('groups').doc(reciveUserId).update({
        'lastMessage': text,
        'timeSent': DateTime
            .now()
            .millisecondsSinceEpoch,
        'unreadMessageCount': updatedUnreadCounts
      });
    } // Update receiver's unread message count
    else {
      var receiverChatDoc = await fire.collection('users')
          .doc(reciveUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .get();

      int unreadMessageCount = receiverChatDoc.exists
          ? (receiverChatDoc.data()?['unreadMessageCount'] ?? 0) + 1
          : 1;
//
      //271939186


      // Save receiver's chat contact
      var receiver = ChatContact(
          name: senderUserData.name,
          prof: senderUserData.profile,
          contactId: senderUserData.uid,
          time: time,
          lastMassge: text,
          isOnline: senderUserData.isOnline,
          unreadMessageCount: unreadMessageCount,
          reciverId: reciveUserId,
          isSeen: false
      );

      await fire.collection('users').doc(reciveUserId)
          .collection('chats').doc(auth.currentUser!.uid).set(receiver.toMap());

      // Reset sender's unread message count to 0
      var sender = ChatContact(
          name: reciverUserData!.name,
          prof: reciverUserData.profile,
          contactId: reciverUserData.uid,
          time: time,
          lastMassge: text,
          isOnline: reciverUserData.isOnline,
          unreadMessageCount: 0,
          reciverId: reciverUserData.uid,
          isSeen: false
      );

      await fire.collection('users').doc(auth.currentUser!.uid)
          .collection('chats').doc(reciveUserId).set(sender.toMap());
    }
  }


  void _saveMessageInSubcollection({
    required String reciveUserId,
    required String text,
    required DateTime time,
    required String messageId,
    required String username,
    required EnumData EnumMassageType,
    required String prof, required String? proff,
    required MessageReply? messageReply,
    required String SenderUserName,
    required String? ReciveUserName,
    required bool isGroupChat,
  }) async {
    final message = Message(senderId: auth.currentUser!.uid,
        recieverid: reciveUserId,

        text: text,
        time: time,
        type: EnumMassageType,
        messageId: messageId,
        isSeen: false,
        prof: prof,
        proff: proff,
        repliedMessage: messageReply == null ? '' : messageReply.message,
        repliedTo: messageReply == null ? '' : messageReply.isMe
            ? SenderUserName
            : ReciveUserName ?? '',
        repliedMessageType: messageReply == null ? EnumData.text : messageReply
            .messageDate
    );
    if (isGroupChat) {
      await fire.collection('groups').doc(reciveUserId).
      collection('chats').doc(messageId).set(message.toMap());
    } else {
      await fire.collection('users').doc(auth.currentUser!.uid).collection(
          'chats')
          .doc(reciveUserId).collection('messages').doc(messageId).set(
          message.toMap());

      await fire.collection('users').doc(reciveUserId).collection('chats').
      doc(auth.currentUser!.uid).collection('messages').doc(messageId).set(
          message.toMap());
    }
  }

  void sendTextMessage({required BuildContext context,
    required String text,
    required String reciveUserId,
    required UserModel sendUser,
    required MessageReply? messageReply,
    required bool isGroupChat,


  }) async {
    try {
      var massageId = const Uuid().v1();
      var time = DateTime.now();
      UserModel? reciveUserData;

      if (!isGroupChat) {
        var userdata = await fire.collection('users').doc(reciveUserId).get();
        reciveUserData = UserModel.fromMap(userdata.data()!);
      }


      _saveDatatoContact(
          sendUser, reciveUserData, text, time, reciveUserId, isGroupChat);

      _saveMessageInSubcollection(
        reciveUserId: reciveUserId,
        text: text,
        time: time,
        messageId: massageId,
        username: sendUser.name,
        EnumMassageType: EnumData.text,
        prof: sendUser.profile,
        proff: reciveUserData?.profile,
        messageReply: messageReply,
        SenderUserName: sendUser.name,
        ReciveUserName: reciveUserData?.name,
        isGroupChat: isGroupChat,

      );
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }

  Stream<List<ChatContact>> getallListMASSAGEmODEL() {
    return fire.collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contactList = [];

      for (var document in event.docs) {
        // Retrieve ChatContact data from the document
        var chatContactData = ChatContact.fromMap(document.data());

        // Get additional user data (if necessary)
        var userData = await fire.collection('users').doc(
            chatContactData.contactId).get();
        var user = UserModel.fromMap(userData.data()!);

        // Add the ChatContact to the list, including the unreadMessageCount
        contactList.add(ChatContact(
            name: user.name,
            prof: user.profile,
            contactId: chatContactData.contactId,
            time: chatContactData.time,
            lastMassge: chatContactData.lastMassge,
            isOnline: user.isOnline,
            unreadMessageCount: chatContactData.unreadMessageCount,
            reciverId: chatContactData.reciverId,
            isSeen: chatContactData.isSeen
          // Include unreadMessageCount
        ));
      }

      return contactList;
    });
  }

  Stream<List<Group>> getChatGroups() {
    return fire.collection('groups').snapshots().map((event) {
      List<Group> groups = [];
      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }

      return groups;
    });
  }


  Stream<List<Message>> getGroupChatstream(String groupId) {
    return fire.collection('groups').
    doc(groupId).collection('chats')
        .orderBy('time')
        .snapshots().map((event) {
      List<Message> messages = [];
      for (var doc in event.docs) {
        messages.add(Message.fromMap(doc.data()));
      }
      return messages;
    });
  }

  Stream<Group> getGroupData(String groupId) {
    return fire.collection('groups').doc(groupId).snapshots().map((event) =>
        Group.fromMap(
          event.data()!,
        ));
  }

  Stream<List<ChatContact>> searchContact({required String searchName}) {
    return fire.collection('users').
    doc(auth.currentUser!.uid).collection('chats')
        .where('name', isGreaterThanOrEqualTo: searchName)
        .where('name', isLessThanOrEqualTo: searchName + '\uf8ff')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ChatContact.fromMap(doc.data())).toList());
  }

  Stream<List<Group>> searchGroup({required String searchName}) {
    final usercol = fire.collection('groups').
    where('name', isEqualTo: searchName);
    return usercol.snapshots().
    map((event) => event.docs.map((e) => Group.fromMap(e.data())).toList());
  }


  void deletMassage(
      {required BuildContext context, required String reciveUserId, required String messageId}) async {
    try {
      await fire.collection('users').doc(auth.currentUser!.uid).collection(
          'chats').
      doc(reciveUserId).collection('messages').doc(messageId).delete();
    }
    catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }

  void deleteChatMessages({
    required BuildContext context,
    required String receiveUserId,
  }) async {
    try {
      // Get a reference to the collection of messages
      var messagesRef = fire
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiveUserId)
          .collection('messages');


      // Retrieve all the message documents
      var messagesSnapshot = await messagesRef.get();

      // Loop through each document and delete it
      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Optionally, you can also delete the chat document itself
      await fire
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiveUserId)
          .delete();
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }

  void deleteChatMessagesGroup({
    required BuildContext context,
    required String groupId,
  }) async {
    try {
      // Get a reference to the collection of messages within the group
      var messagesRef = fire.collection('groups').doc(groupId).collection(
          'messages');

      // Retrieve all the message documents
      var messagesSnapshot = await messagesRef.get();

      // Loop through each document and delete it
      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Optionally, you can delete the group document itself if needed
      await fire.collection('groups').doc(groupId).delete();
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }


  void openChatAndMarkAsSeen(String chatId, String contactId) async {
    var chatDoc = fire.collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(contactId);

    // Mark all messages as seen
    var unreadMessagesQuery = await chatDoc.collection('messages')
        .where('isSeen', isEqualTo: false)
        .get();

    var batch = fire.batch();
    for (var doc in unreadMessagesQuery.docs) {
      batch.update(doc.reference, {'isSeen': true});
    }

    // Reset unreadMessageCount to 0
    batch.update(chatDoc, {
      'unreadMessageCount': 0,
    });

    await batch.commit();

    // Navigate to the chat screen

  }

  void SendFileMassage({
    required BuildContext context,
    required File file,
    required String reciveUserId,
    required UserModel senderUserDate,

    required EnumData massageEnum,
    required MessageReply messageReply,
    required bool isGroupChat,


  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String imageUrl = await ref.read(FirebaseStorageRepositoryProvider)
          .storeFiletofirstorage(''
          'chat/${massageEnum.type}/${senderUserDate
          .uid}/$reciveUserId/$messageId', file);
      UserModel? reciverUserDate;
      if (!isGroupChat) {
        var userdate = await fire.collection('users').doc(reciveUserId).get();
        reciverUserDate = UserModel.fromMap(userdate.data()!);
      }
      String contactMsg;
      switch (massageEnum) {
        case EnumData.image:
          contactMsg = '📷 Photo';
          break;
        case EnumData.video:
          contactMsg = '📸 Video';
          break;
        case EnumData.audio:
          contactMsg = '🎵 Audio';
          break;
        case EnumData.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }
      _saveDatatoContact(
          senderUserDate, reciverUserDate, contactMsg, timeSent, reciveUserId,
          isGroupChat);
      _saveMessageInSubcollection(reciveUserId: reciveUserId,
          text: imageUrl,
          time: timeSent,
          messageId: messageId,
          username: senderUserDate.name,
          EnumMassageType: massageEnum,
          prof: senderUserDate.profile,
          proff: reciverUserDate?.profile,

          messageReply: messageReply,
          SenderUserName: senderUserDate.name,
          ReciveUserName: reciverUserDate?.name,
          isGroupChat: isGroupChat
      );


    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({required BuildContext context,
    required String gif,
    required String reciveUserId,
    required UserModel sendUser,
    required MessageReply?messageReply,
    required bool isGroupChat,


  }) async {
    try {
      var massageId = const Uuid().v1();
      var time = DateTime.now();
      UserModel? reciveUserData;
      if (!isGroupChat) {
        var userdata = await fire.collection('users').doc(reciveUserId).get();
        reciveUserData = UserModel.fromMap(userdata.data()!);
      }
      _saveDatatoContact(
          sendUser, reciveUserData, 'GIF', time, reciveUserId, isGroupChat);
      _saveMessageInSubcollection(
          reciveUserId: reciveUserId,
          text: gif,
          time: time,
          messageId: massageId,
          username: sendUser.name,
          EnumMassageType: EnumData.gif,
          prof: sendUser.profile,
          proff: reciveUserData?.profile,
          messageReply: messageReply,
          SenderUserName: sendUser.name,
          ReciveUserName: reciveUserData?.name,
          isGroupChat: isGroupChat
      );
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }

  void setChatMassageSeen(BuildContext context,
      String reciverUserId,
      String messageId,) async {
    try {
      await fire.collection('users').doc(auth.currentUser!.uid).collection(
          'chats')
          .doc(reciverUserId).collection('messages').doc(messageId).update(
          {'isSeen': true});


      await fire.collection('users').doc(reciverUserId).collection('chats')
          .doc(auth.currentUser!.uid).collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }

  void markMessagesAsSeen(String chatId, String ContactId) async {
    var userChatDoc = fire.collection('users')
        .doc(ContactId)
        .collection('chats')
        .doc(chatId);

    var messagesQuery = await userChatDoc.collection('messages')
        .where('isSeen', isEqualTo: false)
        .get();

    // Batch update to mark all messages as seen
    var batch = fire.batch();
    for (var doc in messagesQuery.docs) {
      batch.update(doc.reference, {'isSeen': true});
    }

    // Update the chat contact to reset the unreadMessageCount
    batch.update(userChatDoc, {
      'unreadMessageCount': 0,
      'isSeen': true,
    });

    await batch.commit();
  }

  void openGroupChat(String groupId) async {
    var groupDoc = fire.collection('groups').doc(groupId);
    var groupSnapshot = await groupDoc.get();
    var groupData = Group.fromMap(groupSnapshot.data()!);

    Map<String, int> updatedUnreadCounts = Map.from(
        groupData.unreadMessageCount);
    updatedUnreadCounts[auth.currentUser!.uid] = 0;

    await groupDoc.update({
      'unreadMessageCount': updatedUnreadCounts,
    });
  }


}
