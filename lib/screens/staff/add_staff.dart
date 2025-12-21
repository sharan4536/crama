import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class AddStaffScreen extends StatefulWidget {
  static const routeName = '/add-staff';
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _selectedRole = 'cashier';
  String _salaryType = 'monthly';

  // Colors from HTML
  static const Color primaryColor = Color(0xFF58A39B);
  static const Color gradientStart = Color(0xFF58A39B);
  static const Color gradientEnd = Color(0xFF92B3A9);
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
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
            bottom: false,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120), // Padding for footer
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildProfileUpload(),
                          const SizedBox(height: 24),
                          _buildLabel("Staff Name"),
                          _buildTextField(
                            controller: _nameController,
                            hint: "e.g. Sarah Jones",
                          ),
                          const SizedBox(height: 24),
                          _buildLabel("Mobile Number"),
                          _buildPhoneField(),
                          const SizedBox(height: 24),
                          _buildLabel("Role"),
                          _buildRoleGrid(),
                          const SizedBox(height: 24),
                          _buildLabel("Salary Type"),
                          _buildSalaryToggle(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed Bottom Sheet Footer
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 40), // Balance back button
              child: Text(
                "Add New Staff",
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.015,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileUpload() {
    return Center(
      child: SizedBox(
        width: 96,
        height: 96,
        child: Stack(
          children: [
            // Dashed Border Container
            CustomPaint(
              size: const Size(96, 96),
              painter: DashedCirclePainter(color: primaryColor, strokeWidth: 2, gap: 4),
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.add_a_photo_outlined, color: primaryColor, size: 32),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.manrope(fontSize: 16, color: Colors.grey[800]),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.manrope(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.manrope(fontSize: 16, color: Colors.grey[800]),
              decoration: InputDecoration(
                hintText: "e.g. +1 555-0123",
                hintStyle: GoogleFonts.manrope(color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey[100]!)),
            ),
            child: const Icon(Icons.phone_outlined, color: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleGrid() {
    return Row(
      children: [
        Expanded(child: _buildRoleCard("Owner", "owner", Icons.admin_panel_settings_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _buildRoleCard("Cashier", "cashier", Icons.point_of_sale_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _buildRoleCard("Tailor", "tailor", Icons.content_cut_outlined)),
      ],
    );
  }

  Widget _buildRoleCard(String label, String value, IconData icon) {
    final isSelected = _selectedRole == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = value),
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey[400],
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? primaryColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildSalaryOption("Daily Wage", "daily")),
          Expanded(child: _buildSalaryOption("Monthly Salary", "monthly")),
        ],
      ),
    );
  }

  Widget _buildSalaryOption(String label, String value) {
    final isSelected = _salaryType == value;
    return GestureDetector(
      onTap: () => setState(() => _salaryType = value),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[500],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Save logic
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: primaryColor.withOpacity(0.3),
            ).copyWith(
              elevation: WidgetStateProperty.all(4),
            ),
            child: Text(
              "Save Staff Details",
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedCirclePainter({required this.color, required this.strokeWidth, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = math.min(size.width / 2, size.height / 2);
    final double circumference = 2 * math.pi * radius;
    final double dashWidth = 5.0;
    final int dashCount = (circumference / (dashWidth + gap)).floor();
    final double adjustedGap = (circumference - (dashCount * dashWidth)) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = (i * (dashWidth + adjustedGap)) / radius;
      final double sweepAngle = dashWidth / radius;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
