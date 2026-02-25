import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  final Map<String, bool> _exportOptions = {
    'Customers': true,
    'Products': true,
    'Sales History': false,
    'Expenses': false,
  };
  String _selectedFormat = 'Excel';

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
          'Export Data',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Data to Export',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
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
                children: _exportOptions.entries.map((entry) {
                  return CheckboxListTile(
                    title: Text(entry.key, style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
                    value: entry.value,
                    activeColor: primary,
                    onChanged: (val) {
                      setState(() => _exportOptions[entry.key] = val!);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Export Format',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _formatCard('CSV', Icons.table_chart, primary),
                const SizedBox(width: 12),
                _formatCard('Excel', Icons.grid_on, primary),
                const SizedBox(width: 12),
                _formatCard('PDF', Icons.picture_as_pdf, primary),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export started... Check notifications.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.download, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Export Selected Data',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formatCard(String format, IconData icon, Color primary) {
    final isSelected = _selectedFormat == format;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFormat = format),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? primary.withValues(alpha: 0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primary : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? primary : Colors.grey),
              const SizedBox(height: 8),
              Text(
                format,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? primary : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
