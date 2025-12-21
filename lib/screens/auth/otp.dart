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
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].dispose();
      _nodes[i].dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _nodes[index + 1].requestFocus();
    }
  }

  void _verify() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF1A237E);
    return Scaffold(
      appBar: AppBar(title: const Text('OTP'), backgroundColor: indigo, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Enter 6-digit OTP'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 44,
                  child: TextField(
                    controller: _controllers[i],
                    focusNode: _nodes[i],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => _onChanged(i, v),
                    decoration: const InputDecoration(counterText: '', border: OutlineInputBorder()),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _verify, child: const Text('Verify')),
          ],
        ),
      ),
    );
  }
}

