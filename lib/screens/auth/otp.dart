import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // Colors from HTML
  static const Color primaryColor = Color(0xFF58A39B);
  static const Color gradientStart = Color(0xFF58A39B);
  static const Color gradientEnd = Color(0xFF92B3A9);
  static const Color textMain = Color(0xFF141b0e);
  static const Color textMuted = Color(0xFF6b7a60);

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
    // Handle backspace to move to previous field
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
  }

  void _verify() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: const HomePage()));
  }

  String _maskPhone(String phone) {
    if (phone.length < 4) return phone;
    return "+91 *******${phone.substring(phone.length - 3)}"; // Showing last 3 digits as per design example ends in 480
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
          
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 40), // Balance the back button
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

                // Main Content Card
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
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        children: [
                          // Icon
                          Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.sms_outlined,
                              color: primaryColor,
                              size: 40,
                            ),
                          ),

                          // Titles
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

                          const SizedBox(height: 40),

                          // OTP Inputs
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (index) {
                              return Container(
                                width: 48, // slightly smaller to fit 6 in row
                                height: 56,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _nodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  onChanged: (value) => _onChanged(index, value),
                                  style: GoogleFonts.manrope(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
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
                                      borderSide: const BorderSide(color: primaryColor, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 40),

                          // Resend Section
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
                                  // Resend logic
                                  HapticFeedback.selectionClick();
                                },
                                child: Text(
                                  "Resend OTP",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
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
                              color: textMuted.withOpacity(0.7),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Verify Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _verify,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: primaryColor.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Verify",
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
