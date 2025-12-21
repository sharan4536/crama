import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';
import '../../models/customer.dart';
import 'edit_customer.dart';

class CustomerProfileScreen extends StatefulWidget {
  final Customer customer;

  const CustomerProfileScreen({
    super.key,
    required this.customer,
  });

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  static const Color primaryColor = Color(0xFF58A39B);
  static const Color backgroundLight = Color(0xFFF6F7F7);
  static const Color textMain = Color(0xFF121716);

  @override
  Widget build(BuildContext context) {
    final c = widget.customer;
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.41, 0.81],
                colors: [
                  Color(0xFF58A39B),
                  Color(0xFF92B3A9),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                _buildProfileInfo(c),
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: backgroundLight,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                      child: Column(
                        children: [
                          _buildStatsRow(),
                          const SizedBox(height: 24),
                          _buildMenuList(c),
                          const SizedBox(height: 32),
                          _buildCreateBillButton(),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          Text(
            "Customer Profile",
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          InkWell(
            onTap: () async {
              await Navigator.push(
                context, 
                PageTransition(
                  type: PageTransitionType.rightToLeft, 
                  child: EditCustomerScreen(customer: widget.customer)
                )
              );
              setState(() {});
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Edit",
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(Customer c) {
    ImageProvider? imageProvider;
    if (c.photoPath != null && c.photoPath!.isNotEmpty) {
      final file = File(c.photoPath!);
      if (file.existsSync()) {
        imageProvider = FileImage(file);
      }
    }
    // Fallback image if file doesn't exist or not provided
    imageProvider ??= const NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuAh04chp-ADHU018hAGfn0TP0FAlNwVOkWd1eCYPIxpkPHSQ1qH5_QEAzRu7OD1FnFZBrfBlpemktSUniydNIR6wbkDoi_qdycf73KpOr7oeMtmd3oukPhuqCyhGAtMON9KG13lGS0vBjdJ6hNrM9jVt2VOmKGDIzAxOOe8RRPVJAmFWHPRmSKVMMtCBUvr9vP9AOEK9uP_Rhexsmpo0KW0KbYk4lMrviHPDs1M8jdg6OxKwq1JgGuGyabxAnaoeCYK6TyLvznHN8dR");

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: _CustomerProfileScreenState.primaryColor, width: 4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          c.name,
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          c.phone,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildQuickActionButton(Icons.call),
            const SizedBox(width: 16),
            _buildQuickActionButton(Icons.chat_bubble_outline),
            const SizedBox(width: 16),
            _buildQuickActionButton(Icons.mail_outline),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1), // Adjusted for better visibility
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildQuickActionButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard("Spend", "\$1,240", null)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard("Visits", "12", null)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard("Credits", "\$0.00", Colors.green)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color? valueColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor ?? textMain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(Customer c) {
    String measurements = "No measurements added";
    if (c.chest != null || c.waist != null || c.hip != null) {
      List<String> parts = [];
      if (c.chest != null) parts.add("Bust ${c.chest}\"");
      if (c.waist != null) parts.add("Waist ${c.waist}\"");
      if (c.hip != null) parts.add("Hip ${c.hip}\"");
      measurements = parts.join(" • ");
    }

    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.straighten,
          title: "Measurements",
          subtitle: measurements,
          iconColor: primaryColor,
          iconBgColor: primaryColor.withOpacity(0.1),
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.history_edu,
          title: "Purchase History",
          subtitle: "Last purchased 2 days ago",
          iconColor: Colors.orange,
          iconBgColor: Colors.orange.withOpacity(0.1),
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          icon: Icons.receipt_long,
          title: "Bills & Invoices",
          subtitle: "1 Invoice Pending",
          iconColor: Colors.blue,
          iconBgColor: Colors.blue.withOpacity(0.1),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textMain,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildCreateBillButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add),
            const SizedBox(width: 8),
            Text(
              "Create New Bill",
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
