// lib/feature/Account/widgets/settings_list.dart

import 'package:flutter/material.dart';

Widget settingsList(BuildContext context) {
  return ListView(
    shrinkWrap: true,
    physics:
        const NeverScrollableScrollPhysics(), // Let the main screen handle scrolling if needed
    padding: const EdgeInsets.symmetric(horizontal: 10),
    children: [
      _settingsTile(Icons.favorite_border, "My Favorites", Colors.black),
      _settingsTile(Icons.history, "Cooking History", Colors.black),
      _settingsTile(Icons.notifications_none, "Notifications", Colors.black),
      _settingsTile(Icons.lock_outline, "Privacy Policy", Colors.black),
      const Divider(height: 40),

      _settingsTile(Icons.logout, "Log Out", Colors.red),
    ],
  );
}

Widget _settingsTile(IconData icon, String title, Color textColor) {
  return ListTile(
    leading: Icon(
      icon,
      color: textColor == Colors.red ? Colors.red : const Color(0xFF09338C),
    ),
    title: Text(
      title,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    onTap: () {
      // Will Add navigation or logic here
    },
  );
}
