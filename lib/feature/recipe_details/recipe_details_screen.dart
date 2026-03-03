import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/feature/recipe_details/cooking_steps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String recipeId;
  final String title;
  final String time;
  final String calories;
  final String imageUrl;
  final String ingredients;
  final String description;
  final Map<String, dynamic> recipe;

  const RecipeDetailsScreen({
    super.key,
    required this.recipeId,
    required this.title,
    required this.time,
    required this.calories,
    required this.imageUrl,
    required this.ingredients,
    required this.description,
    required this.recipe,
  });

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  //CUSTOM TOP OVERLAY NOTIFICATION
  void _showCustomToast(BuildContext context, String message) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Just below the notch
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a), // Bold dark background
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite_rounded, color: Color(0xFFe55f49)),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  //TOGGLE FAVORITE LOGIC
  Future<void> _toggleFavorite(bool isCurrentlyFav, String? favDocId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favRef = FirebaseFirestore.instance.collection('favorites');

    if (!isCurrentlyFav) {
      await favRef.add({
        'userId': user.uid,
        'recipeId': widget.recipeId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) _showCustomToast(context, "Added to Favorites ❤️");
    } else if (favDocId != null) {
      await favRef.doc(favDocId).delete();
      if (mounted) _showCustomToast(context, "Removed from Favorites");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final Size size = MediaQuery.of(context).size;

    List<String> ingredientsList = widget.ingredients.isNotEmpty
        ? widget.ingredients.split(',').map((e) => e.trim()).toList()
        : [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.5,
            child: widget.imageUrl.startsWith('http')
                ? Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) =>
                        Container(color: Colors.grey),
                  )
                : (widget.imageUrl.isNotEmpty
                      ? Image.asset(widget.imageUrl, fit: BoxFit.cover)
                      : Container(color: Colors.grey)),
          ),

          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.43),
                Container(
                  padding: const EdgeInsets.all(25),
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xFFf5f1e2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          _buildInfoItem(Icons.timer, widget.time),
                          const SizedBox(width: 20),
                          _buildInfoItem(
                            Icons.local_fire_department,
                            widget.calories,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Ingredients",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...ingredientsList.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 18,
                                color: Color(0xFFe55f49),
                              ),
                              const SizedBox(width: 10),
                              Text(item, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Pull the instructions array from the recipe map
                            // If it's empty or missing, provide a fallback message
                            List<dynamic> instructionsData =
                                widget.recipe['instructions'] ?? [];

                            // Convert List<dynamic> to List<String>
                            List<String> cookingSteps = instructionsData
                                .map((e) => e.toString())
                                .toList();

                            if (cookingSteps.isEmpty) {
                              // Optional: Show a message if no instructions exist
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "No detailed steps available for this recipe yet!",
                                  ),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CookingStepsScreen(
                                  title: widget.title,
                                  steps: cookingSteps,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF09338c),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Start Cooking",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top Action Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('favorites')
                        .where('userId', isEqualTo: user?.uid)
                        .where('recipeId', isEqualTo: widget.recipeId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      bool isFav =
                          snapshot.hasData && snapshot.data!.docs.isNotEmpty;
                      String? docId = isFav
                          ? snapshot.data!.docs.first.id
                          : null;

                      return GestureDetector(
                        onTap: () => _toggleFavorite(isFav, docId),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: const Color(0xFFe55f49),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFe55f49), size: 20),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
