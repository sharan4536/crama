import 'package:flutter/material.dart';
import 'dart:ui';

class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const GlassCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    const lightGray = Color(0xFFF8FAFC);
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: lightGray.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            boxShadow: const [
              BoxShadow(color: Color(0x15000000), blurRadius: 24, offset: Offset(0, 12)),
            ],
          ),
          child: onTap == null
              ? child
              : Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(36),
                    child: child,
                  ),
                ),
        ),
      ),
    );
  }
}
