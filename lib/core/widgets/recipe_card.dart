import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String time;
  final String calories;
  final String imageUrl;

  const RecipeCard({
    super.key,
    required this.title,
    required this.time,
    required this.calories,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 250, // Fixed height to prevent layout collapsing
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: BuildRecipeImage(imageUrl),
            ),
          ),
          
          // Information Section
          Expanded( 
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Forces Row to the bottom
                children: [
                  // Title Section
                  Text(
                    title,
                    maxLines: 3, // Allows name to wrap to two lines
                    overflow: TextOverflow.ellipsis, 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.2,
                    ),
                  ),
                  
                  // Stats Row (Calories and Time)
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Color(0xFFe55f49),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        calories, // Ensure your data doesn't double up "Cal"
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Spacer(),
                      const Icon(Icons.timer, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        time, // Ensure your data doesn't double up "Min"
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated Helper Function for Images
// ignore: non_constant_identifier_names
Widget BuildRecipeImage(String url) {
  if (url.isEmpty) {
    return Image.asset(
      'assets/images/placeholder.jpg',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.fastfood, color: Colors.grey),
      ),
    );
  }

  if (url.startsWith('http')) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  } else {
    return Image.asset(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    );
  }
}