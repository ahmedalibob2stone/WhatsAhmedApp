
import 'dart:io';

import 'package:whatsapp/features/edit_profile/repository/repository_update_profile.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final UpdateUserDateProvider = StateNotifierProvider<Update_User_Date, UpdateState>((ref) {
  final authRepository = ref.watch(UpdateRepositoryProvider);
  return Update_User_Date(updateRepository: authRepository);
});




class UpdateState {

  final bool isLoading;
  final bool isSuccessUpdate;
  final String? errorMessage;
  final File? image;

  UpdateState({

    this.isLoading = false,
    this.isSuccessUpdate = false,
    this.errorMessage,
    this.image
  });

  UpdateState copyWith({

    bool? isLoading,
    bool? isSuccessUpdate,
    String? errorMessage,
    File?image
  }) {
    return UpdateState(

      isLoading: isLoading ?? this.isLoading,
      isSuccessUpdate: isSuccessUpdate ?? this.isSuccessUpdate,
      errorMessage: errorMessage ?? this.errorMessage,
      image: image ?? this.image,
    );
  }
}
class Update_User_Date extends StateNotifier<UpdateState>  {


  final UpdateRepository updateRepository;
  //final ProviderRef ref;

  Update_User_Date( {required this.updateRepository,
    //required this.ref

  }): super(UpdateState());







  Future<void>UpdateStatus(BuildContext context, String status) async {
    try {
      state = state.copyWith(isLoading: true);

      // استدعاء الوظيفة لإضافة الحالة إلى Firestore
      await updateRepository.UpDateState(context, status);

      // إذا تمت الإضافة بنجاح
      state = state.copyWith(isLoading: false, isSuccessUpdate: true);
    } catch (e) {
      // إذا حدث خطأ
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
  Future<void>  updateName(
      BuildContext context,
      String name
      )async{
    try {
      state = state.copyWith(isLoading: true);

      await updateRepository.updateName(context,name);

      state = state.copyWith(isLoading: false, isSuccessUpdate: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }

  }
  void updatePhotoUrl(

      File? profile,
      BuildContext context,

      )async{
    try {
      state = state.copyWith(isLoading: true);

      updateRepository.UpdatePhotoUrl(profile: profile,context: context);

      state = state.copyWith(isLoading: false, image: profile);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
