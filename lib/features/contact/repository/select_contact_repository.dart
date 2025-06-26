

import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp/model/user_model/user_model.dart';


final contactsRepositoryProvider = Provider(
      (ref) {
    return ContactsRepository(firestore: FirebaseFirestore.instance);
  },
);

class ContactsRepository {
  final FirebaseFirestore firestore;

  ContactsRepository({required this.firestore});

  Future<List<List<UserModel>>> getAllContacts() async {
    List<UserModel> firebaseContacts = [];
    List<UserModel> phoneContacts = [];

    try {
      // Fetch contacts from phone
      List<Contact> phoneContacts = [];
      if (await FlutterContacts.requestPermission()) {
        phoneContacts = await FlutterContacts.getContacts(withProperties: true);
      }

      // Fetch users from Firebase
      List<UserModel> firebaseContacts = [];
      var userCollection = await firestore.collection('users').get();
      for (var document in userCollection.docs) {
        firebaseContacts.add(UserModel.fromMap(document.data()));
      }

      // Separate phone contacts into app users and non-app users
      List<UserModel> appContacts = [];
      List<UserModel> nonAppContacts = [];

      for (var contact in phoneContacts) {
        String phoneNumber = contact.phones.isNotEmpty
            ? contact.phones.first.number.replaceAll(' ', '')
            : '';
        bool isAppUser = false;

        for (var firebaseContact in firebaseContacts) {
          if (firebaseContact.phoneNumber == phoneNumber) {
            appContacts.add(firebaseContact);
            isAppUser = true;

            break;
          }
        }

        if (!isAppUser) {
          nonAppContacts.add(UserModel(
            name: contact.displayName,
            phoneNumber: phoneNumber,
            uid: '',
            profile: '',
            isOnline: 'false', groupId: [], statu: '',
          ));
        }
      }

      return [appContacts, nonAppContacts];
    } catch (e) {
      log(e.toString());
    }
    return [firebaseContacts, phoneContacts];
  }
}

























