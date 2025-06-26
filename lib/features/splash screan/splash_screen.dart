

import 'package:whatsapp/features/auth/screan/ckeck_user.dart';
import 'package:flutter/material.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    // محاكاة تحميل البيانات أو الانتظار لثوانٍ
    Future.delayed(Duration(seconds: 3), () {
      // الانتقال إلى الشاشة التالية
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
