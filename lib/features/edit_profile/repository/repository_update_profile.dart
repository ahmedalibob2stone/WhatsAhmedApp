import 'dart:io';

import 'package:whatsapp/model/user_model/user_model.dart';
import 'package:whatsapp/storsge/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/utils/utills.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final UpdateRepositoryProvider = Provider<UpdateRepository>((ref) {
  return UpdateRepository(
    fire: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance, ref: ref,

  );
});
class UpdateRepository
{
  final FirebaseFirestore fire;
  final FirebaseAuth auth;
  final Ref ref;

  UpdateRepository  (
      {
        required this.fire,
        required this.auth,
        required this.ref,
      });

  Future<void> UpDateState(

      BuildContext context,
      String statu,


      )async{

    try{

      await fire.collection('users').doc(auth.currentUser!.uid).update({'statu':statu
      });

    }catch(e){
      ShowSnakBar(context: context,content: e.toString());
    }
  }
  Future<void> updateName(

      BuildContext context,
      String name,


      )async{

    try{

      await fire.collection('users').doc(auth.currentUser!.uid).update({'name':name
      });

    }catch(e){
      ShowSnakBar(context: context,content: e.toString());
    }
  }
  void UpdatePhotoUrl(
      {

        required File? profile,

        required BuildContext context
      }



      )async{

    UserModel? reciveUserData;
    var userdata=await fire.collection('users').doc(auth.currentUser!.uid).get();
    reciveUserData=UserModel.fromMap(userdata.data()!);
    final uid=auth.currentUser!.uid;
    String photoUrl= await reciveUserData.profile;
    if(profile!=null){
      photoUrl=await ref.read(FirebaseStorageRepositoryProvider).storeFiletofirstorage('Profile/$uid', profile);

    }

    try{
      await fire.collection('users').doc(auth.currentUser!.uid).update({'profile':photoUrl
      });

    }catch(e){
      ShowSnakBar(context: context,content: e.toString());
    }


  }

}