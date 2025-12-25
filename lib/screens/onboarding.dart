import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'auth/registration.dart';
import 'auth/login.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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

  final List<Map<String, String>> _pages = [
    {
      'title': 'Fast & Easy Billing',
      'subtitle': 'Create bills, manage customers, and track payments in seconds',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCuh7jjUVYCh85tFP98U5NCEjyEMBo0OVxZszb30PXBd8Hev6XKGjFdjm7dbQtspX3iKYZvObK65Ywk19ls5PJntx9uXeAzrZF7Op2-g9Kozy6demg4jr0u67ImA9BkXI0j4rLUYiY7jHlC2tx85z__a-j-ZTlWVe4xioAyPilCToWLd09O_F9M3WqPyGptJaQy1Ipo94tDEu-piNEcwlxyMp0swJIKgxCoC9RUL9hvB2oA5lT-YseOmbnQODC8gD7__MSIunfEwLIF',
    },
    {
      'title': 'Manage Staff & Measurements',
      'subtitle': 'Track staff attendance and store customer measurements digitally.',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAIKFh36nEiPBYuRWnIcWEuiSJD7GB_J_nrJwq2MvibY1LZ-x92Y9sbafvzdeIegByjWOiDVoY5Iw_fDW0wXlj1-ljjq6YQkGUepWCEQfdGMdxzozEmg8EvwvAAO296AI-MPTKsgrTbFbc9fbLNS4P4L37XrPX5R2zxFbYhDEK3v47ciDYnna2213oi7DKdhiaooYeF8caHypHVhWobO9X9uA51Nk3f_ea_PnL-pAqCBrRP8D3FW0w7ONaJK6ftUep7mjXTxmje_6he',
    },
    {
      'title': 'Get Started Today',
      'subtitle': 'Create your account and manage billing, staff, and customers with ease',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDXB77PCY1Mv5e4qF5g0VPC8Ss59hpwk2RLxj5BTMFir4ouVr34gcMKMTgAZAs1faPDNMJWRvhordeL_FawJ5He7ssK-F4rx50zHI-a5yYMifNpjaujp8B3bUNsIo6yRpkyKjJha5GSuCcWRkZUPw5eJ5mRh8xYzZbeIV5OTSqSl6sDUorVfTraCnAL4XiD2lBShmTGhdA0byfsAmE51CD0mNnB7fl7RB0RxUZJy-nuHrqH-R3sZoY7hqSehXwj5dHUHZI_GZF8qnQA',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF58A39B), Color(0xFF92B3A9)],
            stops: [0.41, 0.81],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image Container
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: ClipOval(
                            child: Image.network(
                              page['image']!,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported, size: 64, color: Colors.white);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Text Content
                        Text(
                          page['title']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.1,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['subtitle']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Bottom Area
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
              child: Column(
                children: [
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8, // h-2
                        width: isActive ? 32 : 8, // w-8 vs w-2
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  
                  // Buttons based on index
                  if (_index < 2) ...[
                    // Screen 1 & 2 Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF58A39B),
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _index == 0 ? 'Get Started' : 'Next',
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),
                    if (_index == 1) ...[
                       const SizedBox(height: 16),
                       TextButton(
                         onPressed: () {
                           _controller.animateToPage(
                             2,
                             duration: const Duration(milliseconds: 300),
                             curve: Curves.easeInOut,
                           );
                         },
                         child: Text(
                           'Skip Intro',
                           style: GoogleFonts.manrope(
                             color: Colors.white.withOpacity(0.9),
                             fontWeight: FontWeight.w600,
                             fontSize: 14,
                           ),
                         ),
                       ),
                    ],
                  ] else ...[
                    // Screen 3 Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                           Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const ShopRegistrationScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF58A39B),
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Rounded full for last button per HTML
                          ),
                        ),
                        child: Text(
                          'Create Account',
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                         Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const LoginScreen(),
                            ),
                          );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Login',
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
