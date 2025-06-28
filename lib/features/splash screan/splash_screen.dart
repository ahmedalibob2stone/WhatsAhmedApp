
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:whatsapp/features/auth/screan/ckeck_user.dart';


class SplashScreen extends StatefulWidget {
  final Duration delay;
  const SplashScreen({Key? key, this.delay = const Duration(seconds: 3)}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(widget.delay, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CheckUser()), // الشاشة التالية
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // لضبط العناصر في منتصف الشاشة
          children: [
            Center(
              child: Image(
                image: AssetImage('assets/images/logo_image.png'),
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(height: 20), // مسافة بين الصورة ومؤشر التحميل
            CircularProgressIndicator(), // مؤشر التحميل في الأسفل
          ],
        ),
      ),
    );
  }
}
