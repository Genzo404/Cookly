import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/core/widgets/recipe_card.dart';
import 'package:cookly/feature/recipe_details/recipe_details_screen.dart';
import 'package:flutter/material.dart';

class FilteredRecipeList extends StatelessWidget {
  final String category;
  final String searchQuery; // Properly declare the property

  const FilteredRecipeList({
    super.key,
    required this.category,
    required this.searchQuery, // Require it in constructor
  });

  @override
  Widget build(BuildContext context) {
    // 1. Build the dynamic Query
    Query query = FirebaseFirestore.instance.collection('recipes');

    // Only filter by category if it's not 'All'
    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF09338c)));
        }
        
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("No recipes found."),
            ),
          );
        }

        // 2. Filter the documents locally based on search text
        final allDocs = snapshot.data!.docs;
        final filteredDocs = allDocs.where((doc) {
          final recipeName = (doc['name'] ?? '').toString().toLowerCase();
          return recipeName.contains(searchQuery.toLowerCase());
        }).toList();

        // Check if the search result specifically is empty
        if (filteredDocs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("No recipes match your search."),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            var data = filteredDocs[index].data() as Map<String, dynamic>;
            String docId = filteredDocs[index].id;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsScreen(
                      recipeId: docId,
                      title: data['name'] ?? 'Recipe',
                      time: "${data['time']} Min",
                      calories: "${data['calories']} Cal",
                      imageUrl: data['imageURL'] ?? "",
                      ingredients: data['ingredients'] ?? "",
                      description: data['description'] ?? "",
                      recipe: data, // Pass the data map
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
    );
  }
}