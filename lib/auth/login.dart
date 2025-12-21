import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'registration.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool _validIndiaPhone(String input) {
    final cleaned = input.replaceAll(RegExp(r'\s|-'), '');
    final re = RegExp(r'^(?:\+91)?[6-9]\d{9}$');
    return re.hasMatch(cleaned);
  }

  void _continue() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.lightImpact();
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.push(
      context,
      PageTransition(type: PageTransitionType.rightToLeft, child: const ShopRegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF1A237E);
    const gold = Color(0xFFFFD700);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
                children: const [
                  Text('Crama', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                  SizedBox(height: 6),
                  Text('Sign in to manage your boutique', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.w700, color: indigo)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d +-]'))],
                        decoration: const InputDecoration(hintText: '+91 98765 43210', border: OutlineInputBorder()),
                        validator: (v) => _validIndiaPhone(v ?? '') ? null : 'Enter a valid India number',
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _submitting ? null : _continue,
                          child: Text(_submitting ? 'Please wait...' : 'Continue'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

