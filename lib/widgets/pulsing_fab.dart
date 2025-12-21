import 'package:flutter/material.dart';

class PulsingFab extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;
  const PulsingFab({super.key, required this.controller, required this.color, required this.icon, required this.onPressed});

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
          foregroundColor: Colors.white,
          elevation: 0,
          onPressed: onPressed,
          child: Icon(icon),
        ),
      ),
    );
  }
}
