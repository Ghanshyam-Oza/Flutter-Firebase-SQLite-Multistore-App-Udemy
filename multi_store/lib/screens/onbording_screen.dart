import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:multi_store/minor_screens/best_deals.dart';
import 'package:multi_store/screens/welcome.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Image.asset(assetName, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Material(
      color: const Color.fromARGB(255, 210, 210, 210),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
        child: IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.white,
          allowImplicitScrolling: true,
          autoScrollDuration: 3000,
          infiniteAutoScroll: true,
          globalFooter: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: MaterialButton(
              color: const Color.fromARGB(255, 254, 238, 86),
              onPressed: () {
                _onIntroEnd(context);
              },
              child: const Text(
                "Let's go all the way",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
          pages: [
            PageViewModel(
              title: "Choose Product",
              body:
                  "We have lots of products. Choose product from our application.",
              image: _buildImage('images/onboarding/choose_product.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Select\nPayment Method",
              body:
                  "Easy checkout and safe payment method. Trusted by customer all over the world.",
              image: _buildImage('images/onboarding/payment_method.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Track Your Order",
              body: "Track your order status on one go inside your Profile",
              image: _buildImage('images/onboarding/track_order.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Fast Delivery",
              body:
                  "Reliable and fast delivery. We deliver your product fastest way possible.",
              image: _buildImage('images/onboarding/fast_delivery.png'),
              decoration: pageDecoration.copyWith(
                bodyFlex: 6,
                imageFlex: 6,
                safeArea: 80,
              ),
            ),
            PageViewModel(
              title: "Best Deals",
              bodyWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BestDeals()));
                    },
                    child: const Text(
                      "Check Best Deals",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )
                ],
              ),
              decoration: pageDecoration.copyWith(
                bodyFlex: 2,
                imageFlex: 4,
                bodyAlignment: Alignment.bottomCenter,
                imageAlignment: Alignment.topCenter,
              ),
              image: _buildImage('images/onboarding/best_deals.png'),
              reverse: true,
            ),
          ],
          onDone: () => _onIntroEnd(context),
          onSkip: () => _onIntroEnd(context),
          showSkipButton: true,
          skipOrBackFlex: 0,
          nextFlex: 0,
          showBackButton: false,
          back: const Icon(Icons.arrow_back),
          skip:
              const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
          next: const Icon(Icons.arrow_forward),
          done:
              const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: const EdgeInsets.all(12),
          controlsPadding: kIsWeb
              ? const EdgeInsets.all(12.0)
              : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }
}
