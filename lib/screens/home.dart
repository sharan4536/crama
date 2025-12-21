import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import '../widgets/glass_card.dart';
import '../widgets/progress_ring.dart';
import '../widgets/pulsing_fab.dart';
import '../widgets/blur_bottom_nav.dart';
import '../widgets/ios_transitions.dart';
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
  void _handleNavChange(int i) async {
    setState(() => _tabIndex = i);
    if (!mounted) return;
    if (i == 1) {
      await Navigator.pushNamed(context, OrdersListScreen.routeName);
    } else if (i == 2) {
      await Navigator.pushNamed(context, CustomersListScreen.routeName);
    } else if (i == 3) {
      await Navigator.pushNamed(context, StaffListScreen.routeName);
    } else if (i == 4) {
      await Navigator.pushNamed(context, '/settings');
    }
    if (!mounted) return;
    setState(() => _tabIndex = 0);
  }

  @override
  void initState() {
    super.initState();
    _fabPulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat(reverse: true);
    _scrollController = ScrollController()..addListener(() => setState(() => _scrollOffset = _scrollController.offset));
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
    const teal = Color(0xFF00D4B7);
    const coral = Color(0xFFFF6B3A);
    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: _onRefresh),
          SliverAppBar(pinned: true, backgroundColor: Colors.white, foregroundColor: teal, title: const Text('Crama'), elevation: 0),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.05),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final parallax = (_scrollOffset * 0.02) - index * 0.8;
                  return _buildCard(context, index, parallax)
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
      floatingActionButton: PulsingFab(controller: _fabPulse, color: coral, icon: Icons.add_rounded, onPressed: () { HapticFeedback.lightImpact(); }),
      bottomNavigationBar: BlurBottomNav(index: _tabIndex, onChanged: _handleNavChange),
    );
  }

  Widget _buildCard(BuildContext context, int index, double parallax) {
    switch (index) {
      case 0:
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Today’s Sales', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Transform.translate(offset: Offset(0, parallax), child: Text('₹$todaysSales', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF00D4B7))))
            ]),
          ),
        );
      case 1:
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
              SizedBox(width: 64, height: 64, child: CustomPaint(painter: ProgressRing(value: ordersProgress, color: const Color(0xFFFF6B3A)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Active Orders', style: TextStyle(fontWeight: FontWeight.w700)),
                Transform.translate(offset: Offset(0, parallax), child: Text('$activeOrders', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF00D4B7))))
              ]))
            ]),
          ),
        );
      case 2:
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Staff Present Today', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Transform.translate(offset: Offset(0, parallax), child: Text('$staffPresent', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF00D4B7))))
            ]),
          ),
        );
      case 3:
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Pending Dues', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Transform.translate(offset: Offset(0, parallax), child: Text('₹$pendingDues', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF00D4B7))))
            ]),
          ),
        );
      case 4:
        return GestureDetector(
          onTap: () {},
          child: GlassCard(
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.add_circle_rounded, color: Color(0xFFFF6B3A), size: 44), SizedBox(height: 10), Text('New Order', style: TextStyle(fontWeight: FontWeight.w700))])),
          ),
        );
      case 5:
        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ActionChip(label: 'Add Customer', icon: Icons.person_add_rounded, onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const AddCustomerScreen(), transitionsBuilder: iosSlide))),
                        _ActionChip(label: 'Mark Attendance', icon: Icons.fingerprint_rounded, onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const StaffListScreen(), transitionsBuilder: iosSlide))),
                        _ActionChip(label: 'Print Bill', icon: Icons.print_rounded, onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const BillingScreen(), transitionsBuilder: iosSlide))),
                      ],
                    ),
                  ),
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

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionChip({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D4B7);
    const coral = Color(0xFFFF6B3A);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(colors: [teal, coral]),
          boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 14, offset: Offset(0, 6))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
