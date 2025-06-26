

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/group_repository.dart';
final groupControllerProvider=Provider((ref) {
  final groupRepository=ref.read(groupRepositoryProvider);
  return GroupController(groupRepository: groupRepository, ref: ref);
});


class GroupController{
  final GroupRepository groupRepository;
  final Ref ref;

  GroupController({
     required this.groupRepository, required this.ref
});
  Future<void> filterAppContacts(List<Contact> filteredContacts ){
    return  groupRepository.filterAppContacts(filteredContacts);
  }
  void createGroup(BuildContext context,String name,File profile,List<Contact>selectedContact)async{
    groupRepository.CreateGroup(context, name, profile, selectedContact);
  }

  void addUser(BuildContext context, List<Contact> selectedContact,String groupId) async {
    groupRepository.addUser(context, selectedContact,groupId);

  }
  void deleteMember(BuildContext context, String groupId, String memberId) async {
    groupRepository.deleteMember(context, groupId,memberId);

  }


}