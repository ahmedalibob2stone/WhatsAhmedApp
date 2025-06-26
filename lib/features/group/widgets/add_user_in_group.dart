

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/Error_Screan.dart';
import '../../../common/widgets/Loeading.dart';
import '../../../constant.dart';
import '../../contact/controller/select_contact_controller.dart';
import '../../contact/controller/select_contact_controller2.dart';
import '../controller/group_controller.dart';
final selectedUser = StateProvider<List<Contact>>((ref) => []);
class Add_Usr_To_Group extends ConsumerStatefulWidget {
 final  String GroupId;
  const Add_Usr_To_Group({Key? key,required this.GroupId}) : super(key: key);

  @override
  ConsumerState<Add_Usr_To_Group> createState() => _Add_Usr_To_GroupState();
}

class _Add_Usr_To_GroupState extends ConsumerState<Add_Usr_To_Group> {
  List<int> selectedContactsIndex = [];
  List<Contact> appContacts = [];
  final TextEditingController groupcontroller =TextEditingController();



  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref.read(selectedUser.notifier).update((state) => [...state, contact]);
  }

  void AddNewUser(){

      ref.read(groupControllerProvider).addUser(context,
          ref.read(selectedUser),widget.GroupId);
      ref.read(selectedUser.notifier).update((state) => []);
      Navigator.pop(context);


  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double appBarTitleFontSize = screenWidth * 0.05; // 5% of screen width
    final double appBarSubtitleFontSize = screenWidth * 0.03; // 3% of screen width

    final double iconSize = screenWidth * 0.07; // 7% of screen width


    return Scaffold(
        appBar: AppBar(
          backgroundColor: kkPrimaryColor,
          leading: const BackButton(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add members',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: appBarTitleFontSize,
                ),
              ),
              const SizedBox(height: 3),
              ref.watch(contactsControllerProvider).when(
                data: (allContacts) {
                  return Text(
                    "${allContacts[0].length} contact${allContacts[0].length == 1 ? '' : 's'} on WhatsApp",
                    style: TextStyle(fontSize: appBarSubtitleFontSize),
                  );
                },
                error: (e, t) {
                  return const SizedBox();
                },
                loading: () {
                  return Text(
                    'counting...',
                    style: TextStyle(fontSize: appBarSubtitleFontSize),
                  );
                },
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, size: iconSize),
            ),

          ],
        ),

      body: ref.watch(getContactsProvider).when(
        data: (contactList) => ListView.builder(
            itemCount: contactList.length,
            itemBuilder: (context, index) {
              final contact = contactList[index];
              return InkWell(
                onTap: () => selectContact(index, contact),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child:

                  ListTile(
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                      ),

                    ),
                    leading: selectedContactsIndex.contains(index)
                        ? CircleAvatar(
                      backgroundColor: Colors.grey[400],
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.done,color: Colors.white,),
                      ),
                    )
                        :  CircleAvatar(
                        backgroundColor: Colors.grey.withValues(),
                        radius: 20,
                        //    backgroundImage: contact.photo!.isNotEmpty

                        child:
                        const Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        )

                    ),
                  ),
                ),
              );
            }),
        error: (err, trace) => ErrorScreen(
          error: err.toString(),
        ),
        loading: () => const Loeading(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:   kkPrimaryColor,
        onPressed: AddNewUser,

        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
