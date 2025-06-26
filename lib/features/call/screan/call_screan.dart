import 'package:whatsapp/common/widgets/Loeading.dart';
import 'package:whatsapp/config/agora_Developer.dart';
import 'package:whatsapp/features/call/controller/call_controller.dart';
import 'package:whatsapp/model/call/call.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;

  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,

  }) : super(key: key);

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool _isJoined = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }
  Future<String> fetchToken(String channelId, int uid) async {


    final url = Uri.parse('http://10.254.30.14:3000/getToken?channelId=$channelId&uid=$uid');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to fetch token');
    }
  }
  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(appId: AgoragConfig.appId),
    );

    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        setState(() => _isJoined = true);
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        setState(() => _remoteUid = remoteUid);
      },
      onUserOffline: (connection, remoteUid, reason) {
        setState(() => _remoteUid = null);
      },
    ));

    await _engine.enableVideo();
    await _engine.startPreview();
    final token = await fetchToken(widget.channelId, widget.call.receiverId.hashCode);
    await _engine.joinChannel(
      token: token,
      channelId: widget.channelId,
      uid: widget.call.receiverId.hashCode,
      options: const ChannelMediaOptions(),
    );
  }





  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelId),
        ),
      );
    } else {
      return const Center(child: Text("انتظار المستخدم الآخر...", style: TextStyle(color: Colors.white)));
    }
  }

  Widget _renderLocalPreview() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isJoined) return const Loeading();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _renderRemoteVideo(),
          Positioned(
            top: 40,
            left: 20,
            width: 120,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _renderLocalPreview(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: const Icon(Icons.call_end),
                onPressed: () async {
                  await _engine.leaveChannel();
                  ref.read(callControllerProvider).endCall(
                    widget.call.callerId,
                    widget.call.receiverId,
                    context,
                  );
                  if (mounted) Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
