import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'otp.dart';

class ShopRegistrationScreen extends StatefulWidget {
  static const routeName = '/register';
  const ShopRegistrationScreen({super.key});

  @override
  State<ShopRegistrationScreen> createState() => _ShopRegistrationScreenState();
}

class _ShopRegistrationScreenState extends State<ShopRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopController = TextEditingController();
  final _ownerController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  int _workers = 1;
  bool _submitting = false;

  @override
  void dispose() {
    _shopController.dispose();
    _ownerController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool _validIndiaPhone(String input) {
    final cleaned = input.replaceAll(RegExp(r'\s|-'), '');
    final re = RegExp(r'^(?:\+91)?[6-9]\d{9}$');
    return re.hasMatch(cleaned);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.lightImpact();
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: OtpScreen(phone: _phoneController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D4B7);
    const gold = Color(0xFFFFD700);
    final workers = List.generate(50, (i) => i + 1);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Register your boutique', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800)),
                  SizedBox(height: 6),
                  Text('మీ దుకాణం క్రమం', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Shop Name (తెలుగు / English)', style: TextStyle(fontWeight: FontWeight.w700, color: teal)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _shopController,
                        decoration: const InputDecoration(hintText: 'ఉదా: శ్రీ లక్ష్మి బుటిక్ / Sri Lakshmi Boutique', border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter shop name' : null,
                      ),
                      const SizedBox(height: 16),
                      const Text('Owner Name', style: TextStyle(fontWeight: FontWeight.w700, color: teal)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _ownerController,
                        decoration: const InputDecoration(hintText: 'Full name', border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter owner name' : null,
                      ),
                      const SizedBox(height: 16),
                      const Text('Phone Number (India)', style: TextStyle(fontWeight: FontWeight.w700, color: teal)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d +-]'))],
                        decoration: const InputDecoration(hintText: '+91 98765 43210', border: OutlineInputBorder()),
                        validator: (v) => _validIndiaPhone(v ?? '') ? null : 'Enter a valid India number',
                      ),
                      const SizedBox(height: 16),
                      const Text('Shop Address', style: TextStyle(fontWeight: FontWeight.w700, color: teal)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: const InputDecoration(hintText: 'Street, area, city, PIN', border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.trim().length < 6) ? 'Enter full address' : null,
                      ),
                      const SizedBox(height: 16),
                      const Text('Number of Workers', style: TextStyle(fontWeight: FontWeight.w700, color: teal)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: _workers,
                        items: workers.map((w) => DropdownMenuItem(value: w, child: Text('$w'))).toList(),
                        onChanged: (v) => setState(() => _workers = v ?? 1),
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: gold, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36))),
                          onPressed: _submitting ? null : _submit,
                          child: Text(_submitting ? 'Submitting...' : 'Submit'),
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
