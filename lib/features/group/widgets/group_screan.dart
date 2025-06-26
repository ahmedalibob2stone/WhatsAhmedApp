
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/Error_Screan.dart';
import '../../../common/widgets/Loeading.dart';

import '../../contact/controller/select_contact_controller2.dart';


final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectContactsGroup> createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];
  List<Contact> appContacts = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref.read(selectedGroupContacts.notifier).update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive values
    final double titleFontSize = screenWidth * 0.045; // 4.5% of screen width
    final double iconSize = screenWidth * 0.07; // 7% of screen width
    final double avatarRadius = screenWidth * 0.07; // 7% of screen width
    final double padding = screenWidth * 0.02; // 2% of screen width

    return ref.watch(getContactsProvider).when(
      data: (contactList) => Expanded(
        child: ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            final contact = contactList[index];
            final bool isSelected = selectedContactsIndex.contains(index);

            return InkWell(
              onTap: () => selectContact(index, contact),
              child: Padding(
                padding: EdgeInsets.only(bottom: padding),
                child: ListTile(
                  title: Text(
                    contact.displayName,
                    style: TextStyle(
                      fontSize: titleFontSize,
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? Colors.grey[400] : Colors.grey.withValues(),
                    radius: avatarRadius,
                    child: isSelected
                        ? Icon(
                      Icons.done,
                      color: Colors.white,
                      size: iconSize,
                    )
                        : Icon(
                      Icons.person,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      error: (err, trace) => ErrorScreen(error: err.toString()),
      loading: () => const Loeading(),
    );
  }
}
