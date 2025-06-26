 import 'dart:io';

import 'package:whatsapp/constant.dart';
import 'package:whatsapp/model/user_model/user_model.dart';
import 'package:whatsapp/storsge/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import '../../../common/utils/utills.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../responsive/mobile_screen_Layout.dart';


 final authRepositoryProvider = Provider<AuthRepository>((ref) {
   return AuthRepository(
     fire: FirebaseFirestore.instance,
     auth: FirebaseAuth.instance, ref: ref,

   );
 });
 class AuthRepository
 {
   final FirebaseFirestore fire;
   final FirebaseAuth auth;
   final Ref ref;

   AuthRepository  (
       {
         required this.fire,
         required this.auth,
       required this.ref,
       });


   Future<UserModel?>getCurentUserData()async{
     try{
       var userData = await fire.collection('users').doc(auth.currentUser!.uid).get();
       UserModel?user;
       if(userData.data() !=null){
         user =UserModel.fromMap(userData.data()!);
       }
       return user;
     }catch(e){
       print('Error fetching user data: $e');
       return null;
     }

   }



   void signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
     try {
       await auth.verifyPhoneNumber(
         phoneNumber: phoneNumber,
         verificationCompleted: (PhoneAuthCredential cred) async {
           await auth.signInWithCredential(cred);
         },
         verificationFailed: (FirebaseAuthException e) {
           if (e.code == 'too-many-requests') {
             print('Too many requests, try again later.');
             ShowSnakBar(context: context, content: 'Too many requests. Please try again later.');
           } else {
             throw Exception(e.message);
           }
         },
         codeSent: (String verificationId, int? resendToken) {
           Navigator.pushNamed(context, PageConst.otp_screan, arguments: verificationId);

         },
         codeAutoRetrievalTimeout: (String verificationId) {
           print('Auto retrieval timeout: $verificationId');
         },
       );
     } on FirebaseAuthException catch (e) {
       print('FirebaseAuthException: ${e.code}, ${e.message}');
       ShowSnakBar(context: context, content: e.message!);
     } catch (e) {
       print('General Exception: $e');
       ShowSnakBar(context: context, content: 'An unexpected error occurred.');
     }
   }


   void verifyOTP({
     required BuildContext context,
     required String verificationId,
     required String userOTP,
   })async{
     try{
       PhoneAuthCredential credential=PhoneAuthProvider.credential(
           verificationId: verificationId, smsCode: userOTP);
       await auth.signInWithCredential(credential);
       Navigator.pushNamedAndRemoveUntil(context, PageConst.user_information, (route) => false);
     }on FirebaseAuthException catch(e){
       ShowSnakBar(context: context,content: e.message!);

     }

   }

   void phoneauth(BuildContext context,String phoneNumber)async{
     try{
       await auth.verifyPhoneNumber(
         phoneNumber: phoneNumber,
         verificationCompleted: (PhoneAuthCredential credential)async {
           auth.signInWithCredential(credential);
         },
         verificationFailed: (FirebaseAuthException e) {},
         codeSent:( (String verificationId, int? resendToken)async {
           Navigator.pushNamed(context, PageConst.otp_screan,arguments: verificationId);

           // Update the UI - wait for the user to enter the SMS code

         }),
         codeAutoRetrievalTimeout: (String verificationId) {},
       );
     }on FirebaseAuthException catch(e){
       ShowSnakBar(context: context,content: e.message!);
     }

   }

   void sendCode ({required String verificationId, required String userOTP, required BuildContext context}) async {
     try {
       // Create a PhoneAuthCredential with the code
       PhoneAuthCredential credential = PhoneAuthProvider.credential(
         verificationId: verificationId,
         smsCode: userOTP,
       );

       // Sign the user in (or link) with the credential
       await auth.signInWithCredential(credential);

       // Navigate to the next page only after successful sign-in
       Navigator.pushNamedAndRemoveUntil(
         context,
         PageConst.user_information,
             (route) => false,
       );

     } on FirebaseAuthException catch (e) {
       ShowSnakBar(context: context, content: e.message!);
     }
   }

   Stream<UserModel>userData(String userId){
     return fire.collection('users').doc(userId).snapshots().map((event) =>UserModel.fromMap(
       event.data()!,
     ));
   }
   Stream<UserModel>myData(){
     return fire.collection('users').doc(auth.currentUser!.uid).snapshots().map((event) =>UserModel.fromMap(
       event.data()!,
     ));
   }
   void saveUserDatetoFirebase({
     required BuildContext context,
     required String name,
     required File? profile,
     required String Statu,


   })async{
     try{
       String uid=auth.currentUser!.uid;
       String photoUrl= 'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic';
       if(profile!=null){
         photoUrl=await ref.read(FirebaseStorageRepositoryProvider).storeFiletofirstorage('Profile/$uid', profile);

       }
       var user=UserModel(name: name, uid: uid, profile:photoUrl, isOnline: '',
           phoneNumber: auth.currentUser!.phoneNumber!
           , groupId: [], statu:Statu);
       await  fire.collection('users').doc(uid).set(user.toMap());

       Navigator.pushAndRemoveUntil(
         context,
         MaterialPageRoute(
           builder: (context) => const MobileScreenLayout(),
         ),
             (route) => false,
       );



     }catch(e){
       ShowSnakBar(context: context,content: e.toString());

     }
   }

   void setUserState(String isOnline)async{
     await fire.collection('users').doc(auth.currentUser!.uid).update(
         {
           'isOnline':isOnline
         }
     );
   }
   Future<void> addstatu(

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