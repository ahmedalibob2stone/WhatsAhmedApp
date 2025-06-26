

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/auth_repository.dart';


final authviewProvider = StateNotifierProvider<Auth_ViewModel, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return Auth_ViewModel(authRepository: authRepository);
});


class AuthState {
  final bool isLoading;

  final String? errorMessage;

  AuthState({
    this.isLoading = false,

    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,

    String? errorMessage,
  }) {
    return AuthState(

      isLoading: isLoading ?? this.isLoading,

      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
class Auth_ViewModel extends StateNotifier<AuthState> {


  final AuthRepository authRepository;

  //final ProviderRef ref;

  Auth_ViewModel({required this.authRepository,
    //required this.ref

  }) : super(AuthState());

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: true);
  }


  void setError(String errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }
  void signInWithPhonenumber(BuildContext context, String phoneNumber) {
    state = state.copyWith(isLoading: true);
    try {
      authRepository.signInWithPhoneNumber(context, phoneNumber);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  void phoneauth(BuildContext context, String phoneNumber) {
    authRepository.phoneauth(context, phoneNumber);
  }

  void sendCode ({required String verificationId,required String userOTP,required BuildContext context}) {
    state = state.copyWith(isLoading: true);
    try{
      authRepository.sendCode(verificationId:verificationId, userOTP:userOTP, context: context );


    }catch(e){

    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      authRepository.verifyOTP(
          context: context, verificationId: verificationId, userOTP: userOTP);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }


}