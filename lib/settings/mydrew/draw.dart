

  import 'package:whatsapp/constant.dart';
import 'package:whatsapp/features/auth/viewmodel/auth_userviewmodel.dart';
import 'package:whatsapp/model/user_model/user_model.dart';

  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  import '../../common/widgets/Loeading.dart';


  class mydrew extends ConsumerStatefulWidget {
    const mydrew({Key? key}) : super(key: key);

    @override
    ConsumerState<mydrew> createState() => _mydrewState();
  }

  class _mydrewState extends ConsumerState<mydrew> {
    @override
    Widget build(BuildContext context) {
      return Container(
        child: Drawer(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: InkWell(
              onTap: (){
              },
              child: ListView(

                children: [
       InkWell(
         onTap: (){},
         child: StreamBuilder<UserModel>(
           stream: ref.read(UserViewModel.notifier).myData(),
           builder: (context,snapshot){
             if(snapshot.connectionState == ConnectionState.waiting){
               return const Loeading();
             }

             return InkWell(

      onTap: (){
      Navigator.pushNamed(context, PageConst.Edit_Profile,arguments: {
      'name':snapshot.data!.name,'uid':snapshot.data!.uid,'profile':snapshot.data!.profile,'phoneNumber':snapshot.data!.phoneNumber,
        'statu':snapshot.data!.statu
      });
               }

              , child: UserAccountsDrawerHeader(accountName:
             Text(snapshot.data!.name,style: TextStyle(fontSize: 20,color: Colors.black),) ,
               accountEmail: Text(snapshot.data!.phoneNumber,style: TextStyle(fontSize: 15,color: Colors.grey),),
               currentAccountPicture: GestureDetector(
                 child: snapshot.data!.profile.isNotEmpty
                     ? CircleAvatar(
                   backgroundImage: NetworkImage(snapshot.data!.profile),
                   radius: 35,
                   backgroundColor: kkPrimaryColor,
                 )
                     : CircleAvatar(
                   child: Icon(Icons.person, color: Colors.white),
                   radius: 35,
                   backgroundColor: kkPrimaryColor,
                 ),
               ),

      decoration: BoxDecoration(
      color: Colors.grey[100],
      ),

      )
             );
           },

         ),
       ),


                  Column(
                      children: [


                        Container(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Column(
                            children: [

                              InkWell(
                                onTap: (){
                               //   Navigator.push(context, MaterialPageRoute(builder: (context)=> new catogery()));
                                },
                                child: ListTile(
                                  title: Text("Account",style: TextStyle(color: Colors.black,fontSize: 18.0),),
                                  leading:Icon(Icons.key) ,

                                  iconColor:kkPrimaryColor,
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,) ,




                                ),
                              ),


                              Divider(color: Colors.grey[400],),
                            ],

                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Column(
                            children: [

                              InkWell(
                                onTap: (){},
                                child: ListTile(
                                  title: Text("Privacy",style: TextStyle(color: Colors.black,fontSize: 18.0),),
                                  leading:Icon(Icons.privacy_tip) ,

                                  iconColor:kkPrimaryColor,
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,) ,




                                ),
                              ),


                              Divider(color: Colors.grey[400],),
                            ],

                          ),
                        ),
                        //ExpansionTile
                        Container(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Column(
                            children: [

                              InkWell(
                                onTap: (){
                             //     Navigator.push(context,MaterialPageRoute(builder: (context)=>myprofile()));

                                },
                                child: ListTile(
                               title: Text("Avatar",style: TextStyle(color: Colors.black,fontSize: 18.0),),
                                  leading:Icon(Icons.emoji_emotions) ,

                                  iconColor:kkPrimaryColor,
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,) ,




                                ),
                              ),


                              Divider(color: Colors.grey[400],),
                            ],

                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Column(
                            children: [

                              InkWell(
                                onTap: (){
                                    //Navigator.push(context,MaterialPageRoute(builder: (context)=>Changepassword()));
                                },
                                child: ListTile(
                                  title: Text("Chats",style: TextStyle(color: Colors.black,fontSize: 18.0),),
                                  leading:Icon(Icons.chat) ,

                                  iconColor:kkPrimaryColor,
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,) ,

                                ),
                              ),


                              Divider(color: Colors.grey[400],),
                            ],

                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Column(
                            children: [

                              InkWell(
                                onTap: (){
                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Shoppingcard()));
                                },
                                child: ListTile(
                                  title: Text("Notifications",style: TextStyle(color: Colors.black,fontSize: 18.0),),
                                  leading:Icon(Icons.notifications) ,

                                  iconColor:kkPrimaryColor,
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,) ,




                                ),
                              ),


                              Divider(color: Colors.grey[400],),
                            ],

                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Column(
                            children: [

                              InkWell(
                                onTap: (){
                                 // Navigator.push(context, MaterialPageRoute(builder:( context)=>Favorit()));

                                },
                                child: ListTile(
                                  title: Text("Storage and data",style: TextStyle(color: Colors.black,fontSize: 18.0),),
                                  leading:Icon(Icons.data_saver_off_outlined) ,

                                  iconColor:kkPrimaryColor,
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,) ,




                                ),
                              ),


                              Divider(color: Colors.grey[400],),
                            ],

                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Column(
                            children: [

                              InkWell(
                                onTap: (){
                            //      Navigator.push(context, MaterialPageRoute(builder:( context)=>OrderTracking()));

                                },
                                child: ListTile(
                                  title: Text("App language",style: TextStyle(color: Colors.black,fontSize: 18.0),),
                                  leading:Icon(Icons.language) ,

                                  iconColor:kkPrimaryColor,
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,) ,




                                ),
                              ),


                              Divider(color: Colors.grey[400],),
                            ],

                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Column(
                            children: [

                              InkWell(
                                onTap: (){},
                                child: ListTile(
                                  title: Text("Help",style: TextStyle(color: Colors.black,fontSize: 18.0),),
                                  leading:Icon(Icons.help) ,

                                  iconColor:kkPrimaryColor,
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,) ,




                                ),
                              ),


                              Divider(color: Colors.grey[400],),
                            ],

                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Column(
                            children: [

                              InkWell(
                                onTap: (){},
                                child: ListTile(
                                  title: Text("Invite afriend",style: TextStyle(color: Colors.black,fontSize: 18.0),),
                                  leading:Icon(Icons.person_rounded) ,

                                  iconColor:kkPrimaryColor,
                                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,) ,




                                ),
                              ),


                              Divider(color: Colors.grey[400],),
                            ],

                          ),
                        ),





                      ],
                    ),







  ]
              ),
            ),
          ),
        ),
      );
    }
  }
