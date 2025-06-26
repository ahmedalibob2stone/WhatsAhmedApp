import 'package:whatsapp/features/call/screan/call_screan.dart';
import 'package:whatsapp/model/call/call.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import '../controller/call_controller.dart';

class CallListScreen extends ConsumerWidget {
  const CallListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder<List<Call>>(
        stream: ref.watch(callControllerProvider).getStreamCalls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No calls found."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index){
              final call = snapshot.data![index];




           return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(call.callerPic),
                  ),
                  title: Text(call.callerName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(call.receiverName),
                      Text(
                        DateFormat.yMMMd().format(call.timestamp),
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: call.hasDialled
                      ? const Icon(Icons.call_made, color: Colors.red)
                      : const Icon(Icons.call_received, color: Colors.green),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          channelId: call.callId,
                          call: call,
                          isGroupChat: false,
                        ),
                      ),
                    );
                  },
              );

            },
          );

        },
      ),
    );
  }
}
