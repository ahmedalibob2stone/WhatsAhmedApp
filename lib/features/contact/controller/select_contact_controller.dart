

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp/model/user_model/user_model.dart';
import '../repository/select_contact_repository.dart';


final contactsControllerProvider =  StateNotifierProvider<SelectContactController, AsyncValue<List<List<UserModel>>>>(
      (ref) {
    final contactsRepository = ref.watch(contactsRepositoryProvider);
    return SelectContactController(selectContactRepository:contactsRepository);
  },
);
final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(contactsRepositoryProvider);
  return SelectContactController(

    selectContactRepository: selectContactRepository,
  );
});



class SelectContactController extends StateNotifier<AsyncValue<List<List<UserModel>>>> {

  final ContactsRepository selectContactRepository;
  SelectContactController({

    required this.selectContactRepository,
  })  : super(const AsyncValue.loading()) {
    _selectContact();
  }

//selectContactRepository
  void _selectContact()async {
    try {
      final contacts = await selectContactRepository.getAllContacts();
      state = AsyncValue.data(contacts);
    } catch (e) {
    //  state = AsyncValue.error(e);
    }
  }
}





