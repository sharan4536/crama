import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import '../home.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = '/otp';
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _nodes = List.generate(6, (_) => FocusNode());
  bool _verifying = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _nodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _verify() async {
    if (_code.length != 6) return;
    HapticFeedback.lightImpact();
    setState(() => _verifying = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _verifying = false);
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(type: PageTransitionType.rightToLeft, child: const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD700);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.4),
                  radius: 1.2,
                  colors: [Color(0xFF1A237E), Color(0xFF0D1440)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Verify OTP', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('Sent to ${widget.phone}', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: SizedBox(
                    width: 44,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _nodes[i],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(counterText: '', border: OutlineInputBorder()),
                      onChanged: (v) {
                        if (v.isNotEmpty) {
                          if (i < 5) FocusScope.of(context).requestFocus(_nodes[i + 1]);
                          if (_code.length == 6) _verify();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _verifying ? null : _verify,
                child: Text(_verifying ? 'Verifying...' : 'Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
