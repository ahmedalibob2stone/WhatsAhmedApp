import 'dart:io';
import 'package:whatsapp/features/auth/viewmodel/auth_userviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utills.dart';
import '../../../model/status/status.dart';
import '../repository/status_repository.dart';

final StatusViewModel = StateNotifierProvider<StatusController, StatusState>((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(statusRepository: statusRepository, ref: ref);
});




enum StatusState {
  initial,
  loading,
  success,
  error,
}
class StatusController extends StateNotifier<StatusState> {
  final StatusRepository statusRepository;
  final Ref ref;

  StatusController({
    required this.statusRepository,
    required this.ref,
  })  : super(StatusState.initial);

  void setLoading() => state = StatusState.loading;
  void setSuccess() => state = StatusState.success;
  void setError() => state = StatusState.error;

  void addStatus(
      File file,
      String message,
      BuildContext context,

      ) async {
    final userData = ref.read(userDataAuthProvider);

    userData.whenData((value)async {
      try{
        if (value != null) {
          ref.read(StatusViewModel.notifier).setLoading();
        statusRepository.uploadStatus(
          username: value.name,
          profilePic: value.profile,
          phoneNumber: value.phoneNumber,
          statusImage: file,
          statusMessage: message,
          context: context,
        );
      }  else {
          ShowSnakBar(context: context, content: 'User data not available');
        }
        ref.read(StatusViewModel.notifier).setSuccess();
        ShowSnakBar(context: context, content: 'Status uploaded successfully');

      }catch(e){
        ref.read(StatusViewModel.notifier).setError();
        ShowSnakBar(context: context, content: 'Failed to upload status');
      }

    });
  }

  Future<List<Status>> getStatus(BuildContext context ) async {

   return await statusRepository.getStatus(context);
  }
  Future<List<Status>> GetStatus() {
    return statusRepository.GetStatus();
  }
  Future<void> deleteStatus(int index,List<String>photoUrls,BuildContext context) async {
    return await statusRepository.deleteStatus(index,photoUrls,context);
  }
  }


