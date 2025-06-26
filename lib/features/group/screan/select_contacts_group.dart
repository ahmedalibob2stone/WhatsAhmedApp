
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/utils/utills.dart';
import '../../../constant.dart';
import '../../contact/controller/select_contact_controller.dart';
import '../controller/group_controller.dart';

import '../widgets/group_screan.dart';
class CreateGroupScreen  extends ConsumerStatefulWidget {
  const CreateGroupScreen ({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen > {



  File?image;
  void selectImage()async {


    image=await  pickImageFromGallery(context);
    setState(() {

    });
  }
  void Pickphoto()async {
    image=await  tackImage(context);
    setState(() {

    });
  }


  final TextEditingController groupcontroller =TextEditingController();


  void CreateGroupe(){
    if(groupcontroller.text.trim().isNotEmpty && image!=null){
      ref.read(groupControllerProvider).createGroup(context, groupcontroller.text.trim(), image!,
          ref.read(selectedGroupContacts));

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    //tblq8888

    super.dispose();
    groupcontroller.dispose();
  }
  @override
  Widget build(BuildContext context) {


    final screenWidth = MediaQuery.of(context).size.width;

    final double appBarTitleFontSize = screenWidth * 0.05; // 5% of screen width
    final double appBarSubtitleFontSize = screenWidth * 0.03; // 3% of screen width



    final double iconSize = screenWidth * 0.07; // 7% of screen width

   return  Scaffold(
     appBar: AppBar(
       backgroundColor: kkPrimaryColor,
       leading: const BackButton(),
       title: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             'Create Group',
             style: TextStyle(
               color: Colors.white,
               fontSize: appBarTitleFontSize,
             ),
           ),
           const SizedBox(height: 3),
           ref.watch(contactsControllerProvider).when(
             data: (allContacts) {
               return Text(
                 "${allContacts[0].length} contact${allContacts[0].length == 1 ? '' : 's'} on WhatsApp",
                 style: TextStyle(fontSize: appBarSubtitleFontSize),
               );
             },
             error: (e, t) {
               return const SizedBox();
             },
             loading: () {
               return Text(
                 'counting...',
                 style: TextStyle(fontSize: appBarSubtitleFontSize),
               );
             },
           ),
         ],
       ),
       actions: [
         IconButton(
           onPressed: () {},
           icon: Icon(Icons.search, size: iconSize),
         ),

       ],
     ),
     body:  Center(
       child:     Column(
         //      crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const SizedBox(
             height: 20,
           ),
           Padding(
             padding: const EdgeInsets.only(top: 38.0),
             child: Stack(
               children: [
                 image==null?
                 CircleAvatar(backgroundImage: NetworkImage(
                     'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic'
                         '.jpg'),
                   radius: 80,
                 ):
                 CircleAvatar(backgroundImage:


                 FileImage(image!)
                   ,radius: 75,
                 ),
                 Positioned(
                   bottom: 10,
                   //-10
                   left: 110,

                   //80
                   child: IconButton(onPressed:(){
                     // selectImage();
                     displayModalBottomSheet(context);
                   },

                     // selectImage,

                     icon:


                     Icon(
                         Icons.add_a_photo
                     ),
                   ),
                 ),

               ],
             ),

           ),
           Container(
             margin:EdgeInsets.only(top
                 : 30.0),
             padding: EdgeInsets.only(left: 20.0,right: 20.0),
             decoration:BoxDecoration(

               borderRadius: BorderRadius.circular(0.0),
               color:  Colors.grey[400],
             ),
             child: TextFormField(
               controller:groupcontroller,

                 textInputAction: TextInputAction.done,
                 keyboardType: TextInputType.emailAddress,
                 decoration: InputDecoration(
                   icon: Icon(Icons.group),

                   hintText: " Enter  Group Name",border: InputBorder.none,
                 //  labelText: 'Enter  Group Name',



                 ),
                 // validator: (value) {
                 // if ( value?.indexOf("@")==-1 || value?.indexOf(".")==-1 ||value!.isEmpty) {
                 // return "plase Enter Email";
                 //}

                 //},

             ),
           ),

           Container(
             margin:EdgeInsets.only(top
                 : 10.0),
             alignment: Alignment.topLeft,
             padding: EdgeInsets.all(8),

             child: Text('Select Contacts',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),

           ),
        Divider(),
        const   SelectContactsGroup()

         ],
       ),
     ),
     floatingActionButton: FloatingActionButton(
       backgroundColor: kkPrimaryColor,
       onPressed: CreateGroupe,

       child: const Icon(
         Icons.done,
         color: Colors.white,
       ),
     ),
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

  ListTile myListTile({
    required IconData leading,
    required String text,
    IconData? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(top: 10, left: 20, right: 10),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.green,
        child: Icon(
          leading,
          color: Colors.white,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
          trailing,
          color: Colors.red
      ),
    );
  }


  }

