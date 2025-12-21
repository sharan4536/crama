import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'auth/registration.dart';
import 'home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D4B7);
    const coral = Color(0xFFFF6B3A);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _index = i),
              children: const [
                _OnboardPage(title: 'Welcome to Crama', asset: 'assets/lottie/thread.json'),
                _OnboardPage(title: 'Manage Boutique Smoothly', asset: 'assets/lottie/thread.json'),
                _OnboardPage(title: 'Let’s Get Started!', asset: 'assets/lottie/thread.json'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: const HomePage()));
                  },
                  child: const Text('Skip'),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    if (_index == 2) {
                      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: const ShopRegistrationScreen()));
                    } else {
                      await _controller.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _index == 2 ? [coral, teal] : [teal, coral]),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 14, offset: Offset(0, 6))],
                    ),
                    child: Text(_index == 2 ? 'Get Started' : 'Next', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final String title;
  final String asset;
  const _OnboardPage({required this.title, required this.asset});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, size: 72, color: Color(0xFFFF6B3A)),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        ],
      );
    }
    return FutureBuilder<ByteData>(
      future: rootBundle.load(asset),
      builder: (context, snap) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (snap.connectionState == ConnectionState.done && snap.hasData)
              Lottie.asset(asset, height: 280)
            else
              const Icon(Icons.auto_awesome, size: 72, color: Color(0xFFFF6B3A)),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          ],
        );
      },
    );
  }
}
