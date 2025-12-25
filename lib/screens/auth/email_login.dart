import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'registration.dart';

class EmailLoginScreen extends StatefulWidget {
  static const routeName = '/email-login';
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _submitting = false;

  // Colors from HTML
  static const Color primaryColor = Color(0xFF58A39B);
  static const Color gradientStart = Color(0xFF58A39B);
  static const Color gradientEnd = Color(0xFF92B3A9);
  static const Color textMain = Color(0xFF121716);
  static const Color textSecondary = Color(0xFF9AAEB3);
  static const Color borderColor = Color(0xFFD7E0DF);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _submitting = false);
    // TODO: Implement actual login logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login functionality to be implemented')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F7),
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
          
          Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 40, left: 24, right: 24),
                child: Column(
                  children: [
                    // Logo Container
                    Container(
                      width: 96,
                      height: 96,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBF-6ToSTIUrCfY7SUsZ11txtKJigdgABF0_f7v0T1Ono8O5DkBbr2ORnfFqDg0OO6Q-GRTtdOzNJHkVadHleulTRg-efG0ZmcZdRRT3-GOiRjiNq4EPL9lZG9XaTxFFvGSw0X_HPwDvajPy3MdznZ8bBf-5fvjcUi39ndzvOxTYymv1VYD35QmB2bM0X3bPQk2blE81Awkqjt6zFBurBulMHZ7m4ZD-HejJM4N-axs7RXjy1Wj_tD4oJfcMiCUiB7UOnLeAd416NIp'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Welcome Back",
                      style: GoogleFonts.manrope(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Login to manage your boutique",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Content Sheet
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F7F7),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 40,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 8),
                                child: Text(
                                  "Email address",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textMain,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: textMain,
                                ),
                                decoration: InputDecoration(
                                  hintText: "name@boutique.com",
                                  hintStyle: GoogleFonts.manrope(
                                    color: textSecondary,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: borderColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: borderColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: primaryColor, width: 2),
                                  ),
                                  suffixIcon: const Icon(Icons.mail_outline, color: textSecondary),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Password Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 8),
                                child: Text(
                                  "Password",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textMain,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: textMain,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter your password",
                                  hintStyle: GoogleFonts.manrope(
                                    color: textSecondary,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: borderColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: borderColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: primaryColor, width: 2),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      color: textSecondary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              
                              // Forgot Password Link
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      "Forgot password?",
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _submitting ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 8,
                                shadowColor: primaryColor.withOpacity(0.2),
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
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.arrow_forward, size: 20),
                                      ],
                                    ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Footer Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  color: const Color(0xFF65817E),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const ShopRegistrationScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
