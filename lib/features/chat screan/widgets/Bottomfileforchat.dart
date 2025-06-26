import 'dart:io';
import 'package:whatsapp/common/utils/utills.dart';
import 'package:whatsapp/features/chat%20screan/conrroller/provider%20ex.dart';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../common/Provider/Message_reply.dart';
import '../../../common/enums/enum_massage.dart';
import '../../../constant.dart';
import '../conrroller/chat_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import 'Message_reply.dart';

class BottomFileforChat extends ConsumerStatefulWidget {
  final String reciverUserId;
  final bool isGroupChat;

  const BottomFileforChat( {
    required this.reciverUserId,
    required this.isGroupChat,

    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BottomFileforChat> createState() => _BottomFileforChatState();
}

class _BottomFileforChatState extends ConsumerState<BottomFileforChat> {
  final TextEditingController _message = TextEditingController();
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? _flutterSoundRecorder;

  bool isShowsendmassage = false;
  bool isShowEmoji = false;
  bool isRecorder = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _flutterSoundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void sendTextMassage() async {

    if (isShowsendmassage) {

      ref.read(chatControllerProvider.notifier).sendTextMessage(
          context, _message.text.trim(), widget.reciverUserId,
          widget.isGroupChat);
      setState(() {
        _message.clear();
      });
    } else {
      var temp = await getTemporaryDirectory();
      var path = '${temp.path}/flutter_sound.aac';
      if (!isRecorder) return;

      if (isRecording) {
        await _flutterSoundRecorder!.stopRecorder();
        SendFileMessage(File(path), EnumData.audio);
      } else {
        await _flutterSoundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  Future<void> openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic not allowed!');
    }
    await _flutterSoundRecorder!.openRecorder();
    isRecorder = true;
  }

  void SendFileMessage(File file, EnumData messageData) {
    ref.read(providercontrollerex).SendFileMassage(context,
        file, widget.reciverUserId, messageData, widget.isGroupChat);
  }
    Future<void> selectImage() async {
      File? image = await pickImageFromGallery(context);
      if (image != null) {
        SendFileMessage(image, EnumData.image);
      }
    }

    Future<void> selectVideo() async {
      File? video = await pickVideoFromGallery(context);
      if (video != null) {
        SendFileMessage(video, EnumData.video);
      }
    }

  Future<void> selectGIF() async {
    final gif = await PickGif(context);
    final gifUrl = gif?.images?.original?.url;

    if (gifUrl != null && gifUrl.isNotEmpty) {
      ref.read(providercontrollerex).sendGIFMessage(
        context,
        gifUrl,
        widget.reciverUserId,
        widget.isGroupChat,
      );
    } else {
      ShowSnakBar(context: context, content: 'فشل في الحصول على رابط GIF');
    }
  }


    void hideEmoji() {
      setState(() {
        isShowEmoji = false;
      });
    }

    void showEmoji() {
      setState(() {
        isShowEmoji = true;
      });
    }

    void showKeyboard() => focusNode.requestFocus();
    void hideKeyboard() => focusNode.unfocus();

    void toggleEmojiKeyboard() {
      if (isShowEmoji) {
        showKeyboard();
        hideEmoji();
      } else {
        hideKeyboard();
        showEmoji();
      }
    }

    @override
    void dispose() {
      super.dispose();
      _message.dispose();
      _flutterSoundRecorder = null;
      isRecorder = false;
    }


    @override
    Widget build(BuildContext context) {
      final messageReply = ref.watch(messageReplyProvider);
      final isShowMessageReply = messageReply != null;

      return Column(
        children: [
          if (isShowMessageReply) const Message_Reply(),

          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  focusNode: focusNode,
                  controller: _message,
                  maxLines: 4,
                  minLines: 1,
                  autocorrect: true,
                  onChanged: (val) {
                    setState(() {
                      isShowsendmassage = val.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Message...",
                    hintStyle: const TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeyboard,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: kkPrimaryColor,
                              size: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: selectGIF,
                            icon: const Icon(
                              Icons.gif_outlined,
                              color: kkPrimaryColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: selectVideo,
                          icon: const Icon(
                            Icons.attach_file,
                            color: kkPrimaryColor,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: kkPrimaryColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              FloatingActionButton(
                onPressed: sendTextMassage,
                backgroundColor: kkPrimaryColor,
                child: Icon(
                  isShowsendmassage
                      ? Icons.send
                      : isRecording
                      ? Icons.close
                      : Icons.mic,
                  color: const Color(0xFFF5FCF9),
                  size: 18,
                ),
              ),
            ],
          ),

          if (isShowEmoji)
            SizedBox(
              height: 310,
              child: EmojiPicker(
                onEmojiSelected: (type, emoji) {
                  setState(() {
                    _message.text += emoji.emoji;
                  });
                  if (!isShowsendmassage) {
                    setState(() {
                      isShowsendmassage = true;
                    });
                  }
                },
              ),
            ),
        ],
      );
    }
  }


