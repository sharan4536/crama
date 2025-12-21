import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'onboarding.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const coral = Color(0xFFFF6B3A);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: const OnboardingScreen()));
        },
        child: kIsWeb
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: coral, size: 72),
                    SizedBox(height: 12),
                    Text('Crama', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700)),
                  ],
                ),
              )
            : FutureBuilder<ByteData>(
                future: rootBundle.load('assets/rive/splash.riv'),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.done && snap.hasData) {
                    return const Center(child: RiveAnimation.asset('assets/rive/splash.riv', fit: BoxFit.contain));
                  }
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, color: coral, size: 72),
                        SizedBox(height: 12),
                        Text('Crama', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
