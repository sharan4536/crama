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
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const ShopRegistrationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF1A237E);
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), backgroundColor: indigo, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d +-]'))],
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Phone (+91)'),
                validator: (v) => (v == null || !_validIndiaPhone(v)) ? 'Enter valid India phone' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _continue, child: Text(_submitting ? '...' : 'Continue')),
            ],
          ),
        ),
      ),
    );
  }
}
