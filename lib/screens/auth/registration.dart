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
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OtpScreen(phone: _phoneController.text.trim())));
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D4B7);
    return Scaffold(
      appBar: AppBar(title: const Text('Shop Registration'), backgroundColor: Colors.white, foregroundColor: teal, elevation: 0),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _shopController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Shop name (తెలుగు + English)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter shop name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ownerController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Owner name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter owner name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d +-]'))],
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Phone (+91)'),
                validator: (v) => (v == null || !_validIndiaPhone(v)) ? 'Enter valid phone' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Address'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _workers,
                items: List.generate(50, (i) => i + 1).map((w) => DropdownMenuItem(value: w, child: Text('$w'))).toList(),
                onChanged: (v) => setState(() => _workers = v ?? 1),
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Workers'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)), padding: const EdgeInsets.symmetric(vertical: 14)), onPressed: _submit, child: Text(_submitting ? '...' : 'Submit')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
