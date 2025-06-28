import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/features/splash screan/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final envFile = File('.my_env.env');
    if (await envFile.exists()) {
      await dotenv.load(fileName: ".my_env.env");
      print("✅ .env.test loaded successfully.");
    } else {
      print("⚠️ .env.test not found. Using fallback values.");
    }
    print('Current directory: ${Directory.current.path}');

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  testWidgets('SplashScreen loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: SplashScreen(),
        ),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
