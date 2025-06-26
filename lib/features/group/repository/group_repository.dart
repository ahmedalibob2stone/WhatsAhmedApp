
import 'dart:io';

import 'package:whatsapp/model/group/group.dart'as model;
import 'package:whatsapp/storsge/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../common/utils/utills.dart';
import '../../contact/controller/select_contact_controller2.dart';

final groupRepositoryProvider=Provider((ref) =>
    GroupRepository(auth:FirebaseAuth.instance,fire:FirebaseFirestore.instance,ref:ref),);
class GroupRepository{
  final FirebaseAuth auth;
  final FirebaseFirestore fire;
  final Ref ref;
  GroupRepository({
    required this.auth,
    required this.fire,
    required this.ref,
});
  Future<void> filterAppContacts(List<Contact> filteredContacts ) async {

    final allContacts = ref
        .read(getContactsProvider)
        .value ?? [];


    for (var contact in allContacts) {
      if (contact.phones.isNotEmpty) {
        var phoneNumber = contact.phones.first.number.replaceAll(' ', '');
        var userCollection = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get();

        if (userCollection.docs.isNotEmpty) {
          filteredContacts.add(contact);
        }
      }
    }
  }
  void CreateGroup(BuildContext context, String name, File profile, List<Contact> selectedContact) async {
    try {
      String text = '';
      List<String> uids = [];
      for (int i = 0; i < selectedContact.length; i++) {
        var contact = selectedContact[i];
        if (contact.phones.isEmpty || contact.phones.isEmpty) {
          continue; // Skip this contact if it has no phone numbers
        }
        var usercollection = await FirebaseFirestore.instance
            .collection('users')
            .where(
          'phoneNumber',
          isEqualTo: contact.phones[0].number.replaceAll(' ', ''),
        )
            .get();

        if (usercollection.docs.isNotEmpty && usercollection.docs[0].exists) {
          uids.add(usercollection.docs[0].data()['uid']);
        }
      }

      var groupId = const Uuid().v1();
      String profileUrl = await ref
          .read(FirebaseStorageRepositoryProvider)
          .storeFiletofirstorage(
        'group/$groupId',
        profile,
      );

      Map<String, int> unreadMessageCount = {};
      for (var uid in [auth.currentUser!.uid, ...uids]) {
        unreadMessageCount[uid] = 0;
      }

      // Initialize the Group with the adminsUid list containing the creator's UID
      model.Group group = model.Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: text,
        groupPic: profileUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
        unreadMessageCount: unreadMessageCount,
       adminUid: auth.currentUser!.uid // Set the creator as the initial admin
      );

      await fire.collection('groups').doc(groupId).set(group.toMap());
      // Rest of the function remains the same
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }
  void addUser(BuildContext context, List<Contact> selectedContact, String groupId) async {
    try {
      List<String> uidsToAdd = [];

      // Fetch current group data
      var groupDoc = await fire.collection('groups').doc(groupId).get();
      List<String> currentMembersUid = List<String>.from(groupDoc.data()?['membersUid'] ?? []);

      for (int i = 0; i < selectedContact.length; i++) {
        var contact = selectedContact[i];
        if (contact.phones.isEmpty || contact.phones.isEmpty) {
          continue; // Skip this contact if it has no phone numbers
        }

        var userCollection = await FirebaseFirestore.instance
            .collection('users')
            .where(
          'phoneNumber',
          isEqualTo: contact.phones[0].number.replaceAll(' ', ''), // Make sure to format the phone number correctly
        )
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          String uid = userCollection.docs[0].data()['uid'];

          // Check if the user is already in the group
          if (!currentMembersUid.contains(uid)) {
            uidsToAdd.add(uid); // Add user UID to the list of users to add
          } else {
            // Show a snackbar if the user is already a member
            ShowSnakBar(context: context, content: '${contact.displayName} is already a member of this group.');
          }
        } else {
          // Show a snackbar if the user does not own the application
          ShowSnakBar(context: context, content: '${contact.displayName} does not use this application.');
        }
      }

      if (uidsToAdd.isNotEmpty) {
        // Append new UIDs to the existing list
        currentMembersUid.addAll(uidsToAdd);

        await fire.collection('groups').doc(groupId).update({
          'membersUid': currentMembersUid,
        });

        ShowSnakBar(context: context, content: 'Members added successfully.');
      }

    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }

  void deleteMember(BuildContext context, String groupId, String memberId) async {
    try {
      // Fetch the group document
      var groupDoc = await fire.collection('groups').doc(groupId).get();
      List<String> currentMembersUid = List<String>.from(groupDoc.data()?['membersUid'] ?? []);
      String adminsUid =auth.currentUser!.uid;

      // Check if the current user is an admin
      if (!adminsUid.contains(auth.currentUser!.uid)) {
        ShowSnakBar(context: context, content: 'Only admins can remove members');
        return;
      }

      // Remove the member from the group
      if (currentMembersUid.contains(memberId)) {
        currentMembersUid.remove(memberId);

        // Update Firestore with the new list of members
        await fire.collection('groups').doc(groupId).update({
          'membersUid': currentMembersUid,
        });

        ShowSnakBar(context: context, content: 'Member removed successfully');
      } else {
        ShowSnakBar(context: context, content: 'Member not found in the group');
      }
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }


}
