import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:spade_lite/Common/navigator.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/login/login_screen.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/spade_splash_screen.dart';
import 'package:spade_lite/Presentation/widgets/custom_button.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  void onInit() => Future.delayed(
      const Duration(seconds: 1), () => FlutterNativeSplash.remove());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Set the background color to black
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset("assets/images/onboarding1.png", height: 60),
              const Text(
                'A different experience...',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              CustomButton(
                color: Colors.white,
                text: 'Create Account',
                textColor: Colors.black,
                onPressed: () => showDialog(
                    context: context,
                    builder: (ctx) => const SpadeSplashScreen()),
              ),
              const SizedBox(height: 30),
              CustomButton(
                borderSide: const BorderSide(color: Colors.white),
                text: 'Login',
                textColor: Colors.white,
                onPressed: () => push(const LoginScreen()),
              ),
              const SizedBox(height: 20),
              RichText(
                  text: const TextSpan(
                      text: 'By clicking',
                      style: TextStyle(color: Colors.white),
                      children: [
                    TextSpan(
                        text: ' ‘Create acount’',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    TextSpan(text: ' or'),
                    TextSpan(
                        text: ' ‘Log in’,',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ' I state that I have read and understood the terms and conditions.',
                        style: TextStyle(color: Colors.white)),
                  ])),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
