import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/feature/recipe_details/recipe_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cookly/core/widgets/recipe_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFf5f1e2), // Theme background
      appBar: AppBar(
        toolbarHeight: 100, // Higher toolbar to move title down
        automaticallyImplyLeading: false, // Removes back button
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 20, left: 4), 
          child: Text(
            "Saved Recipes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a1a1a), // Bold Home-style color
              fontSize: 28, // Bold Home-style size
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFe55f49)),
            );
          }

          final favDocs = snapshot.data?.docs ?? [];

          if (favDocs.isEmpty) {
            return _buildEmptyState();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 260, // Prevents overflow
              ),
              itemCount: favDocs.length,
              itemBuilder: (context, index) {
                String rId = favDocs[index]['recipeId'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('recipes')
                      .doc(rId)
                      .get(),
                  builder: (context, recipeSnap) {
                    if (!recipeSnap.hasData) return const SizedBox();

                    var data = recipeSnap.data!.data() as Map<String, dynamic>;

                    // FIXED: Wrap the RecipeCard in GestureDetector
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailsScreen(
                              recipe: data,
                              recipeId: rId,
                              title: data['name'] ?? '',
                              time: "${data['time']} Min",
                              calories: "${data['calories']} Cal",
                              imageUrl: data['imageURL'] ?? '',
                              ingredients: data['ingredients']?.toString() ?? '',
                              description: data['description'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: RecipeCard(
                        title: data['name'] ?? '',
                        time: "${data['time']} Min",
                        calories: "${data['calories']} Cal",
                        imageUrl: data['imageURL'] ?? '',
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_rounded,
            size: 80,
            color: const Color(0xFFe55f49).withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            "No favorites yet!",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF1a1a1a),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Heart your top picks to see them here.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}