import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final introKey = GlobalKey<IntroductionScreenState>();
  String supplierId = '';

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      return prefs.getString('supplierid') ?? "";
    }).then((value) {
      setState(() {
        supplierId = value.toString();
      });
    });
  }

  void _onIntroEnd(context) {
    if (supplierId != '') {
      Navigator.of(context).pushReplacementNamed('/supplier_home');
    } else {
      Navigator.of(context).pushReplacementNamed('/supplier_signup');
    }
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
              title: "Create Store and Post Product",
              body:
                  "Create your store using Sign up to Application and Post your products and Get customer Orders.",
              image: _buildImage('images/onboarding/post_products.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Edit Store / Product",
              body:
                  "Edit your Store and Products to change Title, Price, Discount and many more.",
              image: _buildImage('images/onboarding/choose_product.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Prepare, Ship, Deliver products",
              body:
                  "Prepare, Ship, and Deliver Customer orders based on the status shown in Dashboard.",
              image: _buildImage('images/onboarding/track_order.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Get Your Payment",
              body:
                  "Get your order Payment through the most reliable and efficient way.",
              image: _buildImage('images/onboarding/payment_method.png'),
              decoration: pageDecoration,
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
