import 'package:whatsapp/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utills.dart';
import 'package:whatsapp/model/user_model/user_model.dart';

final selectContactsRepositoryProvider = Provider(
      (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(
            context,
            PageConst.mobileChatScrean,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,


            },
          );
        }
      }

      if (!isFound) {
        ShowSnakBar(
          context: context,
          content: 'This number does not exist on this app.',
        );
      }
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }
}