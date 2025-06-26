
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/Error_Screan.dart';
import '../../../common/widgets/Loeading.dart';
import '../../../constant.dart';
import '../controller/select_contact_controller2.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
   // final screenHeight = MediaQuery.of(context).size.height;

    // Adjust font sizes and padding based on screen width
    final double appBarTitleFontSize = screenWidth * 0.045; // 4.5% of screen width
    final double listTileFontSize = screenWidth * 0.045; // 4.5% of screen width
    final double listTileRadius = screenWidth * 0.08; // 8% of screen width
    final double listTilePadding = screenWidth * 0.02; // 2% of screen width

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kkPrimaryColor,
        title: Text(
          'Select contact',
          style: TextStyle(
            fontSize: appBarTitleFontSize,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
        data: (contactList) => ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            final contact = contactList[index];
            return InkWell(
              onTap: () => selectContact(ref, contact, context),
              child: Padding(
                padding: EdgeInsets.only(bottom: listTilePadding),
                child: ListTile(
                  title: Text(
                    contact.displayName,
                    style: TextStyle(
                      fontSize: listTileFontSize,
                    ),
                  ),
                  leading: contact.photo == null
                      ? null
                      : CircleAvatar(
                    backgroundImage: MemoryImage(contact.photo!),
                    radius: listTileRadius,
                  ),
                ),
              ),
            );
          },
        ),
        error: (err, trace) => ErrorScreen(error: err.toString()),
        loading: () => const Loeading(),
      ),
    );
  }
}
