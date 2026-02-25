import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GstTaxSettingsScreen extends StatefulWidget {
  const GstTaxSettingsScreen({super.key});

  @override
  State<GstTaxSettingsScreen> createState() => _GstTaxSettingsScreenState();
}

class _GstTaxSettingsScreenState extends State<GstTaxSettingsScreen> {
  bool _isGstEnabled = true;
  final List<double> _taxSlabs = [0, 5, 12, 18, 28];
  final TextEditingController _newSlabController = TextEditingController();

  @override
  void dispose() {
    _newSlabController.dispose();
    super.dispose();
  }

  void _addTaxSlab() {
    if (_newSlabController.text.isNotEmpty) {
      final val = double.tryParse(_newSlabController.text);
      if (val != null && !_taxSlabs.contains(val)) {
        setState(() {
          _taxSlabs.add(val);
          _taxSlabs.sort();
        });
        _newSlabController.clear();
        Navigator.pop(context);
      }
    }
  }

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
          'GST & Tax Settings',
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
              title: 'General Settings',
              children: [
                SwitchListTile(
                  title: Text(
                    'Enable GST',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Enable GST calculations for all products',
                    style: GoogleFonts.manrope(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  value: _isGstEnabled,
                  activeColor: primary,
                  onChanged: (val) {
                    setState(() => _isGstEnabled = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Tax Slabs',
              children: [
                ..._taxSlabs.map((slab) => ListTile(
                      title: Text(
                        '${slab.toStringAsFixed(0)}% GST',
                        style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _taxSlabs.remove(slab);
                          });
                        },
                      ),
                    )),
                ListTile(
                  leading: const Icon(Icons.add, color: primary),
                  title: Text(
                    'Add New Tax Slab',
                    style: GoogleFonts.manrope(
                      color: primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Add Tax Slab', style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
                        content: TextField(
                          controller: _newSlabController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Percentage (%)',
                            suffixText: '%',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: _addTaxSlab,
                            style: ElevatedButton.styleFrom(backgroundColor: primary),
                            child: const Text('Add', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
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
            children: children,
          ),
        ),
      ],
    );
  }
}
