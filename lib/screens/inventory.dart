import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'inventory/add_product.dart';
import 'inventory/product_details.dart';
import '../models/product.dart';

const Color textMain = Color(0xFF121713);
const Color textMuted = Color(0xFF667085);
const Color surfaceLight = Color(0xFFFFFFFF);

class InventoryScreen extends StatefulWidget {
  static const routeName = '/inventory';
  final bool isSelectionMode;
  const InventoryScreen({super.key, this.isSelectionMode = false});

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
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Product> _all = [
    Product(
      title: 'Floral Summer Dress',
      sku: 'FD-2023-001',
      price: 45.00,
      stock: 24,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDioCvInjJ6_LNODATpn6UgMu-bUyO338X2QSqKttM0iywCAaM3ZhhC2oxWsD8lW3MNCpXmmyENSkLRNDLdfu62u9NmsnNDYOVUxmSCpTxzsRTmAEMTDw3mw2vhvYCYCHbgtzkSE2PX2w1Iyi6FUHGWvQNxHmgGduBmbaqBrw1v1feJLZ-c11qdAp_b9wjaMC0FFvNvJevLBdc_1WP8DL8wFi2Poz3gefl62mvtnYQnePVbfSDNnSPCmyQxt-pNpcGI6Vcq_UN3Ylcc',
    ),
    Product(
      title: 'Silk Scarf - Blue',
      sku: 'SCF-BL-010',
      price: 22.00,
      stock: 3,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCca_dPzMxthm_fOlUIVNjQcSHEGvYWP2mA8tVU8PmAwZ7o35Pmvi26j3r4o-sDpj06uZP1lPsKIckSVRuaSmI66JpvxN8QBYXN5kt3SGA7xH5-tWcbsAjvWo5z8hICUqq0cR61DOvMgWzcZq0of1IUU8fQjfrEMLjxgBk95BbbqTRZu1XqEly6ecuRBQ-KRkb4ECaVxcIVijxii5q_cQVNSpmg0Lr0kAyk5KY4wvJjewXl2GOeLqop5E7IRviIanXJb0612rfOLJvr',
    ),
    Product(
      title: 'Leather Belt - Brown',
      sku: 'BLT-BR-001',
      price: 35.00,
      stock: 0,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDhqePxVccIA1CZwQdiyRNzLMct_HrBT0tcFCiahx03Ej85tiUkTDvL0N4zqYYlTuddBo_LSe7A116nnje8re-M_rcmXNqkIFOhLtOZs2Hxj6YewVW8L2Nko-doNwdbhvTH07biPZJjh5Z55UcvYNa9ChZBnM28Fgj3eWWPTA3OjB_v3EtAP1wVPXrEclBTmnBogQVP7Cvqfbfy6tFpyR0vD9b-kKAh4-lN884cIQ6dP3NxbPGq8ii3XGqfQCFw6RJRbx-QT4UpsI8D',
    ),
    Product(
      title: 'Running Sneakers',
      sku: 'SNK-RD-42',
      price: 89.99,
      stock: 18,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDBvwJpnIvvuWpd_aAiqHl6tuzJVWN-bv0bDS0wm61ce3Vwg-Ljy2RlFMPzkfdKq9rAIv-kv_fQgDi5MI_vI_qqGYcynJiKeQtvtZKGENyJ6YDlzf-qkv9zql1_ckXBujJQJzzh8aqBc8Cj1nEa9fQQWesZ3yLcHIuJRV_tUVGPm8YbJgJlhETJtQnQBTgHHCA3ewXd6G7giK9j43s2J-zC32F-zIChRE4lGvaUxfFTbCNxGgT_DPvpCI6qE5BZcbCnspy9hqrRibsl',
    ),
    Product(
      title: 'Canvas Tote Bag',
      sku: 'TOTE-CL-020',
      price: 15.00,
      stock: 4,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDVpzJy7xamu4taxpVTiguNXNZYU_g7-9lrWKDhddfF71sgNXrAmJx0mq9cew_v-xAiHtkZ8nBMHvLBom1--ffKNowBHy_96DdLffiVDaJwUVyno0lrKwhthdSwd4clWCpOMUGYuxyBhE37ZzVrGoW_tNwGQrebSqOx302DUs2bI3XsLZjqIohzGisZ1A7gxR2DeJQO4A4BKt3KuLqSQg-IG1-JldD3ntXox_bLAcUHffJFBeTlL39qhSc9WOH-gKKMm-zHFpJQ0Ua2',
    ),
  ];

  List<Product> get _lowStock => _all.where((p) => p.stock > 0 && p.stock <= 5).toList();
  List<Product> get _outOfStock => _all.where((p) => p.stock == 0).toList();

  double get _totalValue => _all.fold(0, (sum, item) => sum + (item.price * item.stock));

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleProductUpdate(Product oldProduct, Product newProduct) {
    setState(() {
      final index = _all.indexOf(oldProduct);
      if (index != -1) {
        _all[index] = newProduct;
      }
    });
  }

  String _formatCurrency(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return '₹$whole.${parts[1]}';
  }

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
                    if (_isSearching)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                style: GoogleFonts.manrope(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Search products...',
                                  hintStyle: GoogleFonts.manrope(color: Colors.white.withOpacity(0.6)),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
                                ),
                                onChanged: (value) => setState(() {}),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _iconButton(Icons.close, Colors.white, () {
                            setState(() {
                              _isSearching = false;
                              _searchController.clear();
                            });
                          }),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _iconButton(Icons.arrow_back, Colors.white, () => Navigator.pop(context)),
                          Text(
                            'Inventory',
                            style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          _iconButton(Icons.search, Colors.white, () {
                            setState(() => _isSearching = true);
                          }),
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
                              _formatCurrency(_totalValue),
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
                    itemBuilder: (_, i) => _ProductCard(
                      product: _currentList[i],
                      onUpdate: (updatedProduct) => _handleProductUpdate(_currentList[i], updatedProduct),
                      isSelectionMode: widget.isSelectionMode,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!widget.isSelectionMode)
            Positioned(
              right: 24,
              bottom: 24,
              child: FloatingActionButton(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                onPressed: () async {
                final result = await Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const AddProductScreen(),
                  ),
                );

                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _all.add(Product(
                      title: result['title'],
                      sku: result['sku'],
                      price: result['price'],
                      stock: result['stock'],
                      imageUrl: result['imageUrl'],
                    ));
                  });
                }
              },
              child: const Icon(Icons.add, size: 32),
            ),
          ),
        ],
      ),
    );
  }

  List<Product> get _currentList {
    List<Product> list;
    if (_tabIndex == 0) {
      list = _all;
    } else if (_tabIndex == 1) {
      list = _lowStock;
    } else {
      list = _outOfStock;
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      return list.where((p) =>
        p.title.toLowerCase().contains(query) ||
        p.sku.toLowerCase().contains(query)
      ).toList();
    }
    return list;
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

class _ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product) onUpdate;
  final bool isSelectionMode;

  const _ProductCard({
    required this.product,
    required this.onUpdate,
    this.isSelectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Material(
        color: surfaceLight,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFF2F4F7)),
        ),
        child: InkWell(
          onTap: () async {
            if (isSelectionMode) {
              Navigator.pop(context, product);
              return;
            }
            final result = await Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ProductDetailsScreen(product: product),
              ),
            );

            if (result != null && result is Product) {
              onUpdate(result);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(12)),
                  clipBehavior: Clip.antiAlias,
                  child: _buildImage(product.imageUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold, color: textMain),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SKU: ${product.sku}',
                        style: GoogleFonts.manrope(fontSize: 12, color: textMuted),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(2)}',
                            style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF58A39B)),
                          ),
                          const Spacer(),
                          Text(
                            product.stock > 0 ? '${product.stock} in stock' : 'Out of Stock',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: product.stock > 0 ? textMuted : const Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      );
    } else {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }
  }
}
