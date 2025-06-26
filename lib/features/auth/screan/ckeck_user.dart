

import 'package:whatsapp/features/auth/viewmodel/auth_userviewmodel.dart';
import 'package:whatsapp/features/welcome/screans/landing_screan.dart';
import 'package:whatsapp/responsive/mobile_screen_Layout.dart';
import 'package:whatsapp/responsive/responsive.dart';
import 'package:whatsapp/responsive/web_screen_Layout.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class CheckUser extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final userController = ref.read(UserViewModel.notifier);
    final userState = ref.watch(UserViewModel);



    if (userState.isLoading) {
      return Scaffold(
        body:SafeArea(

          child:
        Center(child: CircularProgressIndicator(color: Colors.red,))


        ),
      );
    }
    else if (userState.errorMessage != null) {
      return
        Center(child: Text('Error: ${userState.errorMessage}'));// شاشة الخطأ

    }
    else if (userState.isSuccess && userState.user != null) {
      // المستخدم محمل بشكل صحيح
      return ResponsiveLayout(
        webScreenLayout: WebScreenLayout(),
        mobileScreenLayout: MobileScreenLayout(),
      );
    } else {
      // إذا لم يتم العثور على مستخدم
      return Welcome_Screan();
    }
  }
}