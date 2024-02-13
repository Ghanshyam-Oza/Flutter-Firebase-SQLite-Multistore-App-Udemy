import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_store/providers/cart_provider.dart';
import 'package:multi_store/providers/wish_list_provider.dart';
import 'package:multi_store/screens/auth/customer_login.dart';
import 'package:multi_store/screens/auth/customer_signup.dart';
import 'package:multi_store/screens/auth/supplier_login.dart';
import 'package:multi_store/screens/auth/supplier_signup.dart';
import 'package:multi_store/screens/customer_home.dart';
import 'package:multi_store/screens/supplier_home.dart';
import 'package:multi_store/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyAmoZjqsFy3xb64bjkJQbJwj6g2gayQ4E0",
            appId: "1:315602413171:android:48242825112ab26687ec06",
            messagingSenderId: "315602413171",
            projectId: "multi-store-70d7f",
            storageBucket: 'gs://multi-store-70d7f.appspot.com',
          ),
        )
      : await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => WishList()),
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
      initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/customer_signup': (context) => const CustomerSignUpScreen(),
        '/customer_login': (context) => const CustomerLoginScreen(),
        '/supplier_signup': (context) => const SupplierSignUpScreen(),
        '/supplier_login': (context) => const SupplierLoginScreen(),
      },
    );
  }
}
