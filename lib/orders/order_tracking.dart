import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderTrackingScreen extends StatefulWidget {
  static const routeName = '/order-tracking';
  final String orderId;
  final String customerName;
  final String? customerPhone;
  final DateTime expectedDate;
  final int balanceAmount;
  final int? initialStageIndex;
  const OrderTrackingScreen({
    super.key,
    required this.orderId,
    required this.customerName,
    this.customerPhone,
    required this.expectedDate,
    required this.balanceAmount,
    this.initialStageIndex,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  static const stages = [
    'Received',
    'Cutting',
    'Stitching',
    'Embroidery',
    'Dyeing',
    'Trial',
    'Ready',
    'Delivered',
  ];

  static const icons = [
    Icons.inbox,
    Icons.content_cut,
    Icons.straighten,
    Icons.brush,
    Icons.color_lens,
    Icons.checkroom,
    Icons.done_all,
    Icons.local_shipping,
  ];

  late int _stageIndex;
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stageIndex = widget.initialStageIndex?.clamp(0, stages.length - 1) ?? 0;
    _phoneController.text = widget.customerPhone ?? '';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _advanceStage() async {
    if (_stageIndex < stages.length - 1) {
      setState(() => _stageIndex++);
      await _sendWhatsApp(stages[_stageIndex]);
    }
  }

  Future<void> _sendWhatsApp(String stage) async {
    final phoneRaw = _phoneController.text.trim();
    if (phoneRaw.isEmpty) return;
    final phoneDigits = phoneRaw.replaceAll(RegExp(r'[^\d]'), '');
    final normalized = phoneDigits.startsWith('91') || phoneDigits.startsWith('+91')
        ? phoneDigits.replaceFirst('+', '')
        : '91$phoneDigits';
    final message = 'Hi mam, your order is now in $stage stage]';
    final uri = Uri.parse('https://wa.me/$normalized?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF1A237E);
    const gold = Color(0xFFFFD700);
    final eta = '${widget.expectedDate.day}-${widget.expectedDate.month}-${widget.expectedDate.year}';
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking'), backgroundColor: indigo, elevation: 0),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.orderId, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                          const SizedBox(height: 6),
                          Text(widget.customerName, style: const TextStyle(color: Colors.black54)),
                          const SizedBox(height: 6),
                          Text('Expected: $eta', style: const TextStyle(color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text('Balance: ₹${widget.balanceAmount}', style: const TextStyle(fontWeight: FontWeight.w700, color: indigo)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d +-]'))],
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Order Stages', style: TextStyle(fontWeight: FontWeight.w700, color: indigo)),
            const SizedBox(height: 8),
            _StagesBar(currentIndex: _stageIndex),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _advanceStage,
                child: const Text('Change Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StagesBar extends StatelessWidget {
  final int currentIndex;
  const _StagesBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF1A237E);
    const gold = Color(0xFFFFD700);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_OrderTrackingScreenState.stages.length * 2 - 1, (i) {
          if (i.isOdd) {
            final segIndex = (i - 1) ~/ 2;
            final done = segIndex < currentIndex;
            return Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: done ? gold : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          } else {
            final stageIndex = i ~/ 2;
            final active = stageIndex == currentIndex;
            final done = stageIndex < currentIndex;
            final color = active ? gold : (done ? indigo : Colors.black12);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: color.withValues(alpha: active ? 1.0 : 0.2),
                    child: Icon(
                      _OrderTrackingScreenState.icons[stageIndex],
                      color: active ? Colors.black : (done ? Colors.white : Colors.black54),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _OrderTrackingScreenState.stages[stageIndex],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      color: active ? gold : (done ? indigo : Colors.black54),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}

