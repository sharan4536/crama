import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../../data/shop_profile_store.dart';
import '../home.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = '/otp';
  final String phone;
  final String? shopName;
  final String? ownerName;
  final String? email;

  const OtpScreen({
    super.key,
    required this.phone,
    this.shopName,
    this.ownerName,
    this.email,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  bool _verifying = false;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _verify() async {
    // Basic validation
    String code = _controllers.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete verification code')),
      );
      return;
    }

    setState(() => _verifying = true);
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    if (!mounted) return;
    setState(() => _verifying = false);

    if (widget.shopName != null || widget.ownerName != null || widget.email != null) {
      ShopProfileStore().updateShopDetails(
        name: widget.shopName,
        contact: widget.ownerName,
        mob: widget.phone,
        mail: widget.email,
      );
    }

    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: const HomePage()));
  }

  String _maskPhone(String phone) {
    if (phone.length < 4) return phone;
    // Assuming format like +91 9876543210 or similar
    // Simple mask keeping last 3 digits
    String clean = phone.replaceAll(RegExp(r'\D'), '');
    if (clean.length > 3) {
      return "+91 *******${clean.substring(clean.length - 3)}";
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF58A39B);
    const textMain = Color(0xFF141b0e);
    const textMuted = Color(0xFF6b7a60);

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
            // Header
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Text(
                          "Verify OTP",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    children: [
                      // Icon
                      Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF58A39B).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.sms_outlined, color: primary, size: 40),
                      ),

                      Text(
                        "Verification Code",
                        style: GoogleFonts.manrope(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textMain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 280,
                        child: Text(
                          "Enter the 6-digit code sent to your mobile number",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textMuted,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _maskPhone(widget.phone),
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textMain,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Inputs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 48,
                            height: 56,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _nodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              textInputAction: index < 5 ? TextInputAction.next : TextInputAction.done,
                              onSubmitted: (_) {
                                if (index < 5) {
                                  _nodes[index + 1].requestFocus();
                                } else {
                                  _nodes[index].unfocus();
                                  _verify();
                                }
                              },
                              style: GoogleFonts.manrope(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textMain,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: primary, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (index < 5) {
                                    _nodes[index + 1].requestFocus();
                                  } else {
                                    _nodes[index].unfocus();
                                  }
                                } else {
                                  if (index > 0) {
                                    _nodes[index - 1].requestFocus();
                                  }
                                }
                              },
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 40),

                      // Resend
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Didn't receive the code? ",
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textMuted,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('OTP Resent')),
                                  );
                                },
                                child: Text(
                                  "Resend OTP",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Resend code in 00:30",
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: textMuted.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Verify Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _verifying ? null : _verify,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: primary.withValues(alpha: 0.3),
                          ),
                          child: _verifying
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  "Verify",
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
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
