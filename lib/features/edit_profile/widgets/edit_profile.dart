

import 'dart:io';

import 'package:whatsapp/common/utils/utills.dart';
import 'package:whatsapp/features/edit_profile/view_model/update_date_user.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


class EditProfile extends ConsumerStatefulWidget {
  final profile;
  final uid;
  final phoneNumber;
  final name;
  final statu;
  const EditProfile( {Key? key,required this.statu, required this.uid,required this.phoneNumber,required this.name,required this.profile}) : super(key: key);

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final _formkey=GlobalKey<FormState>();
  final TextEditingController statu=TextEditingController();
  final TextEditingController namecontroller=TextEditingController();
  File? image;
  bool isLoading=false;
  bool _validatestatu=true;
  bool _validateName=true;


  //selectImage(),Pickphoto()

  void selectImage()async {
    //image=await  PickImage(ImageSource.gallery);

    image=await  pickImageFromGallery(context);
    setState(() {

    });
   ref.read(UpdateUserDateProvider.notifier).updatePhotoUrl(image!,context);

  }
  void Pickphoto()async {
    image=await  tackImage(context);
    setState(() {

    });
   ref.read(UpdateUserDateProvider.notifier).updatePhotoUrl(image!,context);
  }
  void updatestatusfirebase()async{
    setState(() {
      statu.text.trim().length<10
          ? _validatestatu =false :true;
    });
  //  String Statu=statu.text.trim();
  //   ref.read(authControllerProvider).addstatu(context,Statu);

    if(_validatestatu){
      //  authController.RU.doc(widget.curentuserid)


      ref.read(UpdateUserDateProvider.notifier).UpdateStatus(context,statu.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update Bio')));
      _formkey.currentState.toString();


    }else{
      CircularProgressIndicator(color: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed Update')));
      _formkey.currentState.toString();
    }
  }
  void updatename()async{

    setState(() {


    });
    namecontroller.text.trim().length<3 ||
        namecontroller.text.trim().isEmpty  ? _validateName =false :true;
    //  String Statu=statu.text.trim();
    //   ref.read(authControllerProvider).addstatu(context,Statu);

    if(_validateName){
      //  authController.RU.doc(widget.curentuserid)


      ref.read(UpdateUserDateProvider.notifier).updateName(context,namecontroller.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update Name')));
      _formkey.currentState.toString();


    }else{
      CircularProgressIndicator(color: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed Update ')));
      _formkey.currentState.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(UpdateUserDateProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(


          backgroundColor: Colors.white,
          elevation: 0.0,
          leading:GestureDetector(
            onTap: (){
Navigator.pop(context);
              //  Get.offAll(Register());
            },
            child:Icon(Icons.arrow_back,color:Colors.black),

          ),
          title: Text("Profile",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),

        ),
        body:SingleChildScrollView(
          child: Column(
            children: [

               SafeArea(
                   child:Container(
                     child: Center(
                       child: Padding(
                         padding: const EdgeInsets.only(top: 38.0),
                         child: Column(
                           children: [

                             Stack(
                               children: [
                                 userState.image==null?
                                 CircleAvatar(backgroundImage:
                                 NetworkImage(widget.profile),
                                   radius: 70,
                                   backgroundColor:Colors.grey,
                                 ):
                                 CircleAvatar(backgroundImage:

                                 FileImage(image!),
                                   backgroundColor:Colors.grey,
                                   radius: 70,
                                 ),
                                 Positioned(
                                   bottom: 10,
                                   //-10
                                   left: 100,

                                   child: IconButton(onPressed:(){
                                     // selectImage();
                                     userState.isLoading? CircularProgressIndicator():
                                     displayModalBottomSheet(context);
                                   },

                                     // selectImage,

                                     icon:


                                     Icon(
                                         Icons.add_a_photo
                                     ),
                                   ),
                                 )

                               ],
                             ),

                             Row(
                               children: [
                                 SizedBox(width: 16,),
                                 Icon(Icons.person,color: Colors.grey,size: 20,) ,
                                 SizedBox(width: 10,),
                                 namecontroller.text.isEmpty? Container(width: MediaQuery.of(context).size.width *0.75,
                                   // padding: EdgeInsets.all(20),
                                   child: TextField(
                                     controller: statu,
                                     decoration: InputDecoration(

                                       //  labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),

                                         hintText:'Name'
                                         ,errorText: _validatestatu ? null: "Name to Long"
                                     ),

                                   ),
                                 ):Container(width: MediaQuery.of(context).size.width *0.75,
                                   padding: EdgeInsets.all(20),
                                   child: TextField(
                                     controller: namecontroller,
                                     decoration: InputDecoration(

                                       //  labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),

                                         hintText:'${widget.name}',
                                         errorText: _validateName ? null: "Name to Long"
                                     ),

                                   ),
                                 ),
                                 IconButton(onPressed: updatename,
            icon: userState.isLoading
            ? CircularProgressIndicator()
               : Icon(Icons.done)),

                               ],
                             ),

                             SizedBox(height: 15,),

                             Row(
                               children: [
                                 SizedBox(width: 16,),
                                Icon(Icons.info_outline_rounded,color: Colors.grey,size: 20,) ,
                                 SizedBox(width: 10,),
                                 statu.text.isEmpty? Container(width: MediaQuery.of(context).size.width *0.75,
                                  // padding: EdgeInsets.all(20),
                                   child: TextField(
                                     controller: statu,
                                     decoration: InputDecoration(

                                     //  labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),

                                       hintText:'${widget.name}'
                                         ,errorText: _validatestatu ? null: "Bio to Long"
                                     ),

                                   ),
                                 ):Container(width: MediaQuery.of(context).size.width *0.75,
                                   padding: EdgeInsets.all(20),
                                   child: TextField(
                                     controller: statu,
                                     decoration: InputDecoration(

                                       //  labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),

                                  hintText:'${widget.statu}',
                                         errorText: _validatestatu ? null: "Bio to Long"
                                     ),

                                   ),
                                 ),
                                 IconButton(onPressed: updatestatusfirebase,icon: userState.isLoading
    ? CircularProgressIndicator()
        : Icon(Icons.done))

                               ],
                             ),
                             SizedBox(height: 50,),
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 SizedBox(width: 16,),
                                 Icon(Icons.phone,color: Colors.grey,size: 20,) ,
                                 Padding(
                                   padding: const EdgeInsets.only(left: 30.0),
                                   child: Container(
                                     child: Text(
                                       widget.phoneNumber,style:TextStyle(fontSize: 16),
                                     ),
                                   ),
                                 ),
                               ],
                             ),

                           ],
                         ),
                       ),
                     ),
                   )
               ),
            ],
          ),
        )



    );
  }
  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: () => {
                      Pickphoto()

                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_album_outlined),
                  title: new Text('Gallery'),
                  onTap: () => {
                    selectImage()

                  },
                ),
              ],
            ),
          );
        });
  }

}
