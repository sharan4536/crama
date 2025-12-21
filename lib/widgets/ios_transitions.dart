import 'package:flutter/material.dart';

Widget iosSlide(BuildContext context, Animation<double> a, Animation<double> sa, Widget child) {
  final tween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic));
  return SlideTransition(position: a.drive(tween), child: child);
}

