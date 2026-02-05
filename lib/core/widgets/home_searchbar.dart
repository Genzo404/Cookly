import 'package:flutter/material.dart';

class HomeSearchbar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const HomeSearchbar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // Step B: Connects to the logic
      onChanged: onChanged, // Step B: Sends text back to HomeScreen
      decoration: InputDecoration(
        hintText: 'Search a recipe...',
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF1a1a1a)),
        // Added a clear button that appears when typing
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
