import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D4B7);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: teal,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SettingTile(icon: Icons.person_rounded, title: 'Profile'),
          _SettingTile(icon: Icons.chat_bubble_rounded, title: 'WhatsApp Templates'),
          _SettingTile(icon: Icons.print_rounded, title: 'Printer Connection'),
          _SettingTile(icon: Icons.receipt_long_rounded, title: 'Billing Preferences'),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SettingTile({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: const Color(0xFF00D4B7).withValues(alpha: 0.16), child: Icon(icon, color: const Color(0xFF00D4B7))),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
    );
  }
}
