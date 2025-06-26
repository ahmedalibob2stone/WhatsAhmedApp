import 'package:whatsapp/features/auth/viewmodel/auth_userviewmodel.dart';
import 'package:whatsapp/model/user_model/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:whatsapp/features/call/controller/call_controller.dart';
import 'package:whatsapp/features/call/screan/call_pickup_screan.dart';

import 'package:flutter/material.dart';
import '../../../common/widgets/Loeading.dart';
import '../../../constant.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/Bottomfileforchat.dart';
import '../widgets/chat_list.dart';

class MobileChatScrean extends ConsumerWidget {
  final String name;
  final String uid;
  final String profilePic;
  final bool isGroupChat;


  const MobileChatScrean(

      {
    Key? key,
    required this.isGroupChat,
    required this.name,
    required this.uid,
    required this.profilePic,



  }) : super(key: key);

  void createCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).CreateCall(
        context, name, uid, profilePic, isGroupChat);
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isLargeScreen = constraints.maxWidth > 600;

        return CallPickUp(
          scaffold: Scaffold(
            appBar: AppBar(
              backgroundColor: kkPrimaryColor,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              title: isGroupChat
                  ?   InkWell(
                onTap: (){
          Navigator.pushNamed(
          context,
          PageConst.Profile,
          arguments: {

            'name': name,
            'uid': uid,
            'profile':profilePic,
            'isGroupChat': true,





          },
          );
          },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.withValues(),
                  radius: isLargeScreen ? 30 : 20,
                  backgroundImage: profilePic.isNotEmpty
                      ? CachedNetworkImageProvider(profilePic)
                      : null,
                  child: profilePic.isEmpty
                      ? const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  )
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: name,
                          style: TextStyle(
                            fontSize: isLargeScreen ? 20 : 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
                  : StreamBuilder<UserModel>(
                stream: ref
                    .read(UserViewModel.notifier)
                    .userDatabyId(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Loeading();
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PageConst.Profile,
                        arguments: {
                          'name': snapshot.data!.name,
                          'uid': snapshot.data!.uid,
                          'profile': snapshot.data!.profile,
                          'isGroupChat': false,
                        },
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.withValues(),
                          radius: isLargeScreen ? 30 : 20,
                          backgroundImage: snapshot.data!.profile.isNotEmpty
                              ? CachedNetworkImageProvider(snapshot.data!.profile)
                              : null,
                          child: snapshot.data!.profile.isEmpty
                              ? const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          )
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: name,
                                  style: TextStyle(
                                    fontSize: isLargeScreen ? 20 : 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(text: '\n'),
                                TextSpan(
                                  text: snapshot.data!.isOnline,
                                  style: TextStyle(
                                    fontSize: isLargeScreen ? 15 : 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () => createCall(ref, context),
                  icon: Icon(
                    Icons.video_call,
                    size: isLargeScreen ? 30 : 24,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.call,
                    size: isLargeScreen ? 30 : 24,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    size: isLargeScreen ? 30 : 24,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ChatList(
                    reciverUserId: uid,
                    isGroupChat: isGroupChat,
                  ),
                ),
                BottomFileforChat(

                  reciverUserId: uid,
                  isGroupChat: isGroupChat

                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
