import 'dart:io';
import 'package:whatsapp/common/utils/utills.dart';
import 'package:whatsapp/features/auth/viewmodel/auth_userviewmodel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/Buttom_container.dart';
import '../../../common/widgets/Error_Screan.dart';
import '../../../common/widgets/Loeading.dart';
import '../../../constant.dart';
import '../../../responsive/mobile_screen_Layout.dart';

import '../viewmodel/auth_getdate.dart';

class User_Information extends ConsumerStatefulWidget {
  const User_Information({Key? key}) : super(key: key);

  @override
  ConsumerState<User_Information> createState() => _User_InformationState();
}

class _User_InformationState extends ConsumerState<User_Information> {

  final TextEditingController name = TextEditingController();
  final TextEditingController statu = TextEditingController();
  File? image;
  bool isLoading = false;
  bool _validatestatu = true;



  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void Pickphoto() async {
    image = await tackImage(context);
    setState(() {});
  }

  //final _formkey = GlobalKey<FormState>();

  void UploadDataToFirestore() async {
    String Name = name.text.trim();
    String Statu = statu.text.trim();

    setState(() {
      _validatestatu = Statu.length >= 10;
    });

    if (_validatestatu && Name.isNotEmpty && image != null) {
      // تفعيل حالة التحميل
      ref.read(UserViewModel.notifier).setLoading(true);
     // controller.start();

      try {
        // حفظ بيانات المستخدم في Firebase
        ref.read(UserViewModel.notifier).saveUserDatetoFirebase(
            context: context, name: Name, profile: image, statu: Statu);

        // إظهار النجاح في الزر
       // controller.success();

        // الانتقال إلى الواجهة الأخرى بعد نجاح العملية

      } catch (e) {
        // عرض الخطأ إذا حدث
        ref.read(UserViewModel.notifier).setError(e.toString());

        // إعادة تعيين الزر إلى حالته الافتراضية بعد الخطأ
        //controller.error();

        // عرض رسالة الخطأ باستخدام Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        // إيقاف حالة التحميل
        ref.read(UserViewModel.notifier).setLoading(false);
      }
    } else {
      // إعادة تعيين الزر وعرض خطأ إذا كان الإدخال غير صالح
    //  controller.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required!')),
      );
    }
  }




  void Continues()async {
    await Future.delayed(Duration(seconds: 3));
    return ref.watch(UserDateProvider).when(
      data: (user) {
        if (user != null &&
            user.name.isNotEmpty &&
            user.statu.isNotEmpty &&
            user.profile.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MobileScreenLayout()),
            );
          });
        }
      },
      error: (err, trace) => ErrorScreen(error: err.toString()),
      loading: () => const Loeading(),
    );
  }
    Future Next()async {
      await Future.delayed(Duration(seconds: 3));

      final userState = ref.watch(UserViewModel);
      if (userState.isLoading) {
        return Center(child: CircularProgressIndicator(),);
      } else if (userState.errorMessage != null) {
        return Container(
          child: Center(
              child: Text('Error: ${userState.errorMessage}')), // شاشة الخطأ
        );
      } else if (userState.isSuccess && userState.user != null && userState.user!.name.isNotEmpty &&
          userState.user!.statu.isNotEmpty &&
          userState.user!.profile.isNotEmpty) {

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MobileScreenLayout()),
          );
        });

      }
    }


  @override
  Widget build(BuildContext context) {
   // final userController = ref.read(UserViewModel.notifier);
  //  final userState = ref.watch(userDataAuthProvider);

    return ref.watch(userDataAuthProvider).when(
      data: (user) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: MediaQuery.of(context).size.height * 0.05,
                ),
                child: Column(
                  children: [
                    // Profile Picture Section

                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: user?.profile != null
                                ? NetworkImage(user!.profile)
                                : image != null
                                ? FileImage(image!)
                                : const NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg',
                            ) as ImageProvider,
                            radius: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                displayModalBottomSheet(context);
                              },
                              icon: Icon(Icons.add_a_photo,
                                  size: MediaQuery.of(context).size.width * 0.06),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Name Section
                    Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: TextField(
                        controller: name,
                        decoration: InputDecoration(
                          hintText: user?.name ?? 'Enter your name',
                        ),
                      ),
                    ),
                    // Status Section
                    Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: TextField(
                        controller: statu,
                        decoration: InputDecoration(
                          hintText: user?.statu ?? 'Enter your status',
                          errorText: _validatestatu
                              ? null
                              : "Status must be at least 10 characters",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),


                    // Next Button
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ButtonContainerWidget(
                      color: kkPrimaryColor,
                      text: 'Next',
                    //  onTapListener: name.text.isNotEmpty && statu.text.isNotEmpty && image != null
                      //    ? UploadDataToFirestore
                        //  : Continues,
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (err, trace) => ErrorScreen(error: err.toString()),
      loading: () => const Loeading(),
    );
  }



  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                    onTap: () {
                      Pickphoto();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_album_outlined),
                  title: Text('Gallery'),
                  onTap: () {
                    selectImage();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}

