import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import 'splash.dart';
import 'home.dart';
import 'auth/registration.dart';
import 'dart:math' as math;

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _controller;
  late final AnimationController _clothController;
  int _index = 0;
  double _page = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.92)
      ..addListener(() {
        setState(() => _page = _controller.page ?? 0.0);
      });
    _clothController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _clothController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF1A237E);
    const gold = Color(0xFFFFD700);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _clothController,
            builder: (_, __) => CustomPaint(
              painter: _ClothTexturePainter(t: _clothController.value),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Hero(
                  tag: 'crama-logo',
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: const LogoMark(size: 80),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (i) => setState(() => _index = i),
                    children: [
                      OnboardCard(
                        index: 0,
                        page: _page,
                        title: 'Manage staff attendance with biometric',
                        icon: Icons.fingerprint,
                        description:
                            'Easy attendance tracking with fingerprint or face-based systems.',
                      ),
                      OnboardCard(
                        index: 1,
                        page: _page,
                        title: 'Track every dress status in real-time',
                        icon: Icons.checkroom,
                        description:
                            'Know cutting, stitching, alterations and delivery progress instantly.',
                      ),
                      OnboardCard(
                        index: 2,
                        page: _page,
                        title: 'Bill from phone + send WhatsApp receipts',
                        icon: Icons.receipt_long,
                        description:
                            'Create invoices from mobile and share receipts on WhatsApp.',
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Dots(index: _index, count: 3, activeColor: indigo, color: Colors.black26)
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .scale(begin: const Offset(0.9, 0.9)),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const HomePage(),
                            ),
                          );
                        },
                        child: const Text('Skip'),
                      ),
                      const Spacer(),
                      _CtaButton(
                        label: _index == 2 ? 'Get Started' : 'Next',
                        primary: _index == 2 ? gold : indigo,
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          if (_index == 2) {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const ShopRegistrationScreen(),
                              ),
                            );
                          } else {
                            await _controller.nextPage(
                              duration: const Duration(milliseconds: 320),
                              curve: Curves.easeOutCubic,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardCard extends StatelessWidget {
  final int index;
  final double page;
  final String title;
  final String description;
  final IconData icon;
  final bool isLast;
  const OnboardCard({
    super.key,
    required this.index,
    required this.page,
    required this.title,
    required this.icon,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF1A237E);
    const gold = Color(0xFFFFD700);
    final delta = (index - page).clamp(-1.0, 1.0);
    final scale = 1 - (delta.abs() * 0.06);
    final opacity = 1 - (delta.abs() * 0.35);
    final iconOffset = Offset(delta * 16, -delta * 8);
    final textOffset = Offset(-delta * 10, delta * 6);
    return Center(
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: iconOffset,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFF1A237E), Color(0xFF0D1440)],
                        radius: 0.9,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 110, color: gold),
                  ),
                ),
                const SizedBox(height: 28),
                Transform.translate(
                  offset: textOffset,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: indigo,
                    ),
                  ).animate().fadeIn(duration: 240.ms),
                ),
                const SizedBox(height: 10),
                Transform.translate(
                  offset: textOffset * 0.6,
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ).animate().fadeIn(duration: 280.ms),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

 

class _Dots extends StatelessWidget {
  final int index;
  final int count;
  final Color activeColor;
  final Color color;
  const _Dots({required this.index, required this.count, required this.activeColor, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? activeColor : color,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

class _CtaButton extends StatefulWidget {
  final String label;
  final Color primary;
  final VoidCallback onTap;
  const _CtaButton({required this.label, required this.primary, required this.onTap});

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          color: widget.primary,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.primary.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClothTexturePainter extends CustomPainter {
  final double t;
  _ClothTexturePainter({required this.t});
  @override
  void paint(Canvas canvas, Size size) {
    final base = const Color(0xFF1A237E);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0.0, -0.3),
          radius: 1.2,
          colors: [Color(0xFF1A237E), Color(0xFF0D1440)],
        ).createShader(Offset.zero & size),
    );
    final paint = Paint()..color = base.withValues(alpha: 0.08)..strokeWidth = 2.0;
    for (double y = 0; y < size.height; y += 24) {
      final path = Path();
      for (double x = 0; x <= size.width; x += 12) {
        final wave = 6 * math.sin((x * 0.02) + (t * 2 * math.pi)) + 3 * math.sin((x * 0.035) - (t * math.pi));
        final yy = y + wave;
        if (x == 0) {
          path.moveTo(x, yy);
        } else {
          path.lineTo(x, yy);
        }
      }
      canvas.drawPath(path, paint);
    }
  }
  @override
  bool shouldRepaint(covariant _ClothTexturePainter oldDelegate) => oldDelegate.t != t;
}
