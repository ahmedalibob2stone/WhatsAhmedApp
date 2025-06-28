import 'package:whatsapp/features/splash%20screan/splash_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'OnGenerateRoutes.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
    await dotenv.load(fileName: ".my_env.env");
  }


  runApp(const MyApp()); // ✅ إزالة ProviderScope من هنا
}

class MyApp extends StatelessWidget { // ✅ تحويله من ConsumerWidget إلى StatelessWidget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope( // ✅ لف التطبيق بالكامل بـ ProviderScope هنا
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: OnGenerateRoutes.route,
        home: const SplashScreen(),
      ),
    );
  }
}
