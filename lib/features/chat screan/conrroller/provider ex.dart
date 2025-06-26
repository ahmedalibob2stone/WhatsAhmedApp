



import 'dart:io';

import 'package:whatsapp/common/Provider/Message_reply.dart';
import 'package:whatsapp/common/enums/enum_massage.dart';
import 'package:whatsapp/features/auth/viewmodel/auth_userviewmodel.dart';
import 'package:whatsapp/features/chat%20screan/repositories/chat_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final  providercontrollerex=Provider((ref) {
  final chatRepository=ref.watch(chatRepositoryProvider);

  return providerex (chatRepository:chatRepository, ref:ref, );
});
class providerex{
  final ChatRepository chatRepository;
  late Ref ref;

  providerex({
    required this.chatRepository,required this.ref
});
  void sendGIFMessage(BuildContext context,
      String gif, String reciveUserId,bool isGroupChat) {
    //https://giphy.com/gifs/love-i-you-ily-eocJr1HAyDbTDGgyFG
    //https://i.giphy.com/media/eocJr1HAyDbTDGgyFG/200.gif
   // int gifUrl = gif.lastIndexOf('_') + 1;
  //  String GifSubString = gif.substring(gifUrl);
   // String NewGif = 'https://i.giphy.com/media/$GifSubString/200.gif';

    final massageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendGIFMessage(context: context,
            gif: gif,
            reciveUserId: reciveUserId,
            sendUser: value!,
            messageReply: massageReply,isGroupChat: isGroupChat));
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }
  void SendFileMassage(BuildContext context,
      File file,
      String reciveUserId,
      EnumData massageEnum,
      bool isGroupChat,
      ) {
    final massageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.SendFileMassage(
            context: context,
            file: file,
            reciveUserId: reciveUserId,
            senderUserDate: value!,

            massageEnum: massageEnum,
            messageReply: massageReply!,
            isGroupChat: isGroupChat),
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }
  void sendTextMessage(BuildContext context, String text, String reciveUserId,bool isGroupChat) {
    final massageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage
          (context: context,
            text: text,
            reciveUserId: reciveUserId,
            sendUser: value!,
            messageReply: massageReply,
            isGroupChat: isGroupChat));

    ref.read(messageReplyProvider.notifier).update((state) => null);


  }

}