import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import '../data/shop_profile_store.dart';

class ShopDetailsScreen extends StatefulWidget {
  static const routeName = '/shop-details';
  const ShopDetailsScreen({super.key});

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _shopNameController = TextEditingController();
  final _gstinController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _picker = ImagePicker();
  String? _logoPath;
  String? _ownerPhotoPath;
  String? _selectedState;
  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry',
  ];

  @override
  void initState() {
    super.initState();
    final store = ShopProfileStore();
    _shopNameController.text = store.shopName ?? '';
    _gstinController.text = store.gstin ?? '';
    _streetController.text = store.street ?? '';
    _cityController.text = store.city ?? '';
    _pincodeController.text = store.pincode ?? '';
    _contactPersonController.text = store.contactPerson ?? '';
    _mobileController.text = store.mobile ?? '';
    _emailController.text = store.email ?? '';
    _selectedState = store.state;
    _logoPath = store.logoPath;
    _ownerPhotoPath = store.ownerPhotoPath;
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _gstinController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _contactPersonController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickOwnerPhoto(ImageSource source) async {
    final xfile = await _picker.pickImage(source: source, maxWidth: 1024, imageQuality: 85);
    if (xfile != null) {
      setState(() => _ownerPhotoPath = xfile.path);
    }
  }

  void _showOwnerPhotoSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF58A39B)),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickOwnerPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF58A39B)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickOwnerPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLogo(ImageSource source) async {
    try {
      final xfile = await _picker.pickImage(source: source, maxWidth: 1024, imageQuality: 85);
      if (xfile != null) {
        setState(() => _logoPath = xfile.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showLogoSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF58A39B)),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickLogo(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF58A39B)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickLogo(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanQR() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Scan QR Code')),
          body: MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  Navigator.of(context).pop(barcode.rawValue);
                  break; // Return after first detection
                }
              }
            },
          ),
        ),
      ),
    );

    if (result != null && result is String) {
      setState(() {
        _gstinController.text = result;
      });
    }
  }

  Future<void> _fetchPincodeDetails(String pincode) async {
    if (pincode.length != 6) return;
    
    try {
      final url = Uri.parse('https://api.postalpincode.in/pincode/$pincode');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0]['Status'] == 'Success') {
          final postOffices = data[0]['PostOffice'] as List<dynamic>;
          if (postOffices.isNotEmpty) {
            final city = postOffices[0]['District'];
            final state = postOffices[0]['State'];
            
            setState(() {
              _cityController.text = city;
              // Find matching state in our list
              if (_states.contains(state)) {
                _selectedState = state;
              }
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Pincode')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error fetching pincode: $e');
    }
  }

  Future<void> _saveShopDetails() async {
    // Validate required fields
    List<String> missingFields = [];
    if (_shopNameController.text.trim().isEmpty) missingFields.add('Shop Name');
    if (_gstinController.text.trim().isEmpty) missingFields.add('GSTIN');
    if (_streetController.text.trim().isEmpty) missingFields.add('Street Address');
    if (_cityController.text.trim().isEmpty) missingFields.add('City');
    if (_selectedState == null) missingFields.add('State');
    if (_pincodeController.text.trim().isEmpty) missingFields.add('Pincode');
    if (_contactPersonController.text.trim().isEmpty) missingFields.add('Contact Person');
    if (_mobileController.text.trim().isEmpty) missingFields.add('Mobile Number');
    if (_emailController.text.trim().isEmpty) missingFields.add('Email Address');

    if (missingFields.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill: ${missingFields.join(', ')}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate Mobile Number
    final mobile = _mobileController.text.trim();
    if (mobile.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number starting with 6-9'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate Email
    final email = _emailController.text.trim();
    // Simple regex for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address (e.g. shop@gmail.com)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Validate Pincode-City match
    final pincode = _pincodeController.text.trim();
    final enteredCity = _cityController.text.trim();
    
    if (pincode.length == 6) {
       // Show loading indicator
       showDialog(
         context: context,
         barrierDismissible: false,
         builder: (context) => const Center(child: CircularProgressIndicator()),
       );

       try {
         final url = Uri.parse('https://api.postalpincode.in/pincode/$pincode');
         final response = await http.get(url);
         
         // Remove loading indicator
         Navigator.pop(context);

         if (response.statusCode == 200) {
           final List<dynamic> data = json.decode(response.body);
           if (data.isNotEmpty && data[0]['Status'] == 'Success') {
             final postOffices = data[0]['PostOffice'] as List<dynamic>;
             
             // Check if entered city matches any district or block in the response
             bool cityMatch = false;
             Set<String> validDistricts = {};
             
             for (var office in postOffices) {
               final district = office['District']?.toString() ?? '';
               final block = office['Block']?.toString() ?? '';
               final name = office['Name']?.toString() ?? '';
               
               if (district.isNotEmpty) validDistricts.add(district);
               
               final entered = enteredCity.toLowerCase();
               
               if ((district.isNotEmpty && entered == district.toLowerCase()) || 
                   (block.isNotEmpty && entered == block.toLowerCase()) || 
                   (name.isNotEmpty && entered == name.toLowerCase())) {
                 cityMatch = true;
                 break;
               }
             }

             debugPrint('Pincode validation: entered="$enteredCity", match=$cityMatch, valid=${validDistricts.join(", ")}');

             if (!cityMatch) {
                // Construct a helpful message with valid cities
                final validCities = validDistricts.join(', ');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('City name does not match Pincode. Valid districts: $validCities'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 5),
                  ),
                );
                return;
             }
             
           } else {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Invalid Pincode'), backgroundColor: Colors.red),
             );
             return;
           }
         } else {
            ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Error validating pincode'), backgroundColor: Colors.red),
             );
             return;
         }
       } catch (e) {
         Navigator.pop(context); // Remove loading if error
         debugPrint('Error validating pincode: $e');
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Network error validating pincode'), backgroundColor: Colors.red),
         );
         return;
       }
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pincode must be 6 digits'), backgroundColor: Colors.red),
       );
       return;
    }

    ShopProfileStore().updateShopDetails(
      name: _shopNameController.text,
      gst: _gstinController.text,
      addr: _streetController.text,
      cty: _cityController.text,
      st: _selectedState,
      pin: _pincodeController.text,
      contact: _contactPersonController.text,
      mob: _mobileController.text,
      mail: _emailController.text,
    );
    
    if (_logoPath != null) {
      ShopProfileStore().updateLogo(_logoPath);
    }

    if (_ownerPhotoPath != null) {
      ShopProfileStore().updateOwnerPhoto(_ownerPhotoPath);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Shop details saved successfully!')),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF58A39B);
    const backgroundLight = Color(0xFFF6F7F7);
    const textLight = Color(0xFF121716);
    const inputBorder = Color(0xFFD7E0DF);

    return Scaffold(
      backgroundColor: backgroundLight,
      body: Stack(
        children: [
          // Gradient Background Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 256, // h-64 equivalent
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF58A39B),
                    Color(0xFF58A39B),
                    Color(0xFF92B3A9),
                    Color(0xFFF6F7F7),
                  ],
                  stops: [0.0, 0.41, 0.81, 1.0],
                ),
              ),
            ),
          ),
          
          // Main Container
          SafeArea(
            child: Column(
              children: [
                // Top Navigation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          child: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                        ),
                      ),
                      Text(
                        'Add Shop Details',
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 40, height: 40), // Placeholder for balance
                    ],
                  ),
                ),
                
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // pb-32 + space for button
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: _showLogoSourceSheet,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 96,
                                          height: 96,
                                          decoration: BoxDecoration(
                                            color: backgroundLight,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: primary.withOpacity(0.4),
                                              width: 2,
                                              style: BorderStyle.solid,
                                            ),
                                            image: _logoPath == null
                                                ? null
                                                : DecorationImage(
                                                    image: kIsWeb ? NetworkImage(_logoPath!) : FileImage(File(_logoPath!)) as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          child: _logoPath == null
                                              ? Center(
                                                  child: Icon(Icons.add_a_photo_outlined, color: primary, size: 32),
                                                )
                                              : null,
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: primary,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(Icons.edit, color: Colors.white, size: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Shop Logo',
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textLight,
                                    ),
                                  ),
                                  Text(
                                    'Optional',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                            ),

                            // Basic Info Section
                            _buildSectionHeader(Icons.storefront_outlined, 'Basic Info', primary),
                            const SizedBox(height: 20),
                            
                            _buildLabel('Shop Name'),
                            _buildTextField(
                              controller: _shopNameController,
                              placeholder: 'e.g. Bella Boutique',
                            ),
                            const SizedBox(height: 16),
                            
                            _buildLabel('GSTIN'),
                            _buildTextField(
                              controller: _gstinController,
                              placeholder: '22AAAAA0000A1Z5',
                              suffixIcon: Icons.qr_code_scanner,
                              onSuffixTap: _scanQR,
                              isUppercase: true,
                            ),
                            
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                            ),

                            // Location Section
                            _buildSectionHeader(Icons.location_on_outlined, 'Location', primary),
                            const SizedBox(height: 20),
                            
                            _buildLabel('Street Address'),
                            _buildTextField(
                              controller: _streetController,
                              placeholder: 'Flat, House no., Building, Company, Apartment',
                              maxLines: 2,
                            ),
                            const SizedBox(height: 16),
                            
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('City'),
                                      _buildTextField(
                                        controller: _cityController,
                                        placeholder: 'Mumbai',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('State'),
                                      _buildDropdown(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Pincode'),
                                  _buildTextField(
                                    controller: _pincodeController,
                                    placeholder: '400001',
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    onChanged: _fetchPincodeDetails,
                                  ),
                                ],
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                            ),

                            // Contact Section
                            _buildSectionHeader(Icons.contact_phone_outlined, 'Contact', primary),
                            const SizedBox(height: 20),

                            Center(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: _showOwnerPhotoSourceSheet,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: backgroundLight,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: primary.withOpacity(0.4),
                                              width: 2,
                                              style: BorderStyle.solid,
                                            ),
                                            image: _ownerPhotoPath == null
                                                ? null
                                                : DecorationImage(
                                                    image: kIsWeb ? NetworkImage(_ownerPhotoPath!) : FileImage(File(_ownerPhotoPath!)) as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          child: _ownerPhotoPath == null
                                              ? Center(
                                                  child: Icon(Icons.person_add_alt_1_outlined, color: primary, size: 28),
                                                )
                                              : null,
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: primary,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(Icons.edit, color: Colors.white, size: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Owner Photo',
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textLight,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                            
                            _buildLabel('Contact Person'),
                            _buildTextField(
                              controller: _contactPersonController,
                              placeholder: 'Full Name',
                            ),
                            const SizedBox(height: 16),
                            
                            _buildLabel('Mobile Number'),
                            Row(
                              children: [
                                Container(
                                  height: 52,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: backgroundLight,
                                    border: Border.all(color: inputBorder),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '+91',
                                    style: GoogleFonts.manrope(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 52,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: inputBorder),
                                        right: BorderSide(color: inputBorder),
                                        bottom: BorderSide(color: inputBorder),
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _mobileController,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        hintText: '98765 43210',
                                        hintStyle: GoogleFonts.manrope(color: Colors.grey[400], fontSize: 16),
                                        counterText: '',
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      style: GoogleFonts.manrope(fontSize: 16, color: textLight),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            _buildLabel('Email Address'),
                            _buildTextField(
                              controller: _emailController,
                              placeholder: 'shop@example.com',
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Floating Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                border: const Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveShopDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      shadowColor: primary.withOpacity(0.3),
                    ),
                    child: Text(
                      'Save Shop Details',
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    bool isUppercase = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD7E0DF)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textCapitalization: isUppercase ? TextCapitalization.characters : TextCapitalization.none,
        maxLength: maxLength,
        textInputAction: TextInputAction.next,
        onChanged: onChanged,
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: GoogleFonts.manrope(color: Colors.grey[400], fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffixIcon != null 
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: Colors.grey[400], size: 20),
              )
            : null,
          counterText: '',
        ),
        style: GoogleFonts.manrope(fontSize: 16, color: const Color(0xFF121716)),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD7E0DF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedState,
          hint: Text('Select', style: GoogleFonts.manrope(color: Colors.grey[400], fontSize: 16)),
          isExpanded: true,
          icon: const Icon(Icons.expand_more, color: Colors.grey),
          items: _states.map((String state) {
            return DropdownMenuItem<String>(
              value: state,
              child: Text(state, style: GoogleFonts.manrope(fontSize: 16, color: const Color(0xFF121716))),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedState = newValue;
            });
          },
        ),
      ),
    );
  }
}
