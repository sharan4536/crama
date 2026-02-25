import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderTrackingScreen extends StatefulWidget {
  static const routeName = '/order-tracking';
  final String orderId;
  final String customerName;
  final String? customerPhone;
  final String? avatarUrl;
  final String? dateLabel;
  final String? statusText;
  final List<DetailItem>? items;
  final DateTime expectedDate;
  final int balanceAmount;
  final int? initialStageIndex;
  const OrderTrackingScreen({
    super.key,
    required this.orderId,
    required this.customerName,
    this.customerPhone,
    this.avatarUrl,
    this.dateLabel,
    this.statusText,
    this.items,
    required this.expectedDate,
    required this.balanceAmount,
    this.initialStageIndex,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late int _stageIndex;

  @override
  void initState() {
    super.initState();
    _stageIndex = (widget.initialStageIndex ?? 0).clamp(0, 4);
  }

  double get _progress => _stageIndex / 4.0;
  String get _statusLabel => widget.statusText ?? (_stageIndex >= 4 ? 'Delivered' : 'Processing');

  Future<void> _sendWhatsApp() async {
    final phoneRaw = (widget.customerPhone ?? '').trim();
    if (phoneRaw.isEmpty) return;
    final digits = phoneRaw.replaceAll(RegExp(r'[^\d]'), '');
    final normalized = digits.startsWith('91') || digits.startsWith('+91') ? digits.replaceFirst('+', '') : '91$digits';
    final msg = 'Hi, your order ${widget.orderId} status: $_statusLabel';
    final uri = Uri.parse('https://wa.me/$normalized?text=${Uri.encodeComponent(msg)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      HapticFeedback.lightImpact();
    }
  }

  void _advanceStage() {
    if (_stageIndex < 4) {
      setState(() => _stageIndex++);
    }
  }

  void _printInvoice() {
    final items = widget.items ?? _defaultItems();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.receipt_long, size: 48, color: Color(0xFF58A39B)),
              const SizedBox(height: 16),
              Text(
                'Invoice Preview',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF121716),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Order ${widget.orderId}',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              ...items.take(3).map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₹${item.price.toStringAsFixed(2)}',
                      style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
              if (items.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '...and ${items.length - 3} more items',
                    style: GoogleFonts.manrope(color: Colors.grey[500], fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Text('Cancel', style: GoogleFonts.manrope(color: Colors.black, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sending invoice to printer...'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xFF58A39B),
                          ),
                        );
                      },
                      icon: const Icon(Icons.print, size: 18),
                      label: Text('Print', style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF58A39B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF58A39B);
    const primaryDark = Color(0xFF3D736E);
    const backgroundLight = Color(0xFFF6F7F7);
    final eta = '${widget.expectedDate.day}-${widget.expectedDate.month}-${widget.expectedDate.year}';
    final items = widget.items ?? _defaultItems();
    final subtotal = items.fold<double>(0.0, (sum, it) => sum + it.price * it.qty);
    final discount = items.fold<double>(0.0, (sum, it) => sum + ((it.strikePrice != null ? it.strikePrice! - it.price : 0.0) * it.qty));
    final tax = subtotal * 0.05;
    final total = subtotal - discount + tax;
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Container(
        color: backgroundLight,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[300]!)),
                            alignment: Alignment.center,
                            child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Order ${widget.orderId}',
                          style: GoogleFonts.manrope(color: const Color(0xFF121716), fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[300]!)),
                        alignment: Alignment.center,
                        child: const Icon(Icons.more_vert, color: Colors.black, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 220),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 840),
                      child: Column(
                        children: [
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [
                                  BoxShadow(color: primary.withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, 6)),
                                ]),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 56,
                                              height: 56,
                                              decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFF1F5F9), border: Border.all(color: Colors.white)),
                                              clipBehavior: Clip.antiAlias,
                                            child: Image.network(
                                                widget.avatarUrl ??
                                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDZyR0uo8VSzNUqAPLYQOXstLujdMcyy0WHhi0FRIudKwH08ooN1t8m-3iMD9_ympeQIeFBUfbshDCgn2P4v3Q489ywbPOC5epUDRNFkkTXDOy86atIZZyancO6797cumEm4rVGV9icWhPCmhoEvdRID0q6mYsFtYiAr4OSmJpP9MXs3MAHXoT_h5Im9B9XtWNL3MlWau0ARhNB3lKr9RYLaKpQ76D6Gd6XSz1TCpv1ZUhwJ0b4pCsLRMEz-S7-ZlYhDzO2UkoPkBNg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(widget.customerName, style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                                                Text(widget.dateLabel ?? 'Placed on Today, 10:30 AM', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600]!)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: _sendWhatsApp,
                                          borderRadius: BorderRadius.circular(20),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                                            alignment: Alignment.center,
                                            child: Icon(Icons.chat, color: primary),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(height: 1, color: Colors.grey[200]),
                                    const SizedBox(height: 12),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(999)),
                                              alignment: Alignment.center,
                                              child: Icon(Icons.smartphone, color: Colors.grey[600], size: 18),
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Mobile Number', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                                                Text(widget.customerPhone ?? '+91 9876543210', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(999)),
                                              alignment: Alignment.center,
                                              child: Icon(Icons.location_on, color: Colors.grey[600], size: 18),
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Delivery Address', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                                                Text('452 Fashion Avenue, Design District,\nNew York, NY 10018', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [
                                  BoxShadow(color: primary.withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, 6)),
                                ]),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Order Status', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              decoration: BoxDecoration(
                                            color: _statusBgColor(_statusLabel),
                                                borderRadius: BorderRadius.circular(999),
                                            border: Border.all(color: _statusRingColor(_statusLabel).withValues(alpha: 0.2)),
                                              ),
                                              child: Text(_statusLabel, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w800, color: _statusTextColor(_statusLabel))),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        _ProgressBar(progress: _progress),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [
                                      BoxShadow(color: primary.withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, 6)),
                                    ]),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                    Text('Order Items (${items.fold<int>(0, (s, it) => s + it.qty)})', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                                        const SizedBox(height: 12),
                                    ..._renderItems(items),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [
                                  BoxShadow(color: primary.withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, 6)),
                                ]),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Payment Details', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                                        const SizedBox(height: 8),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('Subtotal', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                                      Text('₹${subtotal.toStringAsFixed(2)}', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                                        ]),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('Discount Applied', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                                      Text('-₹${discount.toStringAsFixed(2)}', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF047857))),
                                        ]),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('Tax (5%)', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                                      Text('₹${tax.toStringAsFixed(2)}', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                                        ]),
                                        Container(height: 1, color: Colors.grey[200], margin: const EdgeInsets.symmetric(vertical: 8)),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('Total Amount', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                                      Text('₹${total.toStringAsFixed(2)}', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w900, color: primary)),
                                        ]),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                                          padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 32,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
                                            child: const Icon(Icons.credit_card, color: primary, size: 20),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Payment Method', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                                                Text('Credit Card ending in 4242', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFA7F3D0))),
                                            child: Text('PAID', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF065F46))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1))),
        padding: const EdgeInsets.all(12),
        child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 840),
                      child: Row(
                        children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: _printInvoice,
                    icon: const Icon(Icons.print, size: 20),
                    label: Text('Print Invoice', style: GoogleFonts.manrope(fontWeight: FontWeight.w800)),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: primary.withValues(alpha: 0.2), width: 2)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _advanceStage,
                    icon: const Icon(Icons.edit_square, size: 20),
                    label: Text('Update Status', style: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 10,
                      shadowColor: primary.withValues(alpha: 0.3),
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
      ),
    );
  }
}

class DetailItem {
  final String imageUrl;
  final String title;
  final String subtitle;
  final int qty;
  final double price;
  final double? strikePrice;
  const DetailItem({required this.imageUrl, required this.title, required this.subtitle, required this.qty, required this.price, this.strikePrice});
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF58A39B);
    final width = MediaQuery.of(context).size.width - 16 * 2 - 32;
    final stages = const ['Order\nStarted', 'Stitching', 'Embroidery', 'Packed', 'Delivered'];
    final activeCount = (progress <= 0.0) ? 1 : (progress >= 1.0 ? 5 : (progress * 5).ceil());
    return Column(
      children: [
        Stack(
          children: [
            Container(height: 2, width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(999))),
            Positioned(
              left: 8,
              child: Container(height: 2, width: (width - 16) * progress, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(999))),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(stages.length, (i) {
            final active = i < activeCount;
            return SizedBox(
              width: i == 2 ? 48 : 32,
              child: Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: active ? accent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stages[i],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(fontSize: 9, fontWeight: active ? FontWeight.w700 : FontWeight.w600, color: active ? accent : Colors.grey[500]),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  final DetailItem item;
  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFFF1F5F9), border: Border.all(color: const Color(0xFFF1F5F9))),
            clipBehavior: Clip.antiAlias,
            child: Image.network(item.imageUrl, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                Text(item.subtitle, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                      child: Text('Qty: ${item.qty}', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey[700])),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (item.strikePrice != null) Text('₹${item.strikePrice!.toStringAsFixed(2)}', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                        Text('₹${item.price.toStringAsFixed(2)}', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF58A39B))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _renderItems(List<DetailItem> items) {
  final widgets = <Widget>[];
  for (var i = 0; i < items.length; i++) {
    widgets.add(_ItemRow(item: items[i]));
    if (i != items.length - 1) {
      widgets.add(Container(height: 1, color: const Color(0xFFF1F5F9)));
    }
  }
  return widgets;
}

List<DetailItem> _defaultItems() {
  return const [
    DetailItem(
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDaQstNZVP1oZH4O5h16fO9ioiTeExi-qJb0vLmxE-JTd_CLmXjts84uRdSXDLsjMTgi7uDE46mc5GkJzE38jbNQiH6FxKPJxsRO1ZhwkDjHBPJCaPkJ6LRx7clVYA3vWolYvotask9nnyxZXtxQdEsIKideoA4tKEhluhFDYA6aA82dTlkfW-UR066HTH9ldYg0ZA2F9u9GicQyg0VoiU54bYyYvUnG5TtocJFDGPpO8Fde2Z4azKsK9tOpX16_3oLGOpdZgjE0m29',
      title: 'Emerald Silk Lehenga',
      subtitle: 'Size: M • Color: Green',
      qty: 1,
      price: 450.00,
    ),
    DetailItem(
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCGXSSZVwRdfhj82iLbYc_Y0ASgRfE-jmtrsw9thLU_tz2ACCgxXSQPjkTKGdKPGY7BmifaJPohl2d-iag31XHOgBkR2AsH69n66D_iULfD6PCAd_C9ygEPaCSP-lfuPmHpxwLGoTy8kwsAr1VQ4I_FU7-MeQOSURPCTt5SDMm72ylJquJ4nal7WwwDSbGDF_Elr6pyKKPzJOS6va67G65T-yb_Dkn6SDXIii-6cTdKjFGPJXFIwpVq3YjNpXiAILdf0NNGA6N-EW-U',
      title: 'Custom Blouse Stitching',
      subtitle: 'Pattern: Deep Neck',
      qty: 1,
      price: 75.00,
      strikePrice: 85.00,
    ),
    DetailItem(
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAGSktp1ffkTi11jErtxBFxIBNZqWHqfJbvmwVPlDO661vEYTRmIcMZN_E9LAksPIpviyZAV379DHkyCGug-BvYWxm4S4ze0fzPLMq1yokVpMkxNY05Gn-wRO-LXx64TOX-Tzz3_Hu63U5Jpha2HsIeAUdLhvJYg1lGHOrAlWIvlvd1Y6LhV9GWShAww1bE7JCt7Hw-Y0z-l1HzeDG8q67sr_37bKtuW6kFlFdT3eSu2pUUN7PktbGvcIAz9qMYHaW2e91Myeo5maWq',
      title: 'Dupatta Embroidery',
      subtitle: 'Design: Gold Border',
      qty: 1,
      price: 45.00,
    ),
  ];
}

Color _statusBgColor(String status) {
  switch (status.toLowerCase()) {
    case 'delivered':
      return const Color(0xFFD1FAE5);
    case 'ready for pickup':
      return const Color(0xFFE0F2F1);
    case 'cancelled':
      return const Color(0xFFFECACA);
    case 'processing':
    default:
      return const Color(0xFFFFF3C7);
  }
}

Color _statusTextColor(String status) {
  switch (status.toLowerCase()) {
    case 'delivered':
      return const Color(0xFF065F46);
    case 'ready for pickup':
      return const Color(0xFF3D736E);
    case 'cancelled':
      return const Color(0xFF991B1B);
    case 'processing':
    default:
      return const Color(0xFFB45309);
  }
}

Color _statusRingColor(String status) {
  switch (status.toLowerCase()) {
    case 'delivered':
      return const Color(0xFF10B981);
    case 'ready for pickup':
      return const Color(0xFF58A39B);
    case 'cancelled':
      return const Color(0xFF991B1B);
    case 'processing':
    default:
      return const Color(0xFFB45309);
  }
}
