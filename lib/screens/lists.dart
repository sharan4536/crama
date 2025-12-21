import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';
import '../services/customer_store.dart';
import '../models/customer.dart';
import 'customers/add_customer.dart';
import 'customers/customer_profile.dart';
import 'orders/order_tracking.dart';
import 'staff/add_staff.dart';
import 'staff/edit_staff.dart';

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

class OrdersListScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = List.generate(20, (i) => ListItemData('Order #${1000 + i}', 'In progress', i));
    return _IosListScaffold(title: 'Orders', items: items, detailBuilder: (item) => OrderTrackingScreen(orderId: item.title, customerName: 'Customer ${item.id}', customerPhone: '+91 9876543210', expectedDate: DateTime.now().add(const Duration(days: 5)), balanceAmount: 1200, initialStageIndex: 1));
  }
}

class StaffListScreen extends StatelessWidget {
  static const routeName = '/staff';
  const StaffListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = List.generate(20, (i) => ListItemData('Staff #$i', 'Present', i));
    const coral = Color(0xFFFF6B3A);
    return _IosListScaffold(
      title: 'Staff',
      items: items,
      detailBuilder: (item) => EditStaffScreen(name: item.title, role: 'Tailor'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: coral,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const AddStaffScreen())),
        child: const Icon(Icons.person_add_rounded),
      ),
    );
  }
}

class _IosListScaffold extends StatefulWidget {
  final String title;
  final List<ListItemData> items;
  final Widget Function(ListItemData item) detailBuilder;
  final Widget? floatingActionButton;
  const _IosListScaffold({required this.title, required this.items, required this.detailBuilder, this.floatingActionButton});
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
      final file = File(c.photoPath!);
      if (file.existsSync()) avatar = FileImage(file);
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
