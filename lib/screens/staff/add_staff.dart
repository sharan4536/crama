import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class AddStaffScreen extends StatefulWidget {
  static const routeName = '/add-staff';
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController();
  final _salaryController = TextEditingController();
  final _addressController = TextEditingController();
  String? _photoPath;
  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _salaryController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) setState(() => _photoPath = xfile.path);
  }

  @override
  Widget build(BuildContext context) {
    // Colors extracted from code.html
    const gradientStart = Color(0xFF58A39B);
    const gradientEnd = Color(0xFF92B3A9);
    const bgLight = Color(0xFFF6F7F7);
    const primary = Color(0xFF57a29b);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientStart, gradientEnd],
            stops: [0.41, 0.81],
          ),
        ),
        child: Column(
          children: [
            // Top Nav & Header Area
            Expanded(
              flex: 2,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Nav Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            'Add Staff',
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 48), // Balance for back button
                        ],
                      ),
                    ),
                    
                    // Profile Input Section
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                                image: _photoPath != null
                                    ? DecorationImage(
                                        image: FileImage(File(_photoPath!)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              child: _photoPath == null
                                  ? const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 40)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Name Input
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: TextField(
                              controller: _nameController,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Staff Name',
                                hintStyle: GoogleFonts.manrope(color: Colors.white.withValues(alpha: 0.6)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          // Phone Input
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: TextField(
                              controller: _phoneController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.phone,
                              style: GoogleFonts.manrope(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: '+91 Phone Number',
                                hintStyle: GoogleFonts.manrope(color: Colors.white.withValues(alpha: 0.38)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content Sheet
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: bgLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    )
                  ],
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Form Tiles mimicking the HTML menu list
                    _buildInputTile(
                      icon: Icons.work_outline_rounded,
                      color: primary,
                      label: 'Role',
                      controller: _roleController,
                      hint: 'e.g. Manager, Tailor',
                    ),
                    const SizedBox(height: 16),
                    _buildInputTile(
                      icon: Icons.attach_money_rounded,
                      color: Colors.orange,
                      label: 'Salary',
                      controller: _salaryController,
                      hint: 'Monthly Salary',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildInputTile(
                      icon: Icons.location_on_outlined,
                      color: Colors.blue,
                      label: 'Address',
                      controller: _addressController,
                      hint: 'Full Address',
                      maxLines: 2,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                           // Logic to save would go here
                           if (_nameController.text.isNotEmpty) {
                             Navigator.pop(context);
                           }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: primary.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.check_rounded),
                        label: Text(
                          'Save Staff',
                          style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputTile({
    required IconData icon,
    required Color color,
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.manrope(color: Colors.black38),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: GoogleFonts.manrope(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
