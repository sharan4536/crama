import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import '../services/customer_store.dart';
import '../data/staff_store.dart';
import '../models/customer.dart';
import 'customers/add_customer.dart';
import 'customers/customer_profile.dart';
import 'orders/order_tracking.dart';
import 'staff/add_staff.dart';
import 'staff/edit_staff.dart';
import 'staff/staff_attendance.dart';

class CustomersListScreen extends StatefulWidget {
  static const routeName = '/customers';
  const CustomersListScreen({super.key});

  @override
  State<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  final _queryController = TextEditingController();
  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D4B7);
    const coral = Color(0xFFFF6B3A);
    final store = CustomerStore();
    return Scaffold(
      appBar: AppBar(title: const Text('Customers'), backgroundColor: Colors.white, foregroundColor: teal, elevation: 0),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _queryController,
            decoration: InputDecoration(hintText: 'Search by name or phone', prefixIcon: const Icon(Icons.search_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)), filled: true, fillColor: const Color(0xFFF8FAFC)),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: store,
            builder: (context, _) {
              final q = _queryController.text.trim().toLowerCase();
              final customers = store.customers.where((c) => q.isEmpty || c.name.toLowerCase().contains(q) || c.phone.toLowerCase().contains(q)).toList();
              if (customers.isEmpty) {
                return ListView(physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), children: const [SizedBox(height: 80), Center(child: Text('No customers yet'))]);
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: customers.length,
                itemBuilder: (context, index) => _CustomerRow(customer: customers[index]),
              );
            },
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(backgroundColor: coral, foregroundColor: Colors.white, onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const AddCustomerScreen())), child: const Icon(Icons.person_add_rounded)),
    );
  }
}

class OrdersListScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersListScreen({super.key});
  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  static const Color primary = Color(0xFF58A39B);
  static const Color primaryDark = Color(0xFF3D736E);
  static const Color backgroundLight = Color(0xFFF6F7F7);

  final List<String> _filters = const [
    'All Orders',
    'Processing',
    'Ready for Pickup',
    'Delivered',
    'Cancelled',
  ];
  int _selectedFilter = 0;

  List<_Order> get _orders {
    final all = <_Order>[
      const _Order(
        customerName: 'Sarah Jenkins',
        orderId: '#ORD-1024',
        dateLabel: 'Today, 10:30 AM',
        status: 'Processing',
        statusKind: _OrderStatus.processing,
        progress: 0.25,
        itemsCount: 3,
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDZyR0uo8VSzNUqAPLYQOXstLujdMcyy0WHhi0FRIudKwH08ooN1t8m-3iMD9_ympeQIeFBUfbshDCgn2P4v3Q489ywbPOC5epUDRNFkkTXDOy86atIZZyancO6797cumEm4rVGV9icWhPCmhoEvdRID0q6mYsFtYiAr4OSmJpP9MXs3MAHXoT_h5Im9B9XtWNL3MlWau0ARhNB3lKr9RYLaKpQ76D6Gd6XSz1TCpv1ZUhwJ0b4pCsLRMEz-S7-ZlYhDzO2UkoPkBNg',
      ),
      const _Order(
        customerName: 'Mike Ross',
        orderId: '#ORD-1023',
        dateLabel: 'Yesterday',
        status: 'Ready for Pickup',
        statusKind: _OrderStatus.readyForPickup,
        progress: 0.75,
        itemsCount: 1,
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDC-CIZeRB733mXRltlTTPZP-68yw2Csv9R032uhEeBCvlTKn2k73Eu5uco85MSLkPrWFdmQXskD4gmwOFKqoVkrMcUEI0iCQDFPe7PYqptD9Qdkf5sDseqZyokRffEB4ra3FwhuFjL3brDc5-iekddtF_nF26Up8XiF5-RA3xNIhfxr7bGI3R6yDZJbODxklemIIgDOl6jHQ36ELehyJV6uCNeenoqUzWfQhAVBHQSGbKJvVjKsZxVOcraF87wPgYPDKLuIcjN6LFE',
      ),
      const _Order(
        customerName: 'Jessica Pearson',
        orderId: '#ORD-1020',
        dateLabel: 'Oct 24',
        status: 'Delivered',
        statusKind: _OrderStatus.delivered,
        progress: 1.0,
        itemsCount: 2,
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAZCby4ZPaPiSm2lYm3BZNNhE8dMtiOvSCByJZMbLPiEnVHTmJmoDj4-43zqu0HlVGGMbI9zvNTiKup4axv-z2SoRYGETQgLb1PfjAQ9K_F15Ls_y29U-Fhqv8uPauGR5EDyMGLlYqDYRQGRPzHSDEc6sRE1lFSNKJ_eY6Vd_pXe7fgz0Voe6hKE_efbIN5jlWHFj0VyDlMZUkNaOBzCYPsml4xASjN6yEp15bBDx2ihdQc9yyyO0EJUMNkGOsJVdy17YFy1Kx33369',
      ),
      const _Order(
        customerName: 'Louis Litt',
        orderId: '#ORD-1015',
        dateLabel: 'Oct 20',
        status: 'Cancelled',
        statusKind: _OrderStatus.cancelled,
        progress: 0.0,
        itemsCount: 4,
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCJsHtt6crJMGuJj1kUjxURWFzoH4J1yiZ2Pfs54CEsDvT7wsiQYBHy1aV4XNCshGXeZHVDqYOjbjr48utQytW5itNk-aqeebCQ65KYHwoHpTpMTMtGMXkUmh2RFO0v34CcpBiYtWGLO9MuPQmVsKAcMVEwT0BFD8co0BeJr2njztlC-Z9NT_mv8W3gu_6GPl-zX_OrwNIGMW_s3W2VEXOOpVsYjV5kViWM7_Dljl0un44ZN1F9g8aEUqGJiTeWowQT8_hKXDktA2CM',
      ),
    ];
    switch (_selectedFilter) {
      case 1:
        return all.where((o) => o.statusKind == _OrderStatus.processing).toList();
      case 2:
        return all.where((o) => o.statusKind == _OrderStatus.readyForPickup).toList();
      case 3:
        return all.where((o) => o.statusKind == _OrderStatus.delivered).toList();
      case 4:
        return all.where((o) => o.statusKind == _OrderStatus.cancelled).toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF58A39B), Color(0xFF92B3A9)],
            stops: [0.41, 0.81],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      ),
                    ),
                    Text(
                      'Order Tracking',
                      style: GoogleFonts.manrope(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.filter_list, color: Colors.white, size: 20),
                            const SizedBox(width: 6),
                            Text('Filter', style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  child: Container(
                    color: backgroundLight,
                    child: Column(
                      children: [
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 840),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (_, i) {
                                      final selected = _selectedFilter == i;
                                      return InkWell(
                                        onTap: () => setState(() => _selectedFilter = i),
                                        borderRadius: BorderRadius.circular(24),
                                        child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: selected ? Colors.white : Colors.white.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(24),
                                            border: Border.all(color: selected ? Colors.white : Colors.white.withValues(alpha: 0.3)),
                                            boxShadow: selected
                                                ? [
                                                    BoxShadow(
                                                      color: primary.withValues(alpha: 0.1),
                                                      blurRadius: 12,
                                                      offset: const Offset(0, 4),
                                                    )
                                                  ]
                                                : null,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            _filters[i],
                                            style: GoogleFonts.manrope(
                                              fontSize: 13,
                                              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                                              color: selected ? primary : Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                                    itemCount: _filters.length,
                                  ),
                                ),
                                SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: _orders
                                        .map((o) => Padding(
                                              padding: const EdgeInsets.only(bottom: 12),
                                              child: _OrderCard(
                                                order: o,
                                                onDetails: () {
                                                  Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType.rightToLeft,
                                                      child: OrderTrackingScreen(
                                                        orderId: o.orderId,
                                                        customerName: o.customerName,
                                                        customerPhone: '+91 9876543210',
                                                        avatarUrl: o.avatarUrl,
                                                        dateLabel: 'Placed on ${o.dateLabel}',
                                                        statusText: o.status,
                                                        items: _detailItemsForOrder(o),
                                                        expectedDate: DateTime.now().add(const Duration(days: 3)),
                                                        balanceAmount: 1200,
                                                        initialStageIndex: _stageIndexForProgress(o.progress),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 4),
        child: _HoverFab(),
      ),
    );
  }

  int _stageIndexForProgress(double p) {
    if (p <= 0.0) return 0;
    if (p < 0.4) return 1;
    if (p < 0.7) return 2;
    if (p < 1.0) return 3;
    return 4;
  }
}

enum _OrderStatus { processing, readyForPickup, delivered, cancelled }

class _Order {
  final String customerName;
  final String orderId;
  final String dateLabel;
  final String status;
  final _OrderStatus statusKind;
  final double progress;
  final int itemsCount;
  final String avatarUrl;
  const _Order({
    required this.customerName,
    required this.orderId,
    required this.dateLabel,
    required this.status,
    required this.statusKind,
    required this.progress,
    required this.itemsCount,
    required this.avatarUrl,
  });
}

class _OrderCard extends StatefulWidget {
  static const Color primary = Color(0xFF58A39B);
  static const Color primaryDark = Color(0xFF3D736E);
  final _Order order;
  final VoidCallback onDetails;
  const _OrderCard({required this.order, required this.onDetails});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final statusStyle = _statusChipStyle(o.statusKind);
    Widget card = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _OrderCard.primary.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF1F5F9),
                      border: Border.all(color: Colors.white),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(o.avatarUrl, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.customerName, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF121716))),
                      Text('${o.orderId} • ${o.dateLabel}', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[600]!)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusStyle.bg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: statusStyle.ring.withValues(alpha: 0.2)),
                ),
                child: Text(o.status, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w800, color: statusStyle.text)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ProgressBar(progress: o.progress, statusKind: o.statusKind),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.shopping_bag, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text('${o.itemsCount} Items', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );

    if (o.statusKind == _OrderStatus.cancelled) {
      card = Opacity(
        opacity: 0.75,
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2126, 0.7152, 0.0722, 0, 0, //
            0.2126, 0.7152, 0.0722, 0, 0, //
            0.2126, 0.7152, 0.0722, 0, 0, //
            0, 0, 0, 1, 0, //
          ]),
          child: card,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: widget.onDetails,
        child: AnimatedScale(
          scale: _hovering ? 1.01 : 1.0,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          child: card,
        ),
      ),
    );
  }

  _StatusChipStyle _statusChipStyle(_OrderStatus kind) {
    switch (kind) {
      case _OrderStatus.processing:
        return _StatusChipStyle(bg: const Color(0xFFFFF3C7), text: const Color(0xFFB45309), ring: const Color(0xFFB45309));
      case _OrderStatus.readyForPickup:
        return _StatusChipStyle(bg: _OrderCard.primary.withValues(alpha: 0.15), text: _OrderCard.primaryDark, ring: _OrderCard.primary);
      case _OrderStatus.delivered:
        return _StatusChipStyle(bg: const Color(0xFFD1FAE5), text: const Color(0xFF065F46), ring: const Color(0xFF10B981));
      case _OrderStatus.cancelled:
        return _StatusChipStyle(bg: const Color(0xFFFECACA), text: const Color(0xFF991B1B), ring: const Color(0xFF991B1B));
    }
  }
}

List<DetailItem> _detailItemsForOrder(_Order o) {
  final base = <DetailItem>[
    const DetailItem(
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDaQstNZVP1oZH4O5h16fO9ioiTeExi-qJb0vLmxE-JTd_CLmXjts84uRdSXDLsjMTgi7uDE46mc5GkJzE38jbNQiH6FxKPJxsRO1ZhwkDjHBPJCaPkJ6LRx7clVYA3vWolYvotask9nnyxZXtxQdEsIKideoA4tKEhluhFDYA6aA82dTlkfW-UR066HTH9ldYg0ZA2F9u9GicQyg0VoiU54bYyYvUnG5TtocJFDGPpO8Fde2Z4azKsK9tOpX16_3oLGOpdZgjE0m29',
      title: 'Emerald Silk Lehenga',
      subtitle: 'Size: M • Color: Green',
      qty: 1,
      price: 450.00,
    ),
    const DetailItem(
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCGXSSZVwRdfhj82iLbYc_Y0ASgRfE-jmtrsw9thLU_tz2ACCgxXSQPjkTKGdKPGY7BmifaJPohl2d-iag31XHOgBkR2AsH69n66D_iULfD6PCAd_C9ygEPaCSP-lfuPmHpxwLGoTy8kwsAr1VQ4I_FU7-MeQOSURPCTt5SDMm72ylJquJ4nal7WwwDSbGDF_Elr6pyKKPzJOS6va67G65T-yb_Dkn6SDXIii-6cTdKjFGPJXFIwpVq3YjNpXiAILdf0NNGA6N-EW-U',
      title: 'Custom Blouse Stitching',
      subtitle: 'Pattern: Deep Neck',
      qty: 1,
      price: 75.00,
      strikePrice: 85.00,
    ),
    const DetailItem(
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAGSktp1ffkTi11jErtxBFxIBNZqWHqfJbvmwVPlDO661vEYTRmIcMZN_E9LAksPIpviyZAV379DHkyCGug-BvYWxm4S4ze0fzPLMq1yokVpMkxNY05Gn-wRO-LXx64TOX-Tzz3_Hu63U5Jpha2HsIeAUdLhvJYg1lGHOrAlWIvlvd1Y6LhV9GWShAww1bE7JCt7Hw-Y0z-l1HzeDG8q67sr_37bKtuW6kFlFdT3eSu2pUUN7PktbGvcIAz9qMYHaW2e91Myeo5maWq',
      title: 'Dupatta Embroidery',
      subtitle: 'Design: Gold Border',
      qty: 1,
      price: 45.00,
    ),
  ];
  if (o.itemsCount <= 3) return base.take(o.itemsCount).toList();
  final extra = List<DetailItem>.generate(
    o.itemsCount - 3,
    (i) => DetailItem(
      imageUrl: 'https://picsum.photos/seed/item$i/200',
      title: 'Additional Item ${i + 1}',
      subtitle: 'Custom work',
      qty: 1,
      price: 25.00 + i * 5,
    ),
  );
  return [...base, ...extra];
}
class _StatusChipStyle {
  final Color bg;
  final Color text;
  final Color ring;
  const _StatusChipStyle({required this.bg, required this.text, required this.ring});
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final _OrderStatus statusKind;
  const _ProgressBar({required this.progress, required this.statusKind});

  @override
  Widget build(BuildContext context) {
    final accent = statusKind == _OrderStatus.delivered ? const Color(0xFF10B981) : _OrderCard.primary;
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

class _HoverFab extends StatefulWidget {
  @override
  State<_HoverFab> createState() => _HoverFabState();
}

class _HoverFabState extends State<_HoverFab> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF58A39B),
        elevation: 10,
        onPressed: () {},
        child: AnimatedRotation(
          turns: _hovering ? 0.25 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
    );
  }
}

class StaffListScreen extends StatefulWidget {
  static const routeName = '/staff';
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = StaffStore();
    const primaryColor = Color(0xFF58A39B);
    const primarySoft = Color(0xFF92B3A9);
    const backgroundLight = Color(0xFFF6F7F7);

    return Scaffold(
      backgroundColor: backgroundLight,
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final query = _searchController.text.trim().toLowerCase();
          final staffList = store.staffMembers.where((s) {
            if (query.isEmpty) return true;
            return s.name.toLowerCase().contains(query) ||
                s.role.toLowerCase().contains(query) ||
                s.phone.toLowerCase().contains(query);
          }).toList();

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor, primarySoft],
                stops: [0.41, 0.81],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          ),
                        ),
                        Text(
                          'Manage Staff',
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const StaffAttendanceScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.event_available, color: Colors.white, size: 20),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const AddStaffScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.add, color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.search, color: primaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search staff by name or role...',
                                hintStyle: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[500],
                                ),
                              ),
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF121716),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Container(
                        color: backgroundLight,
                        child: staffList.isEmpty
                            ? ListView(
                                physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics(),
                                ),
                                children: [
                                  const SizedBox(height: 120),
                                  Center(
                                    child: Text(
                                      'No staff members yet',
                                      style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                                physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics(),
                                ),
                                itemCount: staffList.length,
                                itemBuilder: (context, index) {
                                  final staff = staffList[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _StaffCard(
                                      staff: staff,
                                      onEdit: () {
                                        HapticFeedback.lightImpact();
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: EditStaffScreen(
                                              name: staff.name,
                                              phone: staff.phone,
                                              role: staff.role,
                                              salaryType: staff.salaryType,
                                            ),
                                          ),
                                        );
                                      },
                                      onDelete: () {
                                        store.remove(staff.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('${staff.name} removed')),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 10,
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const AddStaffScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

class _StaffCard extends StatefulWidget {
  final Staff staff;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _StaffCard({
    required this.staff,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_StaffCard> createState() => _StaffCardState();
}

class _StaffCardState extends State<_StaffCard> {
  double? _calculatedWage;

  void _showWageDialog(BuildContext context) {
    final hoursController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Calculate Wage",
            style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Hourly Rate: \$${widget.staff.hourlyRate.toStringAsFixed(2)}/hr",
                style: GoogleFonts.manrope(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hoursController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Hours Worked",
                  hintText: "e.g. 5.5",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Cancel", style: GoogleFonts.manrope(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              onPressed: () {
                final hours = double.tryParse(hoursController.text) ?? 0.0;
                setState(() {
                  _calculatedWage = hours * widget.staff.hourlyRate;
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58A39B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Calculate", style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF58A39B);
    ImageProvider? imageProvider;
    if (widget.staff.photoPath != null && widget.staff.photoPath!.isNotEmpty) {
      if (kIsWeb) {
        imageProvider = NetworkImage(widget.staff.photoPath!);
      } else {
        final file = File(widget.staff.photoPath!);
        if (file.existsSync()) {
          imageProvider = FileImage(file);
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFF1F5F9),
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Text(
                        widget.staff.name.isNotEmpty ? widget.staff.name[0].toUpperCase() : '?',
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.staff.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF121716),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.staff.role.isEmpty ? 'Staff' : widget.staff.role,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (widget.staff.salaryType.isNotEmpty)
                      Text(
                        '${widget.staff.salaryType} • \$${widget.staff.hourlyRate.toStringAsFixed(2)}/hr',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (widget.staff.phone.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.call,
                            size: 18,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.staff.phone,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Wage Calculation badge
              if (_calculatedWage != null)
                InkWell(
                  onTap: () => _showWageDialog(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.payments, size: 16, color: Colors.green.shade700),
                        const SizedBox(width: 4),
                        Text(
                          "Wage: \$${_calculatedWage!.toStringAsFixed(2)}",
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                InkWell(
                  onTap: () => _showWageDialog(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calculate, size: 14, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          "Calculate Wage",
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Action buttons (Edit / Delete)
              Row(
                children: [
                  TextButton.icon(
                    onPressed: widget.onEdit,
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit, size: 16),
                    label: Text(
                      'Edit',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: widget.onDelete,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.delete, size: 16),
                    label: Text(
                      'Delete',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IosListScaffold extends StatefulWidget {
  final String title;
  final List<ListItemData> items;
  final Widget Function(ListItemData item) detailBuilder;
  final Widget? floatingActionButton;
  const _IosListScaffold({
    required this.title,
    required this.items,
    required this.detailBuilder,
    this.floatingActionButton,
  });
  @override
  State<_IosListScaffold> createState() => _IosListScaffoldState();
}

class _IosListScaffoldState extends State<_IosListScaffold> {
  late List<ListItemData> _items;
  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }
  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D4B7);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.white, foregroundColor: teal, elevation: 0),
      floatingActionButton: widget.floatingActionButton,
      body: ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Dismissible(
            key: ValueKey('dismiss-${item.id}'),
            background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 16), child: const Icon(Icons.delete, color: Colors.white)),
            secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), child: const Icon(Icons.delete, color: Colors.white)),
            onDismissed: (_) => setState(() => _items.removeAt(index)),
            child: _IosListItem(item: item, onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: widget.detailBuilder(item)));
            }),
          );
        },
      ),
    );
  }
}

class ListItemData {
  final String title;
  final String subtitle;
  final int id;
  const ListItemData(this.title, this.subtitle, this.id);
}

class _IosListItem extends StatefulWidget {
  final ListItemData item;
  final VoidCallback onTap;
  const _IosListItem({required this.item, required this.onTap});
  @override
  State<_IosListItem> createState() => _IosListItemState();
}

class _IosListItemState extends State<_IosListItem> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'list-item-${widget.item.id}',
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          color: const Color(0xFFF8FAFC),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(children: [
                CircleAvatar(backgroundColor: const Color(0xFF00D4B7).withValues(alpha: 0.18), child: const Icon(Icons.chevron_right_rounded, color: Color(0xFF00D4B7), size: 22)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(widget.item.subtitle, style: const TextStyle(color: Colors.black54)),
                ]))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomerRow extends StatefulWidget {
  final Customer customer;
  const _CustomerRow({required this.customer});
  @override
  State<_CustomerRow> createState() => _CustomerRowState();
}

class _CustomerRowState extends State<_CustomerRow> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    ImageProvider? avatar;
    final c = widget.customer;
    if (c.photoPath != null && c.photoPath!.isNotEmpty) {
      if (kIsWeb) {
        avatar = NetworkImage(c.photoPath!);
      } else {
        final file = File(c.photoPath!);
        if (file.existsSync()) avatar = FileImage(file);
      }
    }
    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: const Color(0xFFF8FAFC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
             HapticFeedback.lightImpact();
             Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CustomerProfileScreen(customer: c)));
          },
          onHighlightChanged: (v) => setState(() => _pressed = v),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(children: [
              CircleAvatar(radius: 22, backgroundImage: avatar, backgroundColor: const Color(0xFF00D4B7).withValues(alpha: 0.12), child: avatar == null ? const Icon(Icons.person_rounded, size: 20, color: Color(0xFF00D4B7)) : null),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(c.phone, style: const TextStyle(color: Colors.black54))]))
            ]),
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final ListItemData item;
  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D4B7);
    return Scaffold(
      appBar: AppBar(title: Text(item.title), backgroundColor: Colors.white, foregroundColor: teal, elevation: 0),
      body: Center(
        child: Hero(
          tag: 'list-item-${item.id}',
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(item.subtitle, style: const TextStyle(color: Colors.black54)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
