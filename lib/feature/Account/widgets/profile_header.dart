import 'package:flutter/material.dart';

Widget profileHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 30),
    width: double.infinity,
    decoration: const BoxDecoration(
      color: Color(0xFF09338C),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
    ),
    child: Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 50, color: Color(0xFF09338C)),
        ),
        const SizedBox(height: 15),
        const Text(
          "Chef User",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "chef.user@example.com",
          style: TextStyle(color: Colors.white.withAlpha(204), fontSize: 14),
        ),
      ],
    ),
  );
}
