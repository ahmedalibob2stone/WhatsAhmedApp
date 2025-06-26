
import 'dart:io';

import 'package:whatsapp/model/user_model/user_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/auth_repository.dart';


final UserViewModel = StateNotifierProvider<authCurentUser, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authCurentUser(authRepository: authRepository);
});


final userDataAuthProvider = FutureProvider<UserModel?>((ref) async {
  final authController = ref.watch(UserViewModel.notifier);
  return await authController.getCurentUserData();
});
final userDataByIdProvider = StreamProvider.family<UserModel, String>((ref, userId) {
  final authViewModel = ref.watch(UserViewModel.notifier);
  return authViewModel.userDatabyId(userId);
});

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  AuthState({
    this.user,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ??  this.user,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
class authCurentUser extends StateNotifier<AuthState>  {


  final AuthRepository authRepository;
  //final ProviderRef ref;

  authCurentUser( {required this.authRepository,
    //required this.ref

  }): super(AuthState(user:null));

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: true);
  }

  void setSuccess(bool isSuccess) {
    state = state.copyWith(isSuccess: isSuccess);
  }

  void setError(String errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }


  Stream<UserModel>userDatabyId(String userId){
    return authRepository.userData(userId);
  }
  Stream<UserModel>myData(){
    return  authRepository.myData();
  }

  Future<UserModel?> getCurentUserData() async {
   // state = state.copyWith(isLoading: true);
    try {
      UserModel? userdate = await authRepository.getCurentUserData();
      if (userdate != null) {
       // state = state.copyWith(isSuccess: true, user: userdate);
      }
      return userdate;
    } catch (e) {
     // state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return null;
    } finally {
      //state = state.copyWith(isLoading: false);
    }
  }





  void saveUserDatetoFirebase({
    required BuildContext context,
    required String name,
    required File? profile,
    required String statu,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      authRepository.saveUserDatetoFirebase(
          context: context, name: name, profile: profile, Statu: statu);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }
  void setUserState(String isOnline){
    authRepository.setUserState(isOnline);
  }
}






