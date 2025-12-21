import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'lists.dart';
import 'package:crama/billing/billing_page.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Design Colors
  static const Color primaryColor = Color(0xFF58A39B);
  static const Color backgroundLight = Color(0xFFF7F8F6);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF141B0E);
  static const Color textSecondary = Color(0xFF5E6E52);

  int todaysSales = 840;
  int activeOrders = 15;
  String currentDate = "Oct 24, 2023"; // In a real app, use DateTime.now()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundLight,
      drawer: _buildDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.41, 0.81],
            colors: [
              Color(0xFF58A39B),
              Color(0xFF92B3A9),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    color: backgroundLight,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRevenueCard(),
                          const SizedBox(height: 24),
                          Text(
                            "Quick Actions",
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textMain,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildQuickActions(),
                          const SizedBox(height: 40), // Bottom padding
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
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.menu, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chic Boutique",
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    currentDate,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuC6lwNYWA1pLXMALT03RKbuVZJBcJiA8sTiFOolzTT-XMqnuLTTaEvpZB-g_d_MZq2X0hKRe5DQ7BxcNuqwyDA_HSPnHohJIFvAikcsj2_w3HhGi8PwzHf7HLL5wyhZ5CK5YC8Bo-2GFpMte9Agg6S6AlBT-oWSxBdL2tGr6CpiL5WU87yq1FCpFexqryEPTu_98RtD5u6HLnmz4Y1xQOEIWTagx2scpfzfZYCTQNfVm72CMK5m6DOfacZRTlhJ0xZoCxCMSneZ9Frh"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF141B0E).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background blobs for decoration
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TOTAL REVENUE TODAY",
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const Icon(Icons.payments_outlined, color: primaryColor),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "\$${todaysSales.toStringAsFixed(2)}",
                style: GoogleFonts.manrope(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: textMain,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.trending_up, size: 16, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          "+12% vs yesterday",
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "$activeOrders Orders processed",
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
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

  Widget _buildQuickActions() {
    return Column(
      children: [
        _buildActionItem(
          icon: Icons.add,
          title: "New Bill",
          subtitle: "Create invoice for customer",
          isPrimary: true,
          onTap: () => Navigator.pushNamed(context, BillingScreen.routeName),
        ),
        const SizedBox(height: 12),
        _buildActionItem(
          icon: Icons.sell_outlined,
          title: "Orders",
          onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const OrdersListScreen())),
        ),
        const SizedBox(height: 12),
        _buildActionItem(
          icon: Icons.inventory_2_outlined,
          title: "Inventory",
          onTap: () {}, // Add navigation
        ),
        const SizedBox(height: 12),
        _buildActionItem(
          icon: Icons.groups_outlined,
          title: "Customers",
          onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const CustomersListScreen())),
        ),
        const SizedBox(height: 12),
        _buildActionItem(
          icon: Icons.badge_outlined,
          title: "Staff",
          onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const StaffListScreen())),
        ),
        const SizedBox(height: 12),
        _buildActionItem(
          icon: Icons.bar_chart_outlined,
          title: "Reports",
          onTap: () {}, // Add navigation
        ),
        const SizedBox(height: 12),
        _buildActionItem(
          icon: Icons.settings_outlined,
          title: "Settings",
          onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const SettingsScreen())),
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    String? subtitle,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF141B0E).withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isPrimary ? primaryColor : primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isPrimary ? Colors.white : primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textMain,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: surfaceLight,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Menu",
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDrawerItem(
                  icon: Icons.home,
                  label: "Home",
                  isSelected: true,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 8),
                _buildDrawerItem(
                  icon: Icons.receipt_long,
                  label: "History",
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const OrdersListScreen()));
                  },
                ),
                const SizedBox(height: 8),
                _buildDrawerItem(
                  icon: Icons.person,
                  label: "Profile",
                  isSelected: false,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey[400],
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? primaryColor : textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
