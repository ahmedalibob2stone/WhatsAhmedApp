




import 'package:whatsapp/features/call/screan/call_screan.dart';
import 'package:whatsapp/model/call/call.dart';
import 'package:whatsapp/model/group/group.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../common/utils/utills.dart';

final callRepositoryProvider=Provider((ref) =>
    CallRepository(auth:FirebaseAuth.instance,fire:FirebaseFirestore.instance),);


class CallRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore fire;

  CallRepository({
    required this.auth,
    required this.fire,

  });

  Stream<DocumentSnapshot> get callStream =>
      fire.collection('call').doc(auth.currentUser!.uid).snapshots();

  void CreateCall(Call senderCallData, Call reciverCallData,
      BuildContext context) async {
    try {
      await fire
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await fire
          .collection('call')
          .doc(senderCallData.receiverId)
          .set(reciverCallData.toMap());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CallScreen(
                channelId: senderCallData.callId,
                call: senderCallData,
                isGroupChat: false,
              ),
        ),
      );
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }

  void makeGroupCall(Call senderCallData,
      BuildContext context,
      Call receiverCallData,) async {
    try {
      await fire
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var groupSnapshot = await fire
          .collection('groups')
          .doc(senderCallData.receiverId)
          .get();
      model.Group group = model.Group.fromMap(groupSnapshot.data()!);

      for (var id in group.membersUid) {
        await fire
            .collection('call')
            .doc(id)
            .set(receiverCallData.toMap());
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CallScreen(
                channelId: senderCallData.callId,
                call: senderCallData,
                isGroupChat: true,
              ),
        ),
      );
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }

  void endCall(String callerId,
      String receiverId,
      BuildContext context,) async {
    try {
      await fire.collection('call').doc(callerId).delete();
      await fire.collection('call').doc(receiverId).delete();
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }

  void endGroupCall(String callerId,
      String receiverId,
      BuildContext context,) async {
    try {
      await fire.collection('call').doc(callerId).delete();
      var groupSnapshot =
      await fire.collection('groups').doc(receiverId).get();
      model.Group group = model.Group.fromMap(groupSnapshot.data()!);
      for (var id in group.membersUid) {
        await fire.collection('call').doc(id).delete();
      }
    } catch (e) {
      ShowSnakBar(context: context, content: e.toString());
    }
  }

  Stream<List<Call>> getStreamCalls() {
    return fire.collection('call')
        .snapshots()
        .map((event) {
      List<Call> calls = [];
      for (var doc in event.docs) {
        calls.add(Call.fromMap(doc.data()));
      }
      return calls;
    });
  }

  Stream<List<Call>> getCall() {
    return fire.collection('call')
        .snapshots().
    map((event) => event.docs.map((e) => Call.fromMap(e.data())).toList());
  }
void deletcall(String cureentuser){
    fire.collection('call').doc(cureentuser).delete();
  }

}
