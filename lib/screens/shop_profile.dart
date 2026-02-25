import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import '../data/shop_profile_store.dart';
import 'shop_details.dart';
import 'settings/gst_tax_settings.dart';
import 'settings/invoice_format.dart';
import 'settings/backup_restore.dart';
import 'settings/export_data.dart';
import 'onboarding.dart';
import '../auth/login.dart';

class ShopProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ShopProfileScreen({super.key});

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  final _picker = ImagePicker();
  String? _logoPath;
  String? _ownerPhotoPath;

  @override
  void initState() {
    super.initState();
    _logoPath = ShopProfileStore().logoPath;
    _ownerPhotoPath = ShopProfileStore().ownerPhotoPath;
    ShopProfileStore().addListener(_onStoreUpdate);
  }

  @override
  void dispose() {
    ShopProfileStore().removeListener(_onStoreUpdate);
    super.dispose();
  }

  void _onStoreUpdate() {
    setState(() {
      _logoPath = ShopProfileStore().logoPath;
      _ownerPhotoPath = ShopProfileStore().ownerPhotoPath;
    });
  }

  Future<void> _navigateToShopDetails() async {
    await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const ShopDetailsScreen(),
      ),
    );
    // Store listener will update UI, but we can also force check here if needed
  }

  Future<void> _pickOwnerPhoto(ImageSource source) async {
    try {
      final xfile = await _picker.pickImage(source: source, maxWidth: 1024, imageQuality: 85);
      if (xfile != null) {
        setState(() => _ownerPhotoPath = xfile.path);
        ShopProfileStore().updateOwnerPhoto(_ownerPhotoPath);
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
        ShopProfileStore().updateLogo(_logoPath);
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

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF58A39B);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F7),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF58A39B), Color(0xFF92B3A9)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.chevron_left, color: Colors.white, size: 28),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Settings',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40, height: 40),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.16),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                image: _logoPath == null
                                    ? const DecorationImage(
                                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAXcYkF_kEJL7KrJjMrTLPgihAKV6_EjaMWZHV2Tgjgd4vR6eMSrh7OgIqOy5AgmRbXSztEKo0Z7vHE859OitNZYTqLX1Jygu2wdrVKRxwCF8eeeaZ5ffRrUq0x3Wj24PkHHhMFRVs3QrGLnkVoK4j1zSORJ3rqk3i11nUWblHo0-Zz0DgyArhpatzTNMs90pc6689XWxYEII1p7b2RyQblZis5pjpIvmGfIpUSZ-fBz8PoJiSbnu-c8lDCAga8yxoGQH1VZH_d2HI2'),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: kIsWeb ? NetworkImage(_logoPath!) : FileImage(File(_logoPath!)) as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
                                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
                                ]),
                                padding: const EdgeInsets.all(6),
                                child: Icon(Icons.edit, size: 16, color: primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Shop Name (Editable)
                      GestureDetector(
                        onTap: _navigateToShopDetails,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ShopProfileStore().shopName?.isNotEmpty == true ? ShopProfileStore().shopName! : 'Shop Name',
                              style: GoogleFonts.manrope(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.edit, color: Colors.white70, size: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Owner Info (Photo + Name)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _showOwnerPhotoSourceSheet,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                image: _ownerPhotoPath == null
                                    ? const DecorationImage(
                                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC6lwNYWA1pLXMALT03RKbuVZJBcJiA8sTiFOolzTT-XMqnuLTTaEvpZB-g_d_MZq2X0hKRe5DQ7BxcNuqwyDA_HSPnHohJIFvAikcsj2_w3HhGi8PwzHf7HLL5wyhZ5CK5YC8Bo-2GFpMte9Agg6S6AlBT-oWSxBdL2tGr6CpiL5WU87yq1FCpFexqryEPTu_98RtD5u6HLnmz4Y1xQOEIWTagx2scpfzfZYCTQNfVm72CMK5m6DOfacZRTlhJ0xZoCxCMSneZ9Frh'),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: kIsWeb ? NetworkImage(_ownerPhotoPath!) : FileImage(File(_ownerPhotoPath!)) as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              child: _ownerPhotoPath == null
                                  ? const Icon(Icons.add_a_photo, size: 16, color: Colors.white70)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _navigateToShopDetails,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ShopProfileStore().contactPerson?.isNotEmpty == true ? ShopProfileStore().contactPerson! : 'Owner Name',
                                  style: GoogleFonts.manrope(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Owner',
                                  style: GoogleFonts.manrope(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _sectionTitle('Shop & Billing'),
                          _cardGroup(
                            children: [
                              _settingsItem(
                                icon: Icons.storefront_rounded,
                                label: 'Shop Details',
                                sublabel: 'Address, Contact Info, Logo',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const ShopDetailsScreen(),
                                    ),
                                  );
                                },
                              ),
                              _divider(),
                              _settingsItem(
                                icon: Icons.calculate_rounded,
                                label: 'GST & Tax Settings',
                                sublabel: 'Tax Slabs, HSN Codes',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const GstTaxSettingsScreen(),
                                    ),
                                  );
                                },
                              ),
                              _divider(),
                              _settingsItem(
                                icon: Icons.receipt_long_rounded,
                                label: 'Invoice Format',
                                sublabel: 'Templates, Terms & Conditions',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const InvoiceFormatScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _sectionTitle('Data Management'),
                          _cardGroup(
                            children: [
                              _settingsItem(
                                icon: Icons.cloud_upload_rounded,
                                label: 'Backup & Restore',
                                sublabel: null,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const BackupRestoreScreen(),
                                    ),
                                  );
                                },
                              ),
                              _divider(),
                              _settingsItem(
                                icon: Icons.ios_share,
                                label: 'Export Data',
                                sublabel: 'PDF, Excel, CSV',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const ExportDataScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _sectionTitle('Account'),
                          _cardGroup(
                            children: [
                              _settingsItem(
                                icon: Icons.logout_rounded,
                                label: 'Logout',
                                sublabel: null,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Logout", style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
                                        content: Text("Are you sure you want to logout?", style: GoogleFonts.manrope()),
                                        actions: [
                                          TextButton(
                                            child: Text("No", style: GoogleFonts.manrope(color: Colors.grey)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Yes", style: GoogleFonts.manrope(color: Colors.red, fontWeight: FontWeight.bold)),
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                              ShopProfileStore().clearState();
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: const OnboardingScreen(),
                                                ),
                                                (route) => false,
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                danger: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text('App Version 1.0.4', style: GoogleFonts.manrope(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                          ),
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.manrope(color: Colors.white.withValues(alpha: 0.9), fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1),
      ),
    );
  }

  Widget _cardGroup({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, color: Color(0xFFE5E7EB));
  }

  Widget _settingsItem({
    required IconData icon,
    required String label,
    String? sublabel,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    const primary = Color(0xFF58A39B);
    final iconBg = danger ? const Color(0xFFFFEBEE) : primary.withValues(alpha: 0.1);
    final iconColor = danger ? const Color(0xFFF44336) : primary;
    final textColor = danger ? const Color(0xFFF44336) : const Color(0xFF0F172A);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.manrope(color: textColor, fontSize: 15, fontWeight: FontWeight.w700)),
                  if (sublabel != null)
                    Text(sublabel, style: GoogleFonts.manrope(color: const Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: danger ? const Color(0xFFF44336) : const Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
