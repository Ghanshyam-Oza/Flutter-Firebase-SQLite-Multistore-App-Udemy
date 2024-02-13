import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.yellow.shade400,
      backgroundColor: Colors.grey,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Image(
                image: AssetImage('images/inapp/logo.jpg'),
                height: 250,
                width: 250,
              ),
              // const Text(
              //   "Welcome",
              //   style: TextStyle(
              //       fontSize: 34,
              //       fontWeight: FontWeight.w700,
              //       color: Color.fromARGB(255, 121, 119, 119)),
              // ),
              SizedBox(
                height: 60,
                width: 200,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('WELCOME'),
                      RotateAnimatedText('TO'),
                      RotateAnimatedText('STORE'),
                      RotateAnimatedText('BUY'),
                      RotateAnimatedText('SELL'),
                    ],
                    pause: const Duration(milliseconds: 100),
                    repeatForever: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/supplier_signup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade400,
                ),
                child: const Text(
                  "For Suppliers",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/customer_signup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade400,
                ),
                child: const Text(
                  "For Customers",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Login with",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('images/inapp/facebook.jpg'),
                    height: 30,
                    width: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image(
                    image: AssetImage('images/inapp/google.jpg'),
                    height: 30,
                    width: 30,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
