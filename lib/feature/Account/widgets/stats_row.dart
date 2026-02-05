import 'package:flutter/material.dart';

Widget statRow() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem("12", "Recipes"),
        _buildStatItem("4.5k", "Calories"),
        _buildStatItem("8h", "Cooking"),
      ],
    ),
  );
}

Widget _buildStatItem(String value, String label) {
  return Column(
    children: [
      Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF09338C))),
      Text(label, style: const TextStyle(color: Colors.grey)),
    ],
  );
}