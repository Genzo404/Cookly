import 'package:cookly/core/widgets/show_logout_dialog.dart';
import 'package:cookly/feature/Add%20Recipe/add_recipe_screen.dart';

import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.logout, color: Color(0xFF09338c), size: 28),
          onPressed: () => showLogoutDialog(context),
        ),
        const Expanded(
          child: Text(
            'What are you cooking today?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRecipeScreen()),
            );
          },
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.add, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
