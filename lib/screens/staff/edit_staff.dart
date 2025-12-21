import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditStaffScreen extends StatefulWidget {
  static const routeName = '/edit-staff';
  
  // Accepting parameters for editing
  final String name;
  final String phone;
  final String role;
  final String salaryType;

  const EditStaffScreen({
    super.key, 
    this.name = 'Sarah Jones', 
    this.phone = '+1 555 019 2834',
    this.role = 'Tailor',
    this.salaryType = 'Monthly',
  });

  @override
  State<EditStaffScreen> createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends State<EditStaffScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late String _selectedRole;
  late String _salaryType;

  // Colors
  static const Color primaryColor = Color(0xFF58A39B);
  static const Color primarySoft = Color(0xFF92B3A9);
  static const Color backgroundLight = Color(0xFFF6F8F8);
  static const Color backgroundDark = Color(0xFF11211F);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    _selectedRole = widget.role;
    _salaryType = widget.salaryType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Stack(
        children: [
          // Background Gradient Layer (Top 320px)
          Container(
            height: 320,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor, primarySoft],
                stops: [0.41, 0.81],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          // Content Container
          Column(
            children: [
              // Top App Bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 40), // Balance back button
                          child: Text(
                            "Edit Staff Details",
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
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100), // Space for sticky footer
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Profile Header
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 112,
                                height: 112,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  image: const DecorationImage(
                                    image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuBDyKPcFMnG1siDDE1jtskURiP5cdaCRwWaml-oC6Of1ne3Axz5aq_XGxlhIaoDzppBTUMEmumSoWhIkDAcy_zq5LEoUiG4q1SlWBXP-w0UXBsOccgsmN8R5c2udd9G6wNaSN1FB4YaCU5_LcFQ_Wg4asx9vsdRIo6GBILcvasyswoVoelDVve1Z_hxeHCqIsm1WAIGvmr6c49VVYNSQj9cJjZyY_x0df2pvVfHt_PSLYjawE60KEjf_G891twn8d6XCbws8RL4iKjj"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.edit, color: primaryColor, size: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Change Photo",
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Main Form Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Staff Name
                            _buildLabel("Staff Name"),
                            const SizedBox(height: 8),
                            _buildInputField(
                              controller: _nameController,
                              hint: "Enter full name",
                              icon: Icons.person_outline,
                            ),

                            const SizedBox(height: 24),

                            // Mobile Number
                            _buildLabel("Mobile Number"),
                            const SizedBox(height: 8),
                            _buildInputField(
                              controller: _phoneController,
                              hint: "Enter mobile number",
                              icon: Icons.call_outlined,
                              keyboardType: TextInputType.phone,
                            ),

                            const SizedBox(height: 24),

                            // Staff Role
                            _buildLabel("Staff Role"),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: _buildRoleCard("Owner", Icons.storefront)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildRoleCard("Cashier", Icons.point_of_sale)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildRoleCard("Tailor", Icons.content_cut)),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Salary Type
                            _buildLabel("Salary Type"),
                            const SizedBox(height: 12),
                            _buildSalaryToggle(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky Footer Action Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundLight.withOpacity(0.95), // Increased opacity since blur is removed
                border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Save logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: primaryColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Save Changes",
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0E1B19),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF0E1B19),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.manrope(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: primaryColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildRoleCard(String role, IconData icon) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEAF6F5) : const Color(0xFFF0F5F4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey[500],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              role,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? primaryColor : Colors.grey[500],
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
        color: const Color(0xFFF0F5F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                alignment: _salaryType == 'Daily' ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  width: width / 2 - 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _salaryType = 'Daily'),
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Text(
                          "Daily",
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _salaryType == 'Daily' ? Colors.white : Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _salaryType = 'Monthly'),
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Text(
                          "Monthly",
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _salaryType == 'Monthly' ? Colors.white : Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
