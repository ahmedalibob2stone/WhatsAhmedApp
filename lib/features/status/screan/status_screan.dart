  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:story_view/story_view.dart';
  import '../../../common/widgets/Loeading.dart';
import '../viewmodel/add_statu.dart';

  class StatusScreen extends ConsumerStatefulWidget {
    final String username;
    final String profilePic;
    final String phoneNumber;
    final List<String> photoUrls;
    final List<String> massage;
    final String uid;

    const StatusScreen({
      Key? key,
      required this.username,
      required this.profilePic,
      required this.phoneNumber,
      required this.photoUrls,
      required this.massage,
      required this.uid,
    }) : super(key: key);

    @override
    _StatusScreenState createState() => _StatusScreenState();
  }

  class _StatusScreenState extends ConsumerState<StatusScreen> {
    final StoryController _controller = StoryController();
    late final List<StoryItem> _storyItems = [];

    void _initStoryItems() {
      for (int i = 0; i < widget.photoUrls.length; i++) {
        final caption = widget.massage[i].isNotEmpty ? widget.massage[i] : 'Default Caption';

        print('Caption: $caption'); // Debug print statement

        _storyItems.add(
          StoryItem.pageImage(
            url: widget.photoUrls[i],
            controller: _controller,
            imageFit: BoxFit.cover,
            caption:  Text(caption),

          ),
        );
      }
    }


    @override
    void initState() {
      super.initState();
      _initStoryItems();
    }
    void  _DeletStatu(int index,WidgetRef ref,BuildContext context){
      ref.watch(StatusViewModel.notifier).deleteStatus(index, widget.photoUrls, context);
      setState(() {
        widget.photoUrls.removeAt(index);
        widget.massage.removeAt(index);
        _initStoryItems(); // Rebuild story items
      });
    }

    void onMessageDelet(BuildContext context, WidgetRef ref) {
      if (widget.uid != FirebaseAuth.instance.currentUser!.uid) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                SimpleDialogOption(
                  child: const Text("Delete"),
                  onPressed: () {
                    _DeletStatu(0, ref, context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
    @override
    Widget build(BuildContext context) {

      return Scaffold(
        body: _storyItems.isEmpty
            ? const Loeading()
            : Stack(
          children: [
            StoryView(
              storyItems: _storyItems,
              controller: _controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),

            Positioned(
              top: 40, // Adjust the position as needed
              left: 16,
              right: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.profilePic),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          style: TextStyle(
                            color: widget.username.isNotEmpty ? Colors.black54 : Colors.transparent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.phoneNumber,
                          style: TextStyle(
                            color: widget.phoneNumber.isNotEmpty ? Colors.black54 : Colors.transparent,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(

                    onTap: () =>
                    onMessageDelet,
                        //delet(0, ref, context), // Assuming you want to delete the first status

                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      );
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }
  }
