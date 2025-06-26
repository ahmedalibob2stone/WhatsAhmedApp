import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constant.dart';
import '../viewmodel/add_statu.dart';


class AddMessageForStatus extends ConsumerStatefulWidget {
  final File file;

  const AddMessageForStatus({required this.file, Key? key}) : super(key: key);

  @override
  _AddMessageForStatusState createState() => _AddMessageForStatusState();
}

class _AddMessageForStatusState extends ConsumerState<AddMessageForStatus> {
  final TextEditingController _messageController = TextEditingController();
  bool _isShowEmoji = false;
  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEmojiKeyboard() {
    if (_isShowEmoji) {
      _showKeyboard();
      _hideEmoji();
    } else {
      _hideKeyboard();
      _showEmoji();
    }
  }

  void _hideEmoji() {
    setState(() {
      _isShowEmoji = false;
    });
  }

  void _showEmoji() {
    setState(() {
      _isShowEmoji = true;
    });
  }

  void _showKeyboard() => _focusNode.requestFocus();
  void _hideKeyboard() => _focusNode.unfocus();

  void _addStatus(WidgetRef ref, BuildContext context) {
    ref.read(StatusViewModel.notifier).addStatus(
      widget.file,
      _messageController.text.trim(),
      context



    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final statusState = ref.watch(StatusViewModel);
    return Scaffold(
      body: Stack(
        children: [
          if (statusState == StatusState.loading)
          // عرض مؤشر تحميل أثناء رفع الحالة
            Center(child: CircularProgressIndicator()),
          if (statusState != StatusState.loading)
            Center(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Image.file(widget.file),
            ),
          ),
          if (statusState == StatusState.error)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 50),
                  SizedBox(height: 16),
                  Text(
                    'Something went wrong. Please try again.',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  SizedBox(height: 16),

                ],
              ),
            ),
          if (statusState == StatusState.success)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 50),
                  SizedBox(height: 16),
                  Text(
                    'Status uploaded successfully!',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // يمكنك إعادة توجيه المستخدم أو إغلاق الشاشة هنا
                      Navigator.pop(context);
                    },
                    child: Text('Go back'),
                  ),
                ],
              ),
            ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _focusNode,
                        controller: _messageController,
                        maxLines: 4,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: "Add a message...",
                          hintStyle: const TextStyle(color: Colors.black54),
                          filled: true,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: IconButton(
                            onPressed: _toggleEmojiKeyboard,
                            icon: Icon(
                              Icons.emoji_emotions,
                              color: kkPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    FloatingActionButton(
                      backgroundColor: kkPrimaryColor,
                      onPressed: () => _addStatus(ref, context),
                      child: const Icon(Icons.send, size: 20),
                    ),
                  ],
                ),
              ),
              if (_isShowEmoji)
                SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      setState(() {
                        _messageController.text += emoji.emoji;
                      });
                    },
                    config: Config(
                      emojiViewConfig: EmojiViewConfig(
                        emojiSizeMax: 32,
                      ),



                    ),
                  ),

                ),
            ],
          ),
        ],
      ),
    );
  }
}
