import 'package:whatsapp/settings/mydrew/draw.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';


import '../common/utils/utills.dart';

import '../constant.dart';
import '../features/auth/viewmodel/auth_userviewmodel.dart';
import '../features/call/screan/call_list.dart';

import '../features/chat screan/widgets/contact_list.dart';
import '../features/status/screan/status_contacts_screan.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout> with WidgetsBindingObserver, TickerProviderStateMixin {
  var searchName = "";
  bool isShowUser = false;
  late TabController tabController;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabIndex);

  }

  void clearSearch() {
    setState(() {
      searchName = "";
      searchController.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    tabController.removeListener(_handleTabIndex);
    tabController.dispose();
    searchController.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(UserViewModel.notifier).setUserState('online');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(UserViewModel.notifier).setUserState('offline');
        break;
      default:
    }
  }

  File? TackImage;
  File? pickedImage;
  chooseimage( ){
    return showDialog(
        builder: (BuildContext context){
          return SimpleDialog(
            title: Text("  Photo From ",style: TextStyle(fontWeight: FontWeight.bold),),
            children: [
              SimpleDialogOption(
                  child: Text("  Camera ",style: TextStyle(fontWeight: FontWeight.bold),),
                  onPressed: ()async{
                    // Navigator.of(context).pop();

                    TackImage=await tackImage(context);
                    if(TackImage!=null){
                      Navigator.pushNamed(context, PageConst.status,arguments:TackImage);
                    }
                    //  handelcamera();
                  }
              ),
              SimpleDialogOption(
                child: Text("  Gallery ",style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: ()async{
                  // Navigator.of(context).pop();
                  pickedImage=await pickImageFromGallery(context);
                  if(pickedImage!=null){
                    Navigator.pushNamed(context, PageConst.status,arguments:pickedImage);
                  }

                },

              ),
              SimpleDialogOption(
                child: Text("  Cancel ",style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: (){

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
        context: context);


  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          // Tablet or larger screen layout

          return Scaffold(
            key: _scaffoldKey,
            drawer: mydrew(),
            appBar: AppBar(
              backgroundColor: kkPrimaryColor,
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 5,
              title: SizedBox(
                height: 40,  // Ensure a fixed height for the TextField
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.grey),
                  onChanged: (value) {
                    setState(() {
                      searchName = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    filled: true,
                    fillColor: Color.fromARGB(255, 39, 39, 39),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          clearSearch();
                        },
                      ),
                    ),
                  ),
                  onSubmitted: (String _) {
                    setState(() {
                      isShowUser = true;
                    });
                  },
                ),
              ),
              leading: GestureDetector(
                child: Icon(Icons.menu, color: Colors.white38, size: 30),
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              actions: [
                PopupMenuButton(
                  color: Colors.grey,
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Create Group'),
                      onTap: () {
                        Future(() => Navigator.pushNamed(context, PageConst.GroupScrean));
                      },
                    )
                  ],
                ),
              ],
              bottom: TabBar(
                controller: tabController,
                indicatorWeight: 4,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'CHATS'),
                  Tab(text: 'STATUS'),
                  Tab(text: 'CALLS'),
                ],
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                ContactList(searchName: searchName, isShowUser: isShowUser),
                StatusListScreen(),
                CallListScreen(),
              ],
            ),
            floatingActionButton: tabController.index == 0
                ? FloatingActionButton(
              onPressed: () async {
                Navigator.pushNamed(context, PageConst.ContactsScrean);
              },
              backgroundColor: kkPrimaryColor,
              child: Icon(Icons.edit_outlined, color: Colors.white, size: MediaQuery.of(context).size.width * 0.07), // Responsive icon size
            )
                : tabController.index == 1
                ? FloatingActionButton(
              onPressed: () async {
                chooseimage();
              },
              backgroundColor: kkPrimaryColor,
              child: Icon(Icons.camera_alt, color: Colors.white, size: MediaQuery.of(context).size.width * 0.07), // Responsive icon size
            )
                : Container(),

          );
        } else {
          // Mobile layout
          return Scaffold(
            key: _scaffoldKey,
            drawer: mydrew(),
            // Rest of your mobile layout
          );
        }
      },
    );

  }
}