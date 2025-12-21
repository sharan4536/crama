import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/customer_store.dart';
import '../../models/customer.dart';

class EditCustomerScreen extends StatefulWidget {
  final Customer customer;
  const EditCustomerScreen({super.key, required this.customer});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;
  final Map<String, TextEditingController> _measureCtrls = {};
  final Set<String> _styles = {};
  String? _photoPath;

  final _picker = ImagePicker();
  final List<String> _styleOptions = const ['Anarkali', 'Lehenga', 'Saree Blouse', 'Kurti', 'Gown', 'Salwar'];

  // Theme Colors
  static const Color primaryColor = Color(0xFF58A39B);
  static const Color backgroundLight = Color(0xFFF6F7F7);
  static const Color textMain = Color(0xFF121716);

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameController = TextEditingController(text: c.name);
    _phoneController = TextEditingController(text: c.phone);
    _notesController = TextEditingController(text: c.notes ?? '');
    _photoPath = c.photoPath;
    _styles.addAll(c.styles);

    _initMeasureCtrl('Chest', c.chest);
    _initMeasureCtrl('Waist', c.waist);
    _initMeasureCtrl('Hip', c.hip);
    _initMeasureCtrl('Shoulder', c.shoulder);
    _initMeasureCtrl('Sleeve Length', c.sleeveLength);
    _initMeasureCtrl('Neck', c.neck);
    _initMeasureCtrl('Blouse Length', c.blouseLength);
  }

  void _initMeasureCtrl(String key, double? value) {
    _measureCtrls[key] = TextEditingController(text: value?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    for (final c in _measureCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final xfile = await _picker.pickImage(source: source, maxWidth: 1024, imageQuality: 85);
    if (xfile != null) {
      setState(() => _photoPath = xfile.path);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    
    double? parse(String k) => double.tryParse(_measureCtrls[k]!.text.trim());
    
    // Update the existing customer object
    final c = widget.customer;
    c.name = _nameController.text.trim();
    c.phone = _phoneController.text.trim();
    c.photoPath = _photoPath;
    c.chest = parse('Chest');
    c.waist = parse('Waist');
    c.hip = parse('Hip');
    c.shoulder = parse('Shoulder');
    c.sleeveLength = parse('Sleeve Length');
    c.neck = parse('Neck');
    c.blouseLength = parse('Blouse Length');
    c.notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();
    c.styles = _styles.toList();

    CustomerStore().update(c);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: Text('Edit Customer', style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Photo Section
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: _photoPath != null ? FileImage(File(_photoPath!)) : null,
                      child: _photoPath == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => _showImageSourceSheet(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Personal Details'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _nameController,
              label: 'Customer Name',
              icon: Icons.person_outline,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().length < 8) ? 'Enter phone' : null,
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Measurements (cm)'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _measureCtrls.entries.map((e) => SizedBox(
                width: (MediaQuery.of(context).size.width - 44) / 2, // 2 columns
                child: _buildTextField(
                  controller: e.value,
                  label: e.key,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  suffix: 'cm',
                ),
              )).toList(),
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Favorite Styles'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _styleOptions.map((s) => FilterChip(
                label: Text(s, style: GoogleFonts.manrope(
                  color: _styles.contains(s) ? Colors.white : textMain,
                  fontWeight: FontWeight.w500,
                )),
                selected: _styles.contains(s),
                selectedColor: primaryColor,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: _styles.contains(s) ? primaryColor : Colors.grey.shade300),
                ),
                onSelected: (v) => setState(() => v ? _styles.add(s) : _styles.remove(s)),
              )).toList(),
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Notes'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _notesController,
              label: 'Special Instructions',
              maxLines: 3,
              icon: Icons.note_outlined,
            ),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: primaryColor),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: primaryColor),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textMain,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    String? suffix,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: textMain),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.manrope(color: Colors.grey),
        prefixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
        suffixText: suffix,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
