import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:rive/rive.dart' as rive;
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _particlesController;
  bool _showTagline = false;
  rive.Artboard? _riveArtboard;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _loadRive();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      setState(() => _showTagline = true);
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  Future<void> _loadRive() async {
    try {
      final file = await rive.RiveFile.asset('assets/crama_logo.riv');
      final artboard = file.mainArtboard;
      final controller = rive.SimpleAnimation('draw_c_to_arrow');
      artboard.addController(controller);
      setState(() {
        _riveArtboard = artboard;
      });
    } catch (_) {
      // Fallback to painter if asset is missing
    }
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD700);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.3),
                radius: 1.2,
                colors: [
                  Color(0xFF1A237E),
                  Color(0xFF0D1440),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _particlesController,
            builder: (_, __) => CustomPaint(
              painter: _ParticlesPainter(t: _particlesController.value),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'crama-logo',
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: _riveArtboard != null
                          ? rive.Rive(artboard: _riveArtboard!)
                          : CustomPaint(
                              painter: _CramaLogoPainter(progress: 1),
                            ),
                    ),
                  ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.98, 0.98)),
                  const SizedBox(height: 24),
                  const Text(
                    'Crama',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _showTagline ? 1 : 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Text(
                            'మీ దుకాణం క్రమం',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: gold,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CramaLogoPainter extends CustomPainter {
  final double progress;
  _CramaLogoPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const indigo = Color(0xFF1A237E);
    const gold = Color(0xFFFFD700);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.36;

    final path = Path();
    final rect = Rect.fromCircle(center: center, radius: radius);
    path.addArc(rect, math.pi * 0.15, math.pi * 1.35);

    final endAngle = math.pi * 1.5;
    final end = Offset(
      center.dx + radius * math.cos(endAngle),
      center.dy + radius * math.sin(endAngle),
    );
    final arrowLength = radius * 0.9;
    final arrowDir = Offset(arrowLength, -arrowLength * 0.05);
    final tip = end + arrowDir;
    final wing = Offset(-arrowLength * 0.18, arrowLength * 0.2);
    path.moveTo(end.dx, end.dy);
    path.lineTo(tip.dx, tip.dy);
    path.moveTo(tip.dx, tip.dy);
    path.lineTo(tip.dx + wing.dx, tip.dy + wing.dy);
    path.moveTo(tip.dx, tip.dy);
    path.lineTo(tip.dx + wing.dx, tip.dy - wing.dy);

    final metrics = path.computeMetrics().toList();
    final extractPath = Path();
    double remaining = progress.clamp(0.0, 1.0) *
        metrics.fold<double>(0, (sum, m) => sum + m.length);
    for (final m in metrics) {
      final take = remaining.clamp(0.0, m.length);
      if (take > 0) {
        extractPath.addPath(m.extractPath(0, take), Offset.zero);
        remaining -= take;
      }
    }

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = SweepGradient(
        center: FractionalOffset.center,
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [indigo, indigo, gold],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.4));

    canvas.drawPath(extractPath, stroke);
  }

  @override
  bool shouldRepaint(covariant _CramaLogoPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ParticlesPainter extends CustomPainter {
  final double t;
  _ParticlesPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final paint = Paint()..color = const Color(0xFFFFD700).withValues(alpha: 0.15);
    for (int i = 0; i < 80; i++) {
      final bx = rng.nextDouble();
      final by = rng.nextDouble();
      final amp = 8 + rng.nextDouble() * 16;
      final speed = 0.3 + rng.nextDouble() * 0.7;
      final x = (bx * size.width) + math.sin((t + i) * speed) * amp;
      final y = (by * size.height) + math.cos((t + i) * speed) * amp * 0.5;
      canvas.drawCircle(Offset(x, y), 1.6 + rng.nextDouble() * 1.4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) => oldDelegate.t != t;
}

class LogoMark extends StatelessWidget {
  final double size;
  const LogoMark({super.key, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CramaLogoPainter(progress: 1),
    );
  }
}
