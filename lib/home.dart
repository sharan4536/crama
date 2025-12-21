import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'lists.dart';
import 'customers/add_customer.dart';
import 'billing/billing_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<int> _cardSlots = List.generate(6, (i) => i);
  int todaysSales = 85000;
  int activeOrders = 28;
  double ordersProgress = 0.65;
  int staffPresent = 12;
  int pendingDues = 12300;

  late final AnimationController _fabPulse;
  late final ScrollController _scrollController;
  double _scrollOffset = 0;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _fabPulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() => _scrollOffset = _scrollController.offset);
      });
  }

  @override
  void dispose() {
    _fabPulse.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF1A237E);
    const gold = Color(0xFFFFD700);
    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: _onRefresh),
          SliverAppBar(
            pinned: true,
            backgroundColor: indigo,
            title: const Text('Crama'),
            elevation: 0,
          ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.05,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final parallax = (_scrollOffset * 0.02) - index * 0.8;
              return _buildCard(index, parallax)
                  .animate(delay: (index * 120).ms)
                  .fadeIn(duration: 380.ms, curve: Curves.easeOut)
                  .scale(begin: const Offset(0.92, 0.92));
            },
            childCount: _cardSlots.length,
          ),
        ),
      ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _PulsingFab(controller: _fabPulse, color: gold, icon: Icons.add),
      bottomNavigationBar: _BlurBottomNav(
        index: _tabIndex,
        onChanged: (i) => setState(() => _tabIndex = i),
      ),
    );
  }

  Widget _buildCard(int index, double parallax) {
    switch (index) {
      case 0:
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Today’s Sales', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Transform.translate(
                  offset: Offset(0, parallax),
                  child: Text('₹$todaysSales', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1A237E))),
                ),
                const Spacer(),
                const Text('ఈరోజు అమ్మకాలు', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        );
      case 1:
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CustomPaint(painter: ProgressRing(value: ordersProgress, color: const Color(0xFFFFD700))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Active Orders', style: TextStyle(fontWeight: FontWeight.w700)),
                      Transform.translate(
                        offset: Offset(0, parallax),
                        child: Text('$activeOrders', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A237E))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case 2:
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Staff Present Today', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Transform.translate(
                  offset: Offset(0, parallax),
                  child: Text('$staffPresent', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1A237E))),
                ),
                const Spacer(),
                const Text('హాజరు', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        );
      case 3:
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pending Dues', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Transform.translate(
                  offset: Offset(0, parallax),
                  child: Text('₹$pendingDues', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1A237E))),
                ),
                const Spacer(),
                const Text('Due till today', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        );
      case 4:
        return GestureDetector(
          onTap: () {},
          child: GlassCard(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add_circle, color: Color(0xFFFFD700), size: 40),
                  SizedBox(height: 8),
                  Text('New Order', style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        );
      case 5:
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ActionChip(label: 'Add Customer', icon: Icons.person_add, onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const AddCustomerScreen(), transitionsBuilder: _iosSlide))),
                    _ActionChip(label: 'Mark Attendance', icon: Icons.fingerprint, onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const StaffListScreen(), transitionsBuilder: _iosSlide))),
                    _ActionChip(label: 'Print Bill', icon: Icons.print, onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const BillingScreen(), transitionsBuilder: _iosSlide))),
                  ],
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

 

// Removed old route helper; cards now define actions explicitly.

Widget _iosSlide(BuildContext context, Animation<double> a, Animation<double> sa, Widget child) {
  final tween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic));
  return SlideTransition(position: a.drive(tween), child: child);
}

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class ProgressRing extends CustomPainter {
  final double value; // 0..1
  final Color color;
  ProgressRing({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = Colors.white.withValues(alpha: 0.2);
    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6
      ..color = color;
    canvas.drawCircle(center, radius, bg);
    final sweep = 2 * 3.1415926 * value;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -3.1415926 / 2, sweep, false, fg);
  }

  @override
  bool shouldRepaint(covariant ProgressRing oldDelegate) => oldDelegate.value != value || oldDelegate.color != color;
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionChip({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFFFFD700)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _PulsingFab extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final IconData icon;
  const _PulsingFab({required this.controller, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.98, end: 1.06).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: Color(0x40000000), blurRadius: 22, offset: Offset(0, 12)),
            BoxShadow(color: Color(0x12000000), blurRadius: 2, offset: Offset(0, 1)),
          ],
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          backgroundColor: color,
          foregroundColor: Colors.black,
          elevation: 0,
          onPressed: () {},
          child: Icon(icon),
        ),
      ),
    );
  }
}

class _BlurBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _BlurBottomNav({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = const [
      _NavItem(Icons.home, 'Home'),
      _NavItem(Icons.assignment, 'Orders'),
      _NavItem(Icons.person, 'Customers'),
      _NavItem(Icons.people_alt, 'Staff'),
      _NavItem(Icons.settings, 'Settings'),
    ];
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == index;
              return GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedScale(
                  scale: selected ? 1.18 : 1.0,
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(items[i].icon, color: selected ? const Color(0xFFFFD700) : Colors.white, size: 24),
                      const SizedBox(height: 6),
                      Text(
                        items[i].label,
                        style: TextStyle(
                          color: selected ? const Color(0xFFFFD700) : Colors.white,
                          fontSize: 12,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
