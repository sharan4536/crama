import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // Colors from HTML
  static const Color primaryColor = Color(0xFF58A39B);
  static const Color gradientStart = Color(0xFF58A39B);
  static const Color gradientEnd = Color(0xFF92B3A9);
  static const Color textMain = Color(0xFF292524);
  static const Color textSecondary = Color(0xFF78716c);
  
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
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [gradientStart, gradientEnd],
                stops: [0.41, 0.81],
              ),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glassmorphism Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: Colors.white.withOpacity(0.5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 16),
                                
                                // Logo
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FBF9),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: primaryColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(24),
                                            boxShadow: [
                                              BoxShadow(
                                                color: primaryColor.withOpacity(0.3),
                                                blurRadius: 20,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Center(
                                        child: Icon(
                                          Icons.storefront,
                                          size: 40,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Title & Subtitle
                                Text(
                                  "Boutique Billing",
                                  style: GoogleFonts.manrope(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: textMain,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Welcome Back",
                                  style: GoogleFonts.manrope(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: textMain,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Login to manage your billing easily",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textSecondary,
                                  ),
                                ),
                                
                                const SizedBox(height: 32),
                                
                                // Mobile Number Field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                                      child: Text(
                                        "Mobile Number",
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: textMain,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        // Prefix Container
                                        Container(
                                          width: 80,
                                          height: 56,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF6FCFB),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: const Color(0xFFB8E0DB)),
                                          ),
                                          child: Text(
                                            "+91",
                                            style: GoogleFonts.manrope(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: textMain,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Input Field
                                        Expanded(
                                          child: Container(
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF6FCFB),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: const Color(0xFFB8E0DB)),
                                            ),
                                            child: TextFormField(
                                              controller: _phoneController,
                                              keyboardType: TextInputType.phone,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp(r'[\d +-]')),
                                                LengthLimitingTextInputFormatter(15),
                                              ],
                                              style: GoogleFonts.manrope(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: textMain,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "98765 43210",
                                                hintStyle: GoogleFonts.manrope(
                                                  color: textSecondary,
                                                ),
                                                border: InputBorder.none,
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                              ),
                                              validator: (v) => (v == null || !_validIndiaPhone(v)) ? 'Invalid phone' : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Login Button
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      colors: [primaryColor, Color(0xFF7BCBC5)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.35),
                                        blurRadius: 25,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _submitting ? null : _continue,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _submitting
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Login",
                                                style: GoogleFonts.manrope(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                            ],
                                          ),
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Divider
                                Row(
                                  children: [
                                    Expanded(child: Divider(color: const Color(0xFFDCF0ED), thickness: 1)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        "OR",
                                        style: GoogleFonts.manrope(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: textSecondary,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Divider(color: const Color(0xFFDCF0ED), thickness: 1)),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Email Login Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // Email login logic
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(color: Color(0xFFB8E0DB)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.mail_outline, color: textSecondary, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Login with Email instead",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: textMain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Footer
                    Text.rich(
                      TextSpan(
                        text: "By logging in, you agree to our ",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: "Terms",
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: " & "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: "."),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to simulate animate effect slightly or just helper
extension WidgetAnimate on Widget {
  Widget animate() => this; // Placeholder if needed
}
