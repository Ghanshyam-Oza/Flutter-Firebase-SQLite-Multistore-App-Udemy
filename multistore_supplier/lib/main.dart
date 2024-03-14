import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:multistore_supplier/screens/auth/supplier_login.dart';
import 'package:multistore_supplier/screens/auth/supplier_signup.dart';
import 'package:multistore_supplier/screens/onbording_screen.dart';
import 'package:multistore_supplier/screens/supplier_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:multistore_supplier/services/notification_services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print("Handling a background message: ${message.notification!.title}");
  print("Handling a background message: ${message.notification!.body}");
  print("Handling a background message: ${message.data}");
  print("Handling a background message: ${message.data['appname']}");
  print("Handling a background message: ${message.data['appsection']}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyBMsaxFv7V9HexlbXoMxh-m9F4zOG6E0D0",
            appId: "1:526651469592:android:caff224b18b2862b93786d",
            messagingSenderId: "526651469592",
            projectId: "multi-store-a6181",
            storageBucket: 'gs://multi-store-a6181.appspot.com',
          ),
        )
      : await Firebase.initializeApp();
  NotificationServices.createNotificationChannelAndInitialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding_screen',
      routes: {
        '/onboarding_screen': (context) => const OnBoardingPage(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/supplier_signup': (context) => const SupplierSignUpScreen(),
        '/supplier_login': (context) => const SupplierLoginScreen(),
      },
    );
  }
}
