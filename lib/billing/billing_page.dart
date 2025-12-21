import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';

class BillingScreen extends StatefulWidget {
  static const routeName = '/billing';
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final _searchController = TextEditingController();
  final _phoneController = TextEditingController();
  final _stitchController = TextEditingController();
  final _advanceController = TextEditingController();
  final List<_BillItem> _items = [];
  final List<_CatalogItem> _catalog = [
    _CatalogItem('Saree', 1200, '10001'),
    _CatalogItem('Blouse', 450, '10002'),
    _CatalogItem('Lehenga', 2800, '10003'),
    _CatalogItem('Kurti', 900, '10004'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _phoneController.dispose();
    _stitchController.dispose();
    _advanceController.dispose();
    super.dispose();
  }

  void _addCatalogItem(_CatalogItem c) {
    final existing = _items.indexWhere((i) => i.code == c.code);
    if (existing >= 0) {
      setState(() => _items[existing] = _items[existing].copyWith(qty: _items[existing].qty + 1));
    } else {
      setState(() => _items.add(_BillItem(c.name, c.price, 1, c.code)));
    }
  }

  void _scanBarcode() async {
    await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 360,
            child: MobileScanner(
              onDetect: (capture) {
                final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
                final value = barcode?.rawValue ?? '';
                if (value.isNotEmpty) {
                  final found = _catalog.firstWhere(
                    (c) => c.code == value,
                    orElse: () => _CatalogItem('Item $value', 0, value),
                  );
                  Navigator.pop(context);
                  _addCatalogItem(found);
                  HapticFeedback.lightImpact();
                }
              },
            ),
          ),
        );
      },
    );
  }

  int get _stitchingCharge => int.tryParse(_stitchController.text.trim()) ?? 0;
  int get _subtotal => _items.fold(0, (p, e) => p + e.price * e.qty) + _stitchingCharge;
  int get _advance => int.tryParse(_advanceController.text.trim()) ?? 0;
  int get _balance => (_subtotal - _advance).clamp(0, 1 << 30);

  Future<void> _shareWhatsApp() async {
    final doc = await _buildPdf();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/crama_bill_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await doc.save());
    final text = 'Crama bill. Balance: ₹$_balance';
    await Share.shareXFiles([XFile(file.path)], text: text);
    HapticFeedback.lightImpact();
  }

  Future<void> _printTicket() async {
    final doc = await _buildPdf(width58mm: true);
    await Printing.layoutPdf(onLayout: (_) async => doc.save());
    HapticFeedback.lightImpact();
  }

  Future<pw.Document> _buildPdf({bool width58mm = false}) async {
    final pdf = pw.Document();
    final width = width58mm ? 226.77 : null;
    pdf.addPage(
      pw.Page(
        pageFormat: width != null ? PdfPageFormat(width, PdfPageFormat.a4.height) : PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Container(
                      width: 40,
                      height: 40,
                      decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, color: const PdfColor.fromInt(0xFF1A237E)),
                    ),
                    pw.SizedBox(width: 12),
                    pw.Text('Crama Boutique', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Text('Items'),
                pw.SizedBox(height: 6),
                pw.Table(
                  border: null,
                  children: [
                    ..._items.map((e) => pw.TableRow(children: [
                          pw.Text(e.name),
                          pw.Text('x${e.qty}'),
                          pw.Text('₹${e.price * e.qty}'),
                        ])),
                    if (_stitchingCharge > 0)
                      pw.TableRow(children: [pw.Text('Stitching'), pw.Text(''), pw.Text('₹$_stitchingCharge')]),
                  ],
                ),
                pw.Divider(),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('Subtotal'), pw.Text('₹$_subtotal')]),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('Advance'), pw.Text('₹$_advance')]),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('Balance'), pw.Text('₹$_balance')]),
              ],
            ),
          );
        },
      ),
    );
    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D4B7);
    const coral = Color(0xFFFF6B3A);
    const gold = Color(0xFFFFD700);
    final q = _searchController.text.trim().toLowerCase();
    final matches = _catalog.where((c) => c.name.toLowerCase().contains(q) || c.code.contains(q)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Billing'), backgroundColor: Colors.white, foregroundColor: teal, elevation: 0),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 28, backgroundColor: teal, child: const Icon(Icons.store_rounded, color: Colors.white)),
                const SizedBox(width: 12),
                const Text('Crama Boutique', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search item or barcode',
                      prefixIcon: const Icon(Icons.search_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: coral, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14)),
                  onPressed: _scanBarcode,
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text('Scan'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (q.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: matches.map((c) => ActionChip(label: Text('${c.name} • ₹${c.price}'), onPressed: () => _addCatalogItem(c))).toList(),
              ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  color: const Color(0xFFF8FAFC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700))),
                        Text('₹${item.price}'),
                        const SizedBox(width: 8),
                        Row(children: [
                          IconButton(onPressed: () => setState(() => item.qty = (item.qty - 1).clamp(1, 999)), icon: const Icon(Icons.remove_circle_rounded)),
                          Text('${item.qty}'),
                          IconButton(onPressed: () => setState(() => item.qty = item.qty + 1), icon: const Icon(Icons.add_circle_rounded)),
                        ]),
                        IconButton(onPressed: () => setState(() => _items.removeAt(index)), icon: const Icon(Icons.delete, color: Colors.red)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _stitchController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: 'Custom stitching charge', border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)), filled: true, fillColor: const Color(0xFFF8FAFC)),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _advanceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: 'Advance', border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)), filled: true, fillColor: const Color(0xFFF8FAFC)),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(labelText: 'Balance: ₹$_balance', border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)), filled: true, fillColor: const Color(0xFFF8FAFC)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: gold, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36))),
                    onPressed: _printTicket,
                    child: const Text('Print'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: gold, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36))),
                    onPressed: _shareWhatsApp,
                    child: const Text('Share on WhatsApp'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogItem {
  final String name;
  final int price;
  final String code;
  const _CatalogItem(this.name, this.price, this.code);
}

class _BillItem {
  final String name;
  final int price;
  int qty;
  final String code;
  _BillItem(this.name, this.price, this.qty, this.code);
  _BillItem copyWith({String? name, int? price, int? qty, String? code}) => _BillItem(name ?? this.name, price ?? this.price, qty ?? this.qty, code ?? this.code);
}
