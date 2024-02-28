import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
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
              onPressed: () {},
              child: const Text(
                "Let's go all the way",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          pages: [
            PageViewModel(
              title: "Choose Product",
              body:
                  "Instead of having to buy an entire share, invest any amount you want.",
              image: _buildImage('images/onboarding/1.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Learn as you go",
              body:
                  "Download the Stockpile app and master the market with our mini-lesson.",
              image: _buildImage('images/onboarding/2.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Kids and teens",
              body:
                  "Kids and teens can track their stocks 24/7 and place trades that you approve.",
              image: _buildImage('images/onboarding/3.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Another title page",
              body: "Another beautiful body text for this example onboarding",
              image: _buildImage('images/onboarding/1.png'),
              footer: Padding(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40, bottom: 10),
                child: MaterialButton(
                  color: Colors.lightBlue,
                  onPressed: () {},
                  child: const Text(
                    "Shop Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              decoration: pageDecoration.copyWith(
                bodyFlex: 6,
                imageFlex: 6,
                safeArea: 80,
              ),
            ),
            PageViewModel(
              title: "Title of last page - reversed",
              bodyWidget: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Click on ", style: bodyStyle),
                  Icon(Icons.edit),
                  Text(" to edit a post", style: bodyStyle),
                ],
              ),
              decoration: pageDecoration.copyWith(
                bodyFlex: 2,
                imageFlex: 4,
                bodyAlignment: Alignment.bottomCenter,
                imageAlignment: Alignment.topCenter,
              ),
              image: _buildImage('images/onboarding/1.png'),
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
          // dotsContainerDecorator: const ShapeDecoration(
          //   color: Color.fromARGB(221, 255, 255, 255),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
          //   ),
          // ),
        ),
      ),
    );
  }
}
