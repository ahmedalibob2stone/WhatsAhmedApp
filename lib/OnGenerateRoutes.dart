import 'dart:io';
import 'package:whatsapp/features/auth/screan/OTP_screan.dart';
import 'package:whatsapp/features/chat%20screan/widgets/profile_screan.dart';
import 'package:whatsapp/features/edit_profile/widgets/edit_profile.dart';
import 'package:whatsapp/features/chat%20screan/screan/mobile_chat_screan.dart';

import 'package:flutter/material.dart';

import 'constant.dart';
import 'features/auth/screan/login_screan.dart';
import 'features/auth/screan/user_information.dart';

import 'features/contact/screan/newpage.dart';
import 'features/group/screan/select_contacts_group.dart';
import 'features/group/widgets/add_user_in_group.dart';
import 'features/status/screan/select_status_screan.dart';

import 'features/status/screan/status_screan.dart';


class OnGenerateRoutes{
  static Route<dynamic>? route(RouteSettings settings){

    switch(settings.name){
      case PageConst.LoginScrean:{
        return routeBuilder(Login_Screan());
      }
      case PageConst.otp_screan:
        final verficationId=settings.arguments as String;
        {

          return routeBuilder(OTP_Scresn(verficationId:verficationId,));
        }
      case PageConst.user_information:
      // final verficationId=settings.arguments as String;
        {

          return routeBuilder(
              User_Information());
        }
      case PageConst.ContactsScrean:
      // final verficationId=settings.arguments as String;

     //   final arguments = settings.arguments as Map<String, dynamic>;
    //  final UserModel userModel = arguments['userModel'] as UserModel;

      {
          return MaterialPageRoute(
            builder: (context) =>
                //ContactCard(contactSource:userModel , onTap: () {  },)
               // SelectContactsScreen()
            ContactPage()

          );
        }
      case PageConst.mobileChatScrean:
        final arguments=settings.arguments as Map<String ,dynamic>;
        final name=arguments['name'];
        final uid=arguments['uid'];
        final isGroupChat=arguments['isGroupChat'];
        final profilePic=arguments['profilePic'];

        //'isGroupChat': true,
    //'profilePic': groupData.groupPic,


        // final verficationId=settings.arguments as String;
            {

          return routeBuilder(
              MobileChatScrean( isGroupChat: isGroupChat,name: name, uid: uid, profilePic: profilePic,
          ));
        }
      case PageConst.status:

        final  photofromgallery = settings.arguments as File;



        // final verficationId=settings.arguments as String;
            {

          return routeBuilder(
              SelectStatusScreen(file:photofromgallery,));
        }
      case PageConst.StatusScrean:
        final arguments=settings.arguments as Map<String ,dynamic>;
        final username = arguments['username'] ?? 'Unknown';
        final profilePic = arguments['profilePic'] ?? 'default_profile_pic_url';
        final phoneNumber = arguments['phoneNumber'] ?? 'Unknown';
        final PhotoUrl = arguments['PhotoUrl'] ?? 'default_photo_url';
        final massage = arguments['PhotoUrl'] ?? 'default_photo_url';
        final uid = arguments['uid'] ?? 'Unknown';
        if (

        username == null||
        profilePic == null
            || phoneNumber == null ||
            PhotoUrl == null
            || massage == null
            || uid == null
        ) {
           Container(child:Text( 'Invalid status data'));
        }



        // final verficationId=settings.arguments as String;
            {

          return routeBuilder(
              StatusScreen(username: username,profilePic:profilePic,phoneNumber: phoneNumber,photoUrls: PhotoUrl, massage: massage, uid: uid,

                //profilePic: profilePic,
                ));
        }
      case PageConst.GroupScrean:




        // final verficationId=settings.arguments as String;
            {

          return routeBuilder(
              CreateGroupScreen());
        }
      case PageConst.Profile:
        final arguments=settings.arguments as Map<String ,dynamic>;
        final name=arguments['name'];
        final uid=arguments['uid'];
          final profilePic=arguments['profile'];
        final isGroupChat=arguments['isGroupChat'];



        // final verficationId=settings.arguments as String;
            {


          return routeBuilder(
              ProfileScreen(uid: uid, profilePic:profilePic,name: name, isGroupChat: isGroupChat,));
        }
      case PageConst.Edit_Profile:
        final arguments=settings.arguments as Map<String ,dynamic>;
        final name=arguments['name'];
        final uid=arguments['uid'];
        final profile=arguments['profile'];
        final phoneNumber=arguments['phoneNumber'];
        final statu=arguments['statu'];
        //statu
        //phoneNumber



        // final verficationId=settings.arguments as String;
            {


          return routeBuilder(
              EditProfile(uid: uid,name: name,phoneNumber:phoneNumber ,profile: profile, statu: statu,));
        }
      case PageConst.Add_Usr_To_Group:
        final arguments=settings.arguments as Map<String ,dynamic>;
        final GroupId=arguments['GroupId'];




        // final verficationId=settings.arguments as String;
            {


          return routeBuilder(
              Add_Usr_To_Group(GroupId:GroupId));
        }
    //MobileChatScrean

//MobileChatScrean

      default:{
        return null;

      }
    }
  }

}
dynamic routeBuilder(Widget child){
  return MaterialPageRoute(builder: (context)=>child);

}
class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page not found "),
      ),
      body: Center(child: Text("Page not found "),),
    );
  }
}
