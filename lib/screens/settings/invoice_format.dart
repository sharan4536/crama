import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InvoiceFormatScreen extends StatefulWidget {
  const InvoiceFormatScreen({super.key});

  @override
  State<InvoiceFormatScreen> createState() => _InvoiceFormatScreenState();
}

class _InvoiceFormatScreenState extends State<InvoiceFormatScreen> {
  String _selectedFormat = 'A4';
  final TextEditingController _prefixController = TextEditingController(text: 'INV-');
  final TextEditingController _termsController = TextEditingController(text: 'Thank you for your business!');

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF58A39B);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F7),
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Invoice Format',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Paper Size',
              children: [
                _radioTile('A4 (Standard)', 'A4'),
                _radioTile('A5 (Half)', 'A5'),
                _radioTile('Thermal 80mm', '80mm'),
                _radioTile('Thermal 58mm', '58mm'),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Prefix & Numbering',
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _prefixController,
                    decoration: const InputDecoration(
                      labelText: 'Invoice Prefix',
                      border: OutlineInputBorder(),
                      helperText: 'e.g. INV-2023-001',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Terms & Conditions',
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _termsController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Default Terms',
                      border: OutlineInputBorder(),
                      helperText: 'Appears at the bottom of every invoice',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invoice settings saved')),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'Save Changes',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _radioTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(title, style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
      value: value,
      groupValue: _selectedFormat,
      activeColor: const Color(0xFF58A39B),
      onChanged: (val) {
        setState(() => _selectedFormat = val!);
      },
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.manrope(
              color: Colors.grey[800],
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );
  }
}
