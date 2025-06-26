import 'package:whatsapp/model/user_model/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../common/widgets/Loeading.dart';
import '../../../constant.dart';
import '../../../model/group/group.dart';
import '../../auth/viewmodel/auth_userviewmodel.dart';
import '../../group/controller/group_controller.dart';
import '../conrroller/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;




    return Scaffold(

      appBar: AppBar(

          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: kkPrimaryColor),
          ),

      ),
      backgroundColor: Colors.white,




      body:



          widget.isGroupChat
              ? _buildGroupProfile(context, screenWidth, screenHeight)
              : _buildUserProfile(context,screenWidth, screenHeight),


    );
  }

  Widget _buildGroupProfile(BuildContext context,double screenWidth, double screenHeight) {
    return StreamBuilder<Group>(
      stream: ref.read(chatControllerProvider.notifier).GroupData(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loeading();
        }

        final group = snapshot.data!;
       // final Admin = group.adminUid == ref.read(UserViewModel.notifier).userDatabyId(widget.uid);
        final isAdmin = snapshot.data!.adminUid==FirebaseAuth.instance.currentUser!.uid;

        //  final Admin=snapshot.data!.membersUid.where(snapshot.dat);
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.withValues(),
                  radius: screenWidth * 0.15,
                  backgroundImage: group.groupPic.isNotEmpty
                      ? CachedNetworkImageProvider(group.groupPic)
                      : null,
                  child: group.groupPic.isEmpty
                      ? const Icon(
                    Icons.group,
                    size: 30,
                    color: Colors.white,
                  )
                      : null,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIconButton(
                      icon: Icons.call, onPressed: () {}, screenWidth: screenWidth),
                    _buildIconButton(
                    icon: Icons.video_call, onPressed: () {}, screenWidth: screenWidth),
                    ],

                  ),
                ),
                const SizedBox(height: 10),
                Container(height: 15,color: Colors.grey[200]),

                // Inside your _buildGroupProfile method

                if (isAdmin) ...[
                  _buildAddMembersButton(screenWidth),
                  Container(height: 15, color: Colors.grey[200]),
                ],

                if(!isAdmin) ...[
                  _buildMembers(screenWidth),
                  Container(height: 15,color: Colors.grey[200]),
                ],

                // const Divider(),
                ...group.membersUid.map((uid) {
                  return StreamBuilder<UserModel>(
                    stream: ref.read(UserViewModel.notifier).userDatabyId(uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loeading();
                      }

                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      final member = snapshot.data!;
                      final isMemberAdmin = group.adminUid.contains(member.uid);
                      final isCurrentUser = member.uid == FirebaseAuth.instance.currentUser!.uid;

                      return InkWell(
                        onTap: isCurrentUser
                            ? null  // Disable click for the current user
                            : () {
                          // Navigate to chat screen for other members
                          Navigator.pushNamed(
                            context,
                            PageConst.mobileChatScrean,
                            arguments: {
                              'name': member.name,
                              'uid': member.uid,
                              'profilePic': member.profile,
                              'isGroupChat': false,
                            },
                          );
                        },

                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(member.profile),
                            radius: 20,

                          ),
                          title: Text(
                            isCurrentUser ? 'You' : member.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: isMemberAdmin
                              ? const Text(
                            "Admin",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : Text(
                            member.statu,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: isAdmin
                              ? IconButton(
                            onPressed: () {
                              try {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Member'),
                                      content: Text('Are you sure you want to delete this member?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            final index = group.membersUid.indexOf(uid);

                                            if (index != -1) {
                                              ref.read(groupControllerProvider).deleteMember(
                                                context,
                                                group.groupId,
                                                group.membersUid[index],
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Member not found in group")),
                                              );
                                            }
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } catch (e) {
                                debugPrint('Error deleting member: $e');
                              }
                            },
                            icon: Icon(Icons.person_remove, color: kkPrimaryColor),
                          )
                              : isMemberAdmin
                              ? const Text(
                            "",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : SizedBox.shrink(),  // Fallback widget


                        ),
                      );
                    },
                  );
                }).toList(),



                const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserProfile(BuildContext context,double screenWidth, double screenHeight) {
    return StreamBuilder<UserModel>(
      stream: ref.read(UserViewModel.notifier).userDatabyId(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loeading();
        }

        final user = snapshot.data!;
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(user.profile),
                  backgroundColor: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    user.phoneNumber,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(
                    user.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(
                    user.statu,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Center(
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [BoxShadow(
                                color: Colors.grey.withValues(),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: Offset(0, 4),
                              )],
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: IconButton(icon:Icon(Icons.call,color: kkPrimaryColor,), onPressed: () {
                            Navigator.pop(context);
                          },),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [BoxShadow(
                                color: Colors.grey.withValues(),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: Offset(0, 4),
                              )],
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: IconButton(icon:Icon(Icons.video_call,color: kkPrimaryColor), onPressed: () {
                            Navigator.pop(context);
                          },),
                        ),
                      ),
                    ],

                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.black87),
                const ListTile(
                  leading: Icon(Icons.enhanced_encryption,
                      color: Colors.grey, size: 20),
                  title: Text(
                    "Encryption",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    "Messages and calls are end-to-end encrypted. Tap to verify.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const ListTile(
                  leading:
                  Icon(Icons.hide_source_rounded, color: Colors.grey, size: 20),
                  title: Text(
                    "Disappearing messages",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text("Off"),
                ),
                const ListTile(
                  leading: Icon(Icons.lock_clock_outlined,
                      color: Colors.grey, size: 20),
                  title: Text(
                    "Lock and hide this chat on this device",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(""),
                ),
                const Divider(color: Colors.black87),
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.red, size: 20),
                  title: Text(
                    'Block ${user.phoneNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.report, color: Colors.red, size: 20),
                  title: Text(
                    'Report ${user.phoneNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildIconButton({required IconData icon, required Function() onPressed, required double screenWidth}) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 4),
            )
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: IconButton(icon: Icon(icon, color: kkPrimaryColor), onPressed: onPressed),
      ),
    );
  }

  Widget _buildAddMembersButton(double screenWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          PageConst.Add_Usr_To_Group,
          arguments: {'GroupId': widget.uid},
        );
      },
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.00),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(),
                spreadRadius: 2,
                blurRadius: 1,
                offset: Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: const Icon(Icons.person_add, color: kkPrimaryColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  'Add Members',
                  style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: kkPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildMembers(double screenWidth){
    return  Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
            color: Colors.grey.withValues(),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 3),
          )],
          borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              ' Members',
              style: const TextStyle(
                  fontSize: 18,
                  color:kkPrimaryColor

              ),
            ),
          ),


        ],
      ),
    );
  }

  Widget buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color titleColor = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: kkPrimaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
    );
  }
}
