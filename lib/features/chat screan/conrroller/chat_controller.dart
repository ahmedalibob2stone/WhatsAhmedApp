
import 'dart:async';


import 'package:whatsapp/features/chat%20screan/conrroller/provider%20ex.dart';
import 'package:whatsapp/features/chat%20screan/repositories/chat_repository.dart';
import 'package:whatsapp/model/contact/chat_contact.dart';
import 'package:whatsapp/model/massage/massage.dart';
import '../../../model/group/group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final  chatControllerProvider=StateNotifierProvider<ChatController,ChatState>((ref) {
 final chatRepository=ref.watch(chatRepositoryProvider);
 final Riverpodex=ref.watch(providercontrollerex);
 return ChatController (chatRepository:chatRepository, ex:Riverpodex , );
});
final chatContacts = StreamProvider<List<ChatContact>>((ref) {
 final chat = ref.watch(chatRepositoryProvider);
      return chat.getDateChatContacts();
});
class ChatState {


 final bool isLoading;
 final bool isSuccess;
 final String? error;

 ChatState( {


  this.isLoading = false,
  this.error,
  this.isSuccess=false,

 });

 ChatState copyWith({

  bool? isLoading,
  String? error,
  bool? isSuccess,
 }) {
  return ChatState(

   isLoading: isLoading ?? this.isLoading,
   error: error,
   isSuccess:isSuccess?? this.isSuccess,

  );
 }
}

class ChatController extends StateNotifier<ChatState>  {
 final ChatRepository chatRepository;
  final providerex ex;


 ChatController( {required this.chatRepository,required this.ex})
     : super(ChatState());



 Stream<List<ChatContact>> chatListContact() {
  return chatRepository.getDateChatContacts();
 }


 Stream<List<Message>> chatstream(String reciverUserId) {
  return chatRepository.getStreamMassages(reciverUserId);
 }




 Stream<List<ChatContact>> getallListMASSAGEmODEL() {
  return chatRepository.getallListMASSAGEmODEL();
 }


 Stream<List<Group>> chatGroups( ) {
  return chatRepository.getChatGroups();
 }

 Stream<List<Message>> groupchatstream(String groupId) {
  return chatRepository.getGroupChatstream(groupId);
 }
 Stream<List<ChatContact>> search({required String searchName}) {
  return chatRepository.searchContact(searchName: searchName);
 }

 Stream<List<Group>>searchGroup({required String searchName}){
  return chatRepository.searchGroup(searchName: searchName);
 }

 void sendTextMessage(BuildContext context, String text, String reciveUserId,bool isGroupChat) {

  try{
   state = state.copyWith(isLoading: true);
    ex.sendTextMessage(context, text, reciveUserId, isGroupChat);
   state = state.copyWith(isLoading: false, isSuccess: true);
  }catch(e){
   state = state.copyWith(isLoading: false, error: e.toString());
  }


 }



 void deletmassage(
     {required BuildContext context, required String reciveUserId, required String messageId}) async {
  state = state.copyWith(isLoading: true);
  try{
   state = state.copyWith(isLoading: false);
   chatRepository.deletMassage(
       context: context, reciveUserId: reciveUserId, messageId: messageId);
  }catch(e){
   state = state.copyWith(error: e.toString(), isLoading: false);
  }

 }


void setChatMassageSeen(
    BuildContext context,
    String reciverUserId,
    String messageId,
    )async{

  try{

   chatRepository.setChatMassageSeen(context, reciverUserId, messageId);
  }catch(e){
  }

}
 void  markMessagesAsSeen(String chatId,String ContactId,)async{
  state = state.copyWith(isLoading: true);
  try{
   state = state.copyWith(isLoading: false);
   chatRepository.markMessagesAsSeen(chatId,ContactId);
  }catch(e){
   state = state.copyWith(error: e.toString(), isLoading: false);
  }
 }
 void  openGroupChat(String groupId,)async{
  state = state.copyWith(isLoading: true);
  try{
   state = state.copyWith(isLoading: false);
   chatRepository.openGroupChat(groupId);
  }catch(e){
   state = state.copyWith(error: e.toString(), isLoading: false);
  }

 }



 void deletChatMassage( BuildContext context, String reciveUserId)async{
  try{
   chatRepository.deleteChatMessages(  context: context, receiveUserId: reciveUserId);

  }catch(e){
  }

 }

 void deletChatMassageGroup(BuildContext context,String groupId)async{
  try{
   chatRepository.deleteChatMessagesGroup(context: context, groupId: groupId);

  }catch(e){
  }

 }
 Stream<Group>GroupData(String groupId){
return chatRepository.getGroupData( groupId);
 }
}