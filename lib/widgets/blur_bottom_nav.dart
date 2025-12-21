import 'package:flutter/material.dart';
import 'dart:ui';

class BlurBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const BlurBottomNav({super.key, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D4B7);
    const coral = Color(0xFFFF6B3A);
    final items = const [
      _NavItem(Icons.home_rounded, 'Home'),
      _NavItem(Icons.receipt_long_rounded, 'Orders'),
      _NavItem(Icons.people_rounded, 'Customers'),
      _NavItem(Icons.badge_rounded, 'Staff'),
      _NavItem(Icons.settings_rounded, 'Settings'),
    ];
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
            boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, -8))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == index;
              return GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedScale(
                  scale: selected ? 1.12 : 1.0,
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selected ? (i % 2 == 0 ? teal : coral) : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(items[i].icon, color: selected ? Colors.white : Colors.black54, size: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        items[i].label,
                        style: TextStyle(
                          color: selected ? (i % 2 == 0 ? teal : coral) : Colors.black87,
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
