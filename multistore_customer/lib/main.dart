import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:multistore_customer/providers/cart_provider.dart';
import 'package:multistore_customer/providers/id_provider.dart';
import 'package:multistore_customer/providers/sql_helper.dart';
import 'package:multistore_customer/providers/stripe.dart';
import 'package:multistore_customer/providers/wish_list_provider.dart';
import 'package:multistore_customer/screens/auth/customer_login.dart';
import 'package:multistore_customer/screens/auth/customer_signup.dart';
import 'package:multistore_customer/screens/customer_home.dart';
import 'package:multistore_customer/screens/onbording_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:multistore_customer/services/notification_services.dart';
import 'package:provider/provider.dart';

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
  NotificationServices.createNotificationChannelAndInitialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  WidgetsFlutterBinding.ensureInitialized();
  SQLHelper.getDatabase;
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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => WishList()),
        ChangeNotifierProvider(create: (_) => IdProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/customer_signup': (context) => const CustomerSignUpScreen(),
        '/customer_login': (context) => const CustomerLoginScreen(),
      },
    );
  }
}
