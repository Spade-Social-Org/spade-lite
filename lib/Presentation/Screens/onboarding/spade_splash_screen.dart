import 'package:flutter/material.dart';
import 'package:spade_lite/Presentation/widgets/fadein.dart';

import '../../../Common/navigator.dart';
import 'signup/first_name_screen.dart';

class SpadeSplashScreen extends StatefulWidget {
  const SpadeSplashScreen({super.key});

  @override
  State<SpadeSplashScreen> createState() => _SpadeSplashScreenState();
}

class _SpadeSplashScreenState extends State<SpadeSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    slideAnimation =
        Tween(begin: const Offset(0.0, 5.0), end: const Offset(0, 0))
            .animate(controller);
    controller.forward();
    Future.delayed(
        const Duration(
          milliseconds: 2000,
        ),
        () => pushReplacement(const FirstNameScreen()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeIn(
              child: SlideTransition(
                  position: slideAnimation,
                  child:
                      Image.asset("assets/images/onboarding1.png", height: 60)),
            ),
            const SizedBox(height: 200)
          ],
        ),
      ),
    );
  }
}
