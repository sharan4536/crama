import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'inventory/add_product.dart';

const Color textMain = Color(0xFF121713);
const Color textMuted = Color(0xFF667085);
const Color surfaceLight = Color(0xFFFFFFFF);

class InventoryScreen extends StatefulWidget {
  static const routeName = '/inventory';
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  static const Color primaryColor = Color(0xFF58A39B);
  static const Color gradientStart = Color(0xFF58A39B);
  static const Color gradientEnd = Color(0xFF92B3A9);
  static const Color backgroundLight = Color(0xFFF6F7F7);
  static const Color surfaceDark = Color(0xFF232924);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusDanger = Color(0xFFEF4444);

  int _tabIndex = 0;

  final List<_Product> _all = [
    _Product(
      title: 'Floral Summer Dress',
      sku: 'FD-2023-001',
      price: 45.00,
      stock: 24,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDioCvInjJ6_LNODATpn6UgMu-bUyO338X2QSqKttM0iywCAaM3ZhhC2oxWsD8lW3MNCpXmmyENSkLRNDLdfu62u9NmsnNDYOVUxmSCpTxzsRTmAEMTDw3mw2vhvYCYCHbgtzkSE2PX2w1Iyi6FUHGWvQNxHmgGduBmbaqBrw1v1feJLZ-c11qdAp_b9wjaMC0FFvNvJevLBdc_1WP8DL8wFi2Poz3gefl62mvtnYQnePVbfSDNnSPCmyQxt-pNpcGI6Vcq_UN3Ylcc',
    ),
    _Product(
      title: 'Silk Scarf - Blue',
      sku: 'SCF-BL-010',
      price: 22.00,
      stock: 3,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCca_dPzMxthm_fOlUIVNjQcSHEGvYWP2mA8tVU8PmAwZ7o35Pmvi26j3r4o-sDpj06uZP1lPsKIckSVRuaSmI66JpvxN8QBYXN5kt3SGA7xH5-tWcbsAjvWo5z8hICUqq0cR61DOvMgWzcZq0of1IUU8fQjfrEMLjxgBk95BbbqTRZu1XqEly6ecuRBQ-KRkb4ECaVxcIVijxii5q_cQVNSpmg0Lr0kAyk5KY4wvJjewXl2GOeLqop5E7IRviIanXJb0612rfOLJvr',
    ),
    _Product(
      title: 'Leather Belt - Brown',
      sku: 'BLT-BR-001',
      price: 35.00,
      stock: 0,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDhqePxVccIA1CZwQdiyRNzLMct_HrBT0tcFCiahx03Ej85tiUkTDvL0N4zqYYlTuddBo_LSe7A116nnje8re-M_rcmXNqkIFOhLtOZs2Hxj6YewVW8L2Nko-doNwdbhvTH07biPZJjh5Z55UcvYNa9ChZBnM28Fgj3eWWPTA3OjB_v3EtAP1wVPXrEclBTmnBogQVP7Cvqfbfy6tFpyR0vD9b-kKAh4-lN884cIQ6dP3NxbPGq8ii3XGqfQCFw6RJRbx-QT4UpsI8D',
    ),
    _Product(
      title: 'Running Sneakers',
      sku: 'SNK-RD-42',
      price: 89.99,
      stock: 18,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDBvwJpnIvvuWpd_aAiqHl6tuzJVWN-bv0bDS0wm61ce3Vwg-Ljy2RlFMPzkfdKq9rAIv-kv_fQgDi5MI_vI_qqGYcynJiKeQtvtZKGENyJ6YDlzf-qkv9zql1_ckXBujJQJzzh8aqBc8Cj1nEa9fQQWesZ3yLcHIuJRV_tUVGPm8YbJgJlhETJtQnQBTgHHCA3ewXd6G7giK9j43s2J-zC32F-zIChRE4lGvaUxfFTbCNxGgT_DPvpCI6qE5BZcbCnspy9hqrRibsl',
    ),
    _Product(
      title: 'Canvas Tote Bag',
      sku: 'TOTE-CL-020',
      price: 15.00,
      stock: 4,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDVpzJy7xamu4taxpVTiguNXNZYU_g7-9lrWKDhddfF71sgNXrAmJx0mq9cew_v-xAiHtkZ8nBMHvLBom1--ffKNowBHy_96DdLffiVDaJwUVyno0lrKwhthdSwd4clWCpOMUGYuxyBhE37ZzVrGoW_tNwGQrebSqOx302DUs2bI3XsLZjqIohzGisZ1A7gxR2DeJQO4A4BKt3KuLqSQg-IG1-JldD3ntXox_bLAcUHffJFBeTlL39qhSc9WOH-gKKMm-zHFpJQ0Ua2',
    ),
  ];

  List<_Product> get _lowStock => _all.where((p) => p.stock > 0 && p.stock <= 5).toList();
  List<_Product> get _outOfStock => _all.where((p) => p.stock == 0).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [gradientStart, gradientEnd],
                stops: [0.41, 0.81],
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _iconButton(Icons.arrow_back, Colors.white, () => Navigator.pop(context)),
                        Text(
                          'Inventory',
                          style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        _iconButton(Icons.search, Colors.white, () {}),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Value',
                              style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.8), letterSpacing: 0.6),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹12,450.00',
                              style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(height: 4, decoration: const BoxDecoration(color: backgroundLight, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)))),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                child: _buildTabs(),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: backgroundLight,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: _currentList.length,
                    itemBuilder: (_, i) => _ProductCard(product: _currentList[i]),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: FloatingActionButton(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const AddProductScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add, size: 32),
            ),
          ),
        ],
      ),
    );
  }

  List<_Product> get _currentList {
    if (_tabIndex == 0) return _all;
    if (_tabIndex == 1) return _lowStock;
    return _outOfStock;
  }

  Widget _iconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9999),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _TabButton(
          selected: _tabIndex == 0,
          label: 'All Products',
          tagColor: primaryColor,
          count: _all.length,
          onTap: () => setState(() => _tabIndex = 0),
        ),
        const SizedBox(width: 12),
        _TabButton(
          selected: _tabIndex == 1,
          label: 'Low Stock',
          tagColor: statusWarning,
          count: _lowStock.length,
          onTap: () => setState(() => _tabIndex = 1),
        ),
        const SizedBox(width: 12),
        _TabButton(
          selected: _tabIndex == 2,
          label: 'Out of Stock',
          tagColor: statusDanger,
          count: _outOfStock.length,
          onTap: () => setState(() => _tabIndex = 2),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final bool selected;
  final String label;
  final Color tagColor;
  final int count;
  final VoidCallback onTap;
  const _TabButton({required this.selected, required this.label, required this.tagColor, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 3, color: selected ? tagColor : Colors.transparent),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(fontSize: 13, fontWeight: selected ? FontWeight.w800 : FontWeight.w600, color: selected ? tagColor : textMuted),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: selected ? tagColor.withOpacity(0.1) : const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(9999)),
              child: Text(
                '$count',
                style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? tagColor : textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Product {
  final String title;
  final String sku;
  final double price;
  final int stock;
  final String imageUrl;
  const _Product({required this.title, required this.sku, required this.price, required this.stock, required this.imageUrl});
}

class _ProductCard extends StatelessWidget {
  final _Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F4F7)),
        boxShadow: const [
          BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: Image.network(product.imageUrl, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800, color: textMain)),
                const SizedBox(height: 4),
                Text('SKU: ${product.sku}', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: textMuted)),
                const SizedBox(height: 4),
                Text('₹${product.price.toStringAsFixed(2)}', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800, color: textMain)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _stockBg(product.stock),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${product.stock}',
                  style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: _stockFg(product.stock)),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20)),
            ],
          ),
        ],
      ),
    );
  }

  Color _stockBg(int stock) {
    if (stock == 0) return const Color(0xFFFFF1F1);
    if (stock <= 5) return const Color(0xFFFFF8E1);
    return const Color(0xFFEFFDF5);
  }

  Color _stockFg(int stock) {
    if (stock == 0) return const Color(0xFFEF4444);
    if (stock <= 5) return const Color(0xFFF59E0B);
    return const Color(0xFF22C55E);
  }
}
